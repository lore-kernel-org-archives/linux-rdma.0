From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/CMA: fail qkey setting for RDMA_PS_IPOIB and
 IB_LINK_LAYER_ETHERNET
Date: Thu, 7 Jul 2011 16:55:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302D0F3@ORSMSX101.amr.corp.intel.com>
References: <1310045857-26040-1-git-send-email-monis@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310045857-26040-1-git-send-email-monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "orend-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <orend-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In general, when link layer is ETHERNET it is wrong to use IPoIB port space
> since
> no IPoIB interface is available. Specifically, setting qkey when port space is
> RDMA_PS_IPOIB, requires SA query which is impossible when link layer is
> IB_LINK_LAYER_ETHERNET.

Can you describe the problem that the current code causes?  Does it lead to a kernel crash?

Maybe the issue is that port space ipoib should never be associated with a non-IB device, with a check added to cma_acquire_dev().

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
