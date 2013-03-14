From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V3 for-next 3/5] IB/ipoib: Move to multi-queue device
Date: Thu, 14 Mar 2013 20:53:48 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D5C8F95@FMSMSX108.amr.corp.intel.com>
References: <1362676288-19906-1-git-send-email-ogerlitz@mellanox.com>
	<1362676288-19906-4-git-send-email-ogerlitz@mellanox.com>
	<32E1700B9017364D9B60AED9960492BC0D5C7875@FMSMSX108.amr.corp.intel.com>
 <CAJZOPZ+xHqWT6vrbpYoakM_h=BBYsxq-CaXSNSHchvQ1wu66kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+xHqWT6vrbpYoakM_h=BBYsxq-CaXSNSHchvQ1wu66kQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The cm side ib_req_notify_cq() is altered in my patch.

The same behavior is need to be adopted.

Mike

> -----Original Message-----
> From: Or Gerlitz [mailto:or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Thursday, March 14, 2013 4:52 PM
> To: Marciniszyn, Mike
> Cc: Or Gerlitz; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Shlomo
> Pongratz
> Subject: Re: [PATCH V3 for-next 3/5] IB/ipoib: Move to multi-queue device
> 
> Marciniszyn, Mike <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > This patch will conflict with
> > http://marc.info/?l=linux-rdma&m=136190765729001&w=2
> 
> 
> What sort of conflict? is that on lines that are moving, or something deeper in
> the proposed design?
> 
> Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
