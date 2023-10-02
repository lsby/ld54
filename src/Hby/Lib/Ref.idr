module Hby.Lib.Ref

export
data Ref a = MK_Ref AnyPtr

-- newRef
%foreign """
javascript:lambda:(_, a) => () => {
    return {
        data: a
    }
}
"""
newRef_js : a -> IO (AnyPtr)

export
newRef : a -> IO (Ref a)
newRef a = map MK_Ref $ newRef_js a

-- readRef
%foreign """
javascript:lambda:(_, ref) => () => {
    return ref.data
}
"""
readRef_js : AnyPtr -> IO (a)

export
readRef : Ref a -> IO (a)
readRef (MK_Ref ref) = readRef_js ref

-- writeRef
%foreign """
javascript:lambda:(_, ref, a) => () => {
    ref.data = a
}
"""
writeRef_js : AnyPtr -> a -> IO ()

export
writeRef : a -> Ref a -> IO ()
writeRef a (MK_Ref ref) = writeRef_js ref a
