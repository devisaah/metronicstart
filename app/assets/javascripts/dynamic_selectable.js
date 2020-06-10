var DynamicSelectable;

$.fn.extend({
    dynamicSelectable: function() {
        return $(this).each(function(i, el) {
            return new DynamicSelectable($(el));
        });
    }
});

DynamicSelectable = (function() {
    function DynamicSelectable($select) {
        this.init($select);
    }

    DynamicSelectable.prototype.init = function($select) {
        var targets;
        targets = $select.data('dynamicSelectableTarget');
        return $select.on('change', (function(_this) {
            return function() {
                return $.each(targets, function(index, target) {
                    var $target, url, urlTemplate;
                    $target = $(target);
                    urlTemplate = $target.data('dynamicSelectableUrl');
                    _this.clearTarget($target);
                    url = _this.constructUrl(urlTemplate, $select.val());
                    if (url) {
                        return $.getJSON(url, function(data) {
                            $.each(data, function(index, el) {
                                return $target.append("<option value='" + el.dymanic_selectable.value + "'>" + el.dymanic_selectable.text + "</option>");
                            });
                            return _this.reinitializeTarget($target);
                        });
                    } else {
                        return _this.reinitializeTarget($target);
                    }
                });
            };
        })(this));
    };

    DynamicSelectable.prototype.reinitializeTarget = function($target) {
        $target.trigger("change");
        return $target.trigger("dynamicSelectableChange");
    };

    DynamicSelectable.prototype.clearTarget = function($target) {
        return $target.html("<option value=''>Selecione a cidade</option>");
    };

    DynamicSelectable.prototype.constructUrl = function(urlTemplate, id) {
        if (id && id !== '') {
            return urlTemplate + "?search=" + id;
        }
    };

    return DynamicSelectable;

})();