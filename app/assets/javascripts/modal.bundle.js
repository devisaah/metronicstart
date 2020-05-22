(function ($) {
    'use strict';

    // save the original plugin
    var _parent = $.fn.modal;

    // define your own constructor
    var Modal = function(element, options) {
        _parent.Constructor.apply(this, arguments);

        $(element).find(".modal-footer button[type=submit]").on("click", function() {
            //var form = $(this).closest(".modal-content").find(".modal-body form");
            //Rails.fire(form[0], 'submit');
            $(this).closest(".modal-content").find(".modal-body form").submit();
        });


        $(element).find("button[data-minimize='modal']").on("click", function() {
            var modal = $(this).closest(".modal");
            if (modal.hasClass("minimized")) {
                modal.modal('maximize');
            } else {
                modal.modal('minimize');
            }
        });

        $(element).on("hidden.bs.modal", function(e) {
            $(this).modal('remove');
        });
        $(element).on("shown.bs.modal", function(e) {
            $('.modals .modal').removeClass("front");
            $(this).addClass("front");
        });
    };

    Modal.prototype = $.extend({}, _parent.Constructor.prototype);

    Modal.prototype.maximize = function() {
        $(this._element).removeClass("minimized");
        $(this._backdrop).removeClass("display-none");
        $('.modals').append(this._element);
        $('.modals .modal').removeClass("front");
        $(this._element).addClass("front");
    };

    Modal.prototype.minimize = function() {
        $(this._element).addClass("minimized");
        $(this._backdrop).addClass("display-none");
        $('.modals_minimized').append(this._element);
        $(this._element).removeClass("front");
        $(".modals .modal:last").addClass("front");
    };

    Modal.prototype.remove = function() {
        if (this._element) {
            $(this._element).remove();
        }
        if (this._backdrop) {
            $(this._backdrop).remove();
        }
    };

    // Para pode funcionar o campo de busca dos select2 nos modal
    Modal.prototype.enforceFocus = function() {};

    $.fn.modal = function (option, _relatedTarget) {
        return this.each(function () {
            var $this = $(this),
                data  = $this.data('bs.modal'),
                options = $.extend({}, Modal.DEFAULTS, $this.data(), typeof option === 'object' && option);

            if (!data) {
                $this.data('bs.modal', (data = new Modal(this, options)));
            }
            if (typeof option === 'string') {
                data[option](_relatedTarget);
            } else if (options.show) {
                data.show(_relatedTarget);
            }
        });
    };

})(jQuery);