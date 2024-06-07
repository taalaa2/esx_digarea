Notify = function(msg, type)
    lib.notify({
        description = msg,
        type = type
    })
end

exports('startPan', function(source)
    lib.callback.await('esx_digarea:CheckItem', source)
end)