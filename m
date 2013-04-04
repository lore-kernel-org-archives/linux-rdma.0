From: Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>
Subject: Re: Different signatures to ibv_open_xrcd - branch issue?
Date: Thu, 4 Apr 2013 10:22:40 +0200
Message-ID: <20130404082240.GB2565@nautica>
References: <51502C30.2000806@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823736F367AB8@ORSMSX101.amr.corp.intel.com>
 <515173F2.4030506@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823736F36825D@ORSMSX101.amr.corp.intel.com>
 <51520D43.2060006@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823736F368566@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F368566-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Hefty, Sean wrote on Tue, Mar 26, 2013 :
> > I think I missed something here, can I use your branch xrc2 of
> > libibverbs for testing purpose, or there are still things to merge there?
> 
> The xrc2 branch is usable.  I'm about 10-15 minutes away from posting v5 of those patches.

Sorry for hijacking this thread, but I was actually running into some
troubles with libibverbs-1.1.4 and a recent kernel, using
ibv_open_xrc_domain... Which is basically failing with an invalid
argument when writing to the uverb0 char device. 

So I guess the "commands" (IB_USER_VERBS_CMD_OPEN_XRCD vs
IB_USER_VERBS_CMD_OPEN_XRC_DOMAIN) changed since 2.6.32 and I would need
to use this libibverbs branch for now? (doesn't look like there is any
xrcd at all in 1.1.6 anyway)
What I don't get is that the abi_version did not change at all, if the
commands changed, shouldn't the kernel abi version be updated as well?
(None of the four abi_version I could find (ib_verbs, ib_mad, rdma_cm,
uverbs0 in the device) changed at all)

This looks like it's impossible to get the same library to fully work
for multiple kernel versions, while all the other basic features do work
quite well independantly.



Regards,
-- 
Dominique Martinet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
