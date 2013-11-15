From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [rfc][heads-up] more unpleasant bugs in ipathfs
Date: Fri, 15 Nov 2013 14:01:25 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211C9445@FMSMSX107.amr.corp.intel.com>
References: <20131114011047.GG13318@ZenIV.linux.org.uk>
 <32E1700B9017364D9B60AED9960492BC211C9165@FMSMSX107.amr.corp.intel.com>
 <20131114203313.GI13318@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131114203313.GI13318-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Fair warning: debugfs suffers the same problems - its use for any dynamic
> objects will require the same kind of protection against IO after the underlying
> object goes away.  As I said, we really need generic revoke infrastructure; as it
> is, procfs and sysfs have it special-cased and everything else pretty much ad-hoc.
> Some things manage to do it right, some do not and since debugfs is greatly
> oversold as easy solution to all problems... pretty much all of its users are badly
> broken whenever you have objects with non-static lifetime.
> 

So how about this general approach:

1. Move all ipathfs handling to debugfs.
2. Input on dynamic objects referencing dd/ibd increment a refcount (inited to zero) in the "start" method
3. The "end" method decrements the ref count

The entrance in debugfs to do the recursive remove waits for refcount to drive to zero.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
