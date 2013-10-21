From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC 2/9] IB/core: Introduce Signature Verbs API
Date: Mon, 21 Oct 2013 14:34:53 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CEA91E@ORSMSX109.amr.corp.intel.com>
References: <1381851510-17290-1-git-send-email-sagig@mellanox.com>
 <1381851510-17290-3-git-send-email-sagig@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237388CE2BFF@ORSMSX109.amr.corp.intel.com>
 <5263D2DE.8010500@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5263D2DE.8010500-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The signature handover operation is binding all the necessary
> information for the HCA together: where is the data (data_mr), where is
> the protection information (prot_mr), what are the signature properties
> (sig_attrs).
> Once this step is taken (WR is posted), a single MR (sig_mr) describes
> the signature handover operation and can be used to perform RDMA under
> signature presence.
> Once the HCA will perform RDMA over this MR, it will take into account
> the signature context of the transaction and will follow the signature
> attributes configured.

It seems like this changes loses the ability to use an SGL.  Why are the signature properties separate from the protection information? 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
