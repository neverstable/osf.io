
<link rel="stylesheet" href="/static/addons/box/box.css">
<div id="boxScope" class="scripted">
    <!-- <pre data-bind="text: ko.toJSON($data, null, 2)"></pre> -->
    <h4 class="addon-title">
        Box
        <small class="authorized-by">
            <span data-bind="if: nodeHasAuth">
                authorized by <a data-bind="attr.href: urls().owner">
                    {{ownerName}}
                </a>
                % if not is_registration:
                    <a data-bind="click: deauthorize"
                        class="text-danger pull-right addon-auth">Deauthorize</a>
                % endif
            </span>

             <!-- Import Access Token Button -->
            <span data-bind="if: showImport">
                <a data-bind="click: importAuth" href="#" class="text-primary pull-right addon-auth">
                    Import Access Token
                </a>
            </span>

            <!-- Oauth Start Button -->
            <span data-bind="if: showTokenCreateButton">
                <a data-bind="attr.href: urls().auth" class="text-primary pull-right addon-auth">
                    Create Access Token
                </a>
            </span>
        </small>
    </h4>


    <!-- Settings Pane -->
    <div class="box-settings" data-bind='if: showSettings'>
        <div class="row">
            <div class="col-md-12">
                <p>
                    <strong>Current Folder:</strong>
                    <a data-bind="attr.href: urls().files">
                      {{folder().name}}
                    </a>
                    <span data-bind="if: folder().path === null" class="text-muted">
                        None
                    </span>
                </p>

                <!-- Folder buttons -->
                <div class="btn-group" data-bind="visible: userIsOwner()">
                    <button data-bind="visible: validCredentials,
                                        click: togglePicker,
                                        css: {active: currentDisplay() === PICKER}"
                            class="btn btn-sm btn-box"><i class="fa fa-pencil-square-o"></i> Change</button>
                </div>


                <!-- Folder picker -->
                <div class="box-widget">
                    <p class="text-muted text-center box-loading-text" data-bind="visible: loading">
                    Loading folders...</p>

                    <div data-bind="visible: currentDisplay() === PICKER">
                        <div id="myBoxGrid"
                             class="filebrowser hgrid box-folder-picker"></div>
                    </div>

                    <!-- Queued selection -->
                    <div class="box-confirm-selection"
                        data-bind="visible: currentDisplay() == PICKER && selected()">
                        <form data-bind="submit: submitSettings">
                            <div class="pull-right">
                                <button class="btn btn-default"
                                        data-bind="click: cancelSelection">
                                    Cancel
                                </button>
                                <input type="submit"
                                       class="btn btn-primary"
                                       value="Submit" />
                            </div>
                            <h4 data-bind="if: selected" class="box-confirm-dlg">
                                Connect &ldquo;{{ selected().name }}&rdquo;?
                            </h4>
                        </form>
                    </div><!-- end .box-confirm-selection -->

                </div>
            </div><!-- end col -->
        </div><!-- end row -->
    </div><!-- end .box-settings -->

    <!-- Flashed Messages -->
    <div class="help-block">
        <p data-bind="html: message, attr.class: messageClass"></p>
    </div>
</div><!-- end #boxScope -->
