From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Different signatures to ibv_open_xrcd - branch issue?
Date: Tue, 26 Mar 2013 21:09:53 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F368566@ORSMSX101.amr.corp.intel.com>
References: <51502C30.2000806@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823736F367AB8@ORSMSX101.amr.corp.intel.com>
 <515173F2.4030506@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823736F36825D@ORSMSX101.amr.corp.intel.com>
 <51520D43.2060006@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51520D43.2060006-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I think I missed something here, can I use your branch xrc2 of
> libibverbs for testing purpose, or there are still things to merge there?

The xrc2 branch is usable.  I'm about 10-15 minutes away from posting v5 of those patches.

> And for librdmacm, I'm looking forward to try it with a real application
> the moment you'll have a branch witch is compatible with libibverbs.

The librdmacm needs to be updated to match the latest libibverbs.  If the libibverbs changes are ever merged upstream, I'll update the librdmacm at that point.

Until then, the only sample app for XRC is ibv_xsrq_pingpong.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
