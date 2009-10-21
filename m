From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm: fix race initializing library
Date: Wed, 21 Oct 2009 09:45:47 -0700
Message-ID: <1DE75090A02F4772BA93407DF88CB05F@amr.corp.intel.com>
References: <OF77296F68.F34EB189-ONC225764C.003E31BE-C225764C.003F7FF9@il.ibm.com> <70A923FFB18B4139984C5F6D2DE67C51@amr.corp.intel.com> <OF422C00EB.DF382401-ONC2257656.002AFDE0-C2257656.002C0FBF@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF422C00EB.DF382401-ONC2257656.002AFDE0-C2257656.002C0FBF-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Nir Naaman' <NAAMAN-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>On a different issue... in the rdma_join_multicast code
>shouldn't  if (pthread_cond_init(&id_priv->cond, NULL)) be if
>(pthread_cond_init(&mc->cond, NULL))

err... yeah, I'll fix this.  Thanks

>The id_priv->cond is already initialized when this is called.
>Hope I'm wrong, otherwise it's a bit scary to think we are using these calls
>(rdma_leave_multicast uses this cond).

It may not be too bad.  The mc structure is cleared, and if pthread_cond_init
simply sets some values to 0, things may work okay.  rdma_destroy_id has a check
before waiting on id_priv->cond, and since calling rdma_join_multicast and
rdma_destroy_id simultaneously is disallowed, if we wait on id_priv->cond it
should still be signaled.

This should be fixed though.  I'll try to push out a new release with these
changes this week.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
