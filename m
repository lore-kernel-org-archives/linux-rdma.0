From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: XRC and ib_poll_cq
Date: Tue, 2 Apr 2013 19:16:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F369FCB@ORSMSX101.amr.corp.intel.com>
References: <515B0B35.3090401@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515B0B35.3090401-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  From the XRC annex I understand that WQE is obtained by polling the CQ
> attached to the XRC SRQ.
> Now in "struct ib_wc" we have a pointer of type "struct ib_qp *", should
> the pointer be cast to "struct ib_srq *"?
> In short how do one gets the qp_context/srq_context?

qp_context is accessible directly from struct ib_qp.  srq_context is available from struct ib_srq, the latter of which is also in struct ib_qp.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
