From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 00/10] Hardware tag matching support
Date: Fri, 7 Oct 2016 16:47:28 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB093986@ORSMSX109.amr.corp.intel.com>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
 <20161007145620.GV9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161007145620.GV9282-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> For any reasons, I don't see this patch set in your tree. Did I miss
> it?
> 
> Thanks
> 
> >
> > Thanks,
> >   Artemy & Leon
> >
> > Artemy Kovalyov (10):
> >   IB/core: Add XRQ capabilities
> >   IB/core: Make CQ separate part of SRQ context
> >   IB/core: Add new SRQ type IB_SRQT_TAG_MATCHING
> >   IB/uverbs: Expose tag matching capabilties to UAPI
> >   IB/uverbs: Expose XRQ capabilities
> >   IB/uverbs: Add XRQ creation parameter to UAPI
> >   IB/uverbs: Add new SRQ type IB_SRQT_TAG_MATCHING
> >   IB/mlx5: Fill XRQ capabilities
> >   net/mlx5: Add XRQ support
> >   IB/mlx5: Support IB_SRQT_TAG_MATCHING

I was out when these were submitted, so this may have been answered.  These patches change the uABI.  Have the changes been vetted out by the IBTA or some other standards (I'm using that term loosely) organization?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
