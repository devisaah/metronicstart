// init select2
function templateSelect2(controller, placeholder, ajax, allowClear){
    if (ajax == false) {
        return {
            allowClear: allowClear,
            placeholder: placeholder,
            language: {
                errorLoading: function() {
                    return "Os resultados não puderam ser carregados."
                },
                inputTooLong: function(e) {
                    var n = e.input.length - e.maximum,
                        r = "Apague " + n + " caracter";
                    return 1 != n && (r += "es"), r
                },
                inputTooShort: function(e) {
                    return "Digite " + (e.minimum - e.input.length) + " ou mais caracteres"
                },
                loadingMore: function() {
                    return "Carregando mais resultados…"
                },
                maximumSelected: function(e) {
                    var n = "Você só pode selecionar " + e.maximum + " ite";
                    return 1 == e.maximum ? n += "m" : n += "ns", n
                },
                noResults: function() {
                    return "Nenhum resultado encontrado"
                },
                searching: function() {
                    return "Buscando…"
                },
                removeAllItems: function() {
                    return "Remover todos os itens"
                }
            }
        }
    }
    else {
        return {
            allowClear:  allowClear,
            placeholder: placeholder,
            ajax: {
                url: '/admin/' + controller +'/search/',
                delay: 1000,
                data: function (params) {
                    return { search: params.term };
                },
                dataType: 'json',
                processResults: function (data, page) {
                    var select2data = $.map(data, function (obj) {
                        obj.id = obj.id;
                        obj.text =  obj.nome || obj.text || obj.descricao || obj.titulo;
                        return obj;
                    });
                    return {
                        results: select2data
                    };
                },
            },
            language: {
                errorLoading: function() {
                    return "Os resultados não puderam ser carregados."
                },
                inputTooLong: function(e) {
                    var n = e.input.length - e.maximum,
                        r = "Apague " + n + " caracter";
                    return 1 != n && (r += "es"), r
                },
                inputTooShort: function(e) {
                    return "Digite " + (e.minimum - e.input.length) + " ou mais caracteres"
                },
                loadingMore: function() {
                    return "Carregando mais resultados…"
                },
                maximumSelected: function(e) {
                    var n = "Você só pode selecionar " + e.maximum + " ite";
                    return 1 == e.maximum ? n += "m" : n += "ns", n
                },
                noResults: function() {
                    return "<a class='btn btn-success btn-sm' id='value' data-remote='true' href='/admin/"+controller+"/new'><i class='la la-plus'></i> Add </a>";
                },
                searching: function() {
                    return "Buscando…"
                },
                removeAllItems: function() {
                    return "Remover todos os itens"
                }
            },
            escapeMarkup: function (markup) { return markup; },
            minimumInputLength: 2,
            templateSelection: function (item) {
                return item.nome || item.text || obj.descricao || obj.titulo;
            }
        }
    }

}

function initSelect2(){
    $(".select2_basico").select2(templateSelect2(null, "Selecione", false, true));
}

// init campo obrigatorio
function initCampoObrigatorio(){
    var originalAddClassMethod = jQuery.fn.addClass;
    jQuery.fn.addClass = function () {
        var result = originalAddClassMethod.apply(this, arguments);
        if (arguments[0] === 'label-required') {
            if ($(this).find('span.required').length === 0) {
                $(this).append("<span aria-required='true' class='required'>&nbsp*</span>");
            }
        }
        return result;
    }
    var originalRemoveClassMethod = jQuery.fn.removeClass;
    jQuery.fn.removeClass = function () {
        var result = originalRemoveClassMethod.apply(this, arguments);
        if (arguments[0] === 'label-required') {
            $(this).find('span.required').remove();
        }
        return result;
    }
    $('label:not(.label-required)').find('span.required').remove();
    $('.label-required:not(:has(span.required))').append("<span aria-required='true' class='required'>&nbsp*</span>");

    $('div.collapse:has(.has-error)').collapse('show');
}

// init mascaras
function initMascaras(){
    $(".mascara-cpf-cnpj").inputmask({ mask: ["999.999.999-99", "99.999.999/9999-99"], removeMaskOnSubmit: false });
    $(".mascara-cpf").inputmask({ mask: "999.999.999-99", removeMaskOnSubmit: false });
    $(".mascara-cnpj").inputmask({ mask: "99.999.999/9999-99", removeMaskOnSubmit: false });
    $(".mascara-telefone").inputmask({ mask: "(99) 9999-9999", removeMaskOnSubmit: false });
    $(".mascara-celular").inputmask({ mask: ["(99) 9999-9999", "(99) 99999-9999"], removeMaskOnSubmit: false });
    $(".mascara-rg").inputmask({ mask: "999.999.999", removeMaskOnSubmit: false, numericInput: true, placeholder: " " });
    $(".mascara-cep").inputmask({ mask: "99999-999", removeMaskOnSubmit: false });
    $('.mascara-dinheiro').inputmask("currency");
}

function initColorpicker(){
    $('.colorpicker-default').colorpicker();
}

function initImagePopup() {
    $('.image-popup').magnificPopup({
        type: 'image',
        closeOnContentClick: true,
        mainClass: 'mfp-img-mobile',
        image: {
            verticalFit: true
        }
    });
    $('.iframe-popup').magnificPopup({
        type: 'iframe',
        closeOnContentClick: true
    });
}

function initDatetimepicker() {
    $('.kt_datepicker').datepicker({
        rtl: KTUtil.isRTL(),
        todayHighlight: true,
        orientation: "bottom left",
        templates: arrows = {
            leftArrow: '<i class="la la-angle-right"></i>',
            rightArrow: '<i class="la la-angle-left"></i>'
        },
        format: 'dd/mm/yyyy',
        language: 'pt-br'
    });
}