From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC 1/9] IB/core: Introduce indirect and protected
 memory regions
Date: Mon, 21 Oct 2013 14:39:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CEA93B@ORSMSX109.amr.corp.intel.com>
References: <1381851510-17290-1-git-send-email-sagig@mellanox.com>
 <1381851510-17290-2-git-send-email-sagig@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237388CE2BE0@ORSMSX109.amr.corp.intel.com>
 <5263CC09.6030103@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5263CC09.6030103-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This MR can be perceived as a generalization of fast_reg MR. When using
> fast memory registration the verbs user will call ib_alloc_fast_reg_mr() in
> order to allocate an MR that may be used for fast registration method by
> posting
> a fast registration work-request on the send-queue (FRWR). The user does
> not pass any memory buffers to ib_alloc_fast_reg_mr() as the actual
> registration is done via posting WR. This follows the same notation, but
> allows new functionality (such as signature enable).

This makes sense to me.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
