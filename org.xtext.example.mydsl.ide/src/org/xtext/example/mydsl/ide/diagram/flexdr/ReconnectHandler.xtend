package org.xtext.example.mydsl.ide.diagram.flexdr

import com.google.inject.Inject
import org.eclipse.lsp4j.Range
import org.eclipse.lsp4j.TextEdit
import org.eclipse.lsp4j.WorkspaceEdit
import org.eclipse.sprotty.SEdge
import org.eclipse.sprotty.SModelElement
import org.eclipse.sprotty.SModelIndex
import org.eclipse.sprotty.xtext.ILanguageAwareDiagramServer
import org.eclipse.sprotty.xtext.ReconnectAction
import org.eclipse.sprotty.xtext.WorkspaceEditAction
import org.eclipse.sprotty.xtext.tracing.PositionConverter
import org.eclipse.sprotty.xtext.tracing.XtextTrace
import org.eclipse.xtext.ide.server.ILanguageServerAccess
import org.eclipse.xtext.ide.server.UriExtensions
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import static extension org.eclipse.xtext.EcoreUtil2.*
import org.xtext.example.mydsl.myDsl.DecisionRecord
import org.xtext.example.mydsl.myDsl.Model

class ReconnectHandler {
	
	@Inject UriExtensions uriExtensions
	@Inject extension PositionConverter
	
	def handle(ReconnectAction action, ILanguageAwareDiagramServer server) {
		val root = server.diagramState.currentModel
		val extension index = new SModelIndex(root)
		val routable = action.routableId?.get
		val source = action.newSourceId?.get
		val target = action.newTargetId?.get
		server.diagramLanguageServer.languageServerAccess.doRead(server.sourceUri, [ context |
			val sourceElement = source?.resolveElement(context)
			val targetElement = target?.resolveElement(context)
			if (sourceElement instanceof DecisionRecord && targetElement instanceof DecisionRecord) {
				val textEdits = newArrayList
				val eventName = sourceElement.getContainerOfType(Model)?.getRecords()?.get(0).getTitle() ?: 'undefined'
				val transitionText = '''«'\n\t'»«eventName» => «(targetElement as DecisionRecord).getTitle()»'''
				val oldRange = getOldRange(routable)
				val newRange = getNewRange(sourceElement as DecisionRecord)
				if (oldRange !== null) {
					if ((routable as SEdge).sourceId !== action.newSourceId) {
						textEdits += new TextEdit(oldRange, '')
						textEdits += new TextEdit(newRange, transitionText)
					} else {
						textEdits += new TextEdit(oldRange, transitionText)
					}
				} else {
					textEdits += new TextEdit(newRange, transitionText)
				}
				val workspaceEdit = new WorkspaceEdit() => [
					changes = #{ server.sourceUri -> textEdits }
				]
				server.dispatch(new WorkspaceEditAction => [
					it.workspaceEdit = workspaceEdit
				]);
				}
			return null
		])
	}
	
	private def getOldRange(SModelElement routable) {
		if (routable?.trace !== null) 
			new XtextTrace(routable.trace).range
		else 
			null
	}
	
	private def getNewRange(DecisionRecord sourceElement) {
		val position = NodeModelUtils.findActualNodeFor(sourceElement).endOffset.toPosition(sourceElement)
		return new Range(position, position)
	}
	
	
	private def resolveElement(SModelElement sElement, ILanguageServerAccess.Context context) {
		if (sElement.trace !== null) {
			val connectableURI = sElement.trace.toURI
			return context.resource.resourceSet.getEObject(connectableURI, true);
		} else {
			return null
		}
	}
	
	private def toURI(String path) {
		val parts = path.split('#')
		if(parts.size !== 2)
			throw new IllegalArgumentException('Invalid trace URI ' + path)
		return uriExtensions.toUri(parts.head).trimQuery.appendFragment(parts.last)
	}
}
