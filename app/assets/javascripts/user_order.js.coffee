# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
	$('#menu_items').dataTable
		sPaginationType: "bootstrap"	
		bProcessing: true
		bServerSide: true
		sAjaxSource: $('#menu_items').data('source')
		oLanguage: 
			sProcessing:   "Bitte warten..."
			sLengthMenu:   "_MENU_ Einträge anzeigen"
			sZeroRecords:  "Keine Einträge vorhanden."
			sInfo:         "_START_ bis _END_ von _TOTAL_ Einträgen"
			sInfoEmpty:    "0 bis 0 von 0 Einträgen"
			sInfoFiltered: "(gefiltert von _MAX_  Einträgen)"
			sInfoPostFix:  ""
			sSearch:       "Suchen"
			sUrl:          ""
			oPaginate:
				sFirst:    "Erster"
				sPrevious: "Zurück"
				sNext:     "Nächster"
				sLast:     "Letzter"
		
	#bJQueryUI: true

	#sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>" 	