From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/CMA: fail qkey setting for RDMA_PS_IPOIB and IB_LINK_LAYER_ETHERNET
Date: Sun, 10 Jul 2011 09:32:27 +0300
Message-ID: <4E19477B.109@mellanox.com>
References: <1310045857-26040-1-git-send-email-monis@mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237302D0F3@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302D0F3-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "orend-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <orend-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>
> Can you describe the problem that the current code causes?  Does it lead to a kernel crash?
> Maybe the issue is that port space ipoib should never be associated with a non-IB device, with a check added to cma_acquire_dev().

Sean, Moni,

I believe that crashing the kernel from user space should be 
avoided/fixed anyway, is that
crash possible also under IB?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
