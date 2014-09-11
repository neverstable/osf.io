/**
 * Initializes the pagedown editor and prompts the user if
 * leaving the page with unsaved changes.
 */
;(function (global, factory) {
    if (typeof define === 'function' && define.amd) {
        define(['knockout', 'jquery', 'osfutils'], factory);
    } else {
        global.WikiEditor  = factory(ko, jQuery);
    }
}(this, function(ko, $) {
    'use strict';

    var editor;

    ko.bindingHandlers.ace = {
        init: function(element, valueAccessor) {
            editor = ace.edit(element.id);
            var value = ko.unwrap(valueAccessor());

            // Initialize value
            editor.setValue(value);
            editor.setReadOnly(false);

            // Change view model on editor change
            editor.getSession().on('change', function () {
                valueAccessor()(editor.getValue());
            });
        },
        update: function (element, valueAccessor) {
            var content = editor.getValue();        // Content of ace editor
            var value = ko.unwrap(valueAccessor()); // Value from view model

            if (content !== value) {
                editor.setValue(value);
            }
        }
    };

    function ViewModel(url) {
        var self = this;

        self.initText = ko.observable();
        self.wikiText = ko.observable();

        // TODO: Bug with multiple windows messing up changed value
        self.changed = ko.computed(function() {
            return self.initText() !== self.wikiText();
        });

        self.revertChanges = function() {
            editor.setValue(self.initText());
        };

        self.updateChanged = function(editUrl) {
            $.ajax({
                type: 'POST',
                url: editUrl,
                data: {
                    content: self.wikiText()
                },
                success: function() {
                    console.log('successful post');
                    self.initText(self.wikiText());
                },
                error: function(xhr, textStatus, error) {
                    console.error(xhr);
                    console.error(textStatus);
                    console.error(error);
                }
            });
        };

        //Fetch initial wiki text
        $.ajax({
            type: 'GET',
            url: url,
            dataType: 'json',
            success: function(response) {
                self.initText(response.wiki_content);
                self.wikiText(response.wiki_content);
            },
            error: function(xhr, textStatus, error) {
                console.error(textStatus);
                console.error(error);
                bootbox.alert('Could not get wiki content.');
            }
        });

        // TODO: Uncomment once "changed" property is correct
//        $(window).on('beforeunload', function() {
//            if (self.changed()) {
//                return 'If you leave this page, your changes will be ' +
//                    'saved as a draft for collaborators, but not made public.';
//            }
//        });
    }

    function WikiEditor(selector, url) {
        var viewModel = new ViewModel(url);
        $.osf.applyBindings(viewModel, selector);
        var converter1 = Markdown.getSanitizingConverter();
        var editor1 = new Markdown.Editor(converter1);
        editor1.run(editor);
    }

    return WikiEditor;
}));
