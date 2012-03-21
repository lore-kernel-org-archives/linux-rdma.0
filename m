From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Wed, 21 Mar 2012 17:18:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373451977F5@ORSMSX101.amr.corp.intel.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <3f46a051-ee2e-4e18-becf-60f6c023c3c6@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3f46a051-ee2e-4e18-becf-60f6c023c3c6-nbYkmrCdWxmgMrCBcu8zE0EOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +struct ocrdma_cq {
> +	struct ib_cq ibcq;
> +	struct ocrdma_dev *dev;

nit: There are several structures where you store ocrdma_dev *.  You can remove these and use the struct ib_* to reach it as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
