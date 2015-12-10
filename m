From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 02/37] IB/rdmavt: Consolidate dma ops in rdmavt.
Date: Thu, 10 Dec 2015 19:52:31 +0200
Message-ID: <20151210175231.GD8662@leon.nu>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204305.8144.7038.stgit@phlsvslse11.ph.intel.com>
 <20151208060821.GD7313@leon.nu>
 <20151210161708.GA13412@phlsvsds.ph.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151210161708.GA13412-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 11:17:09AM -0500, Dennis Dalessandro wrote:
> On Tue, Dec 08, 2015 at 08:08:21AM +0200, Leon Romanovsky wrote:
> >On Mon, Dec 07, 2015 at 03:43:06PM -0500, Dennis Dalessandro wrote:
> >>+
> >>+#define BAD_DMA_ADDRESS ((u64)0)
> >What is the advantage in using directly u64 values instead of
> >pointers? You will get NULL and functions which return pointers
> >without need of casting.
> >
> >...
> >>+static u64 rvt_dma_map_single(struct ib_device *dev, void *cpu_addr,
> >>+			      size_t size, enum dma_data_direction direction)
> >>+{
> >>+	if (WARN_ON(!valid_dma_direction(direction)))
> >>+		return BAD_DMA_ADDRESS;
> >>+
> >>+	return (u64)cpu_addr;
> >>+}
> >An example of such function.
> 
> Honestly I'm not really sure why it's done this way. We are just following
> the signature of the function in struct ib_dma_mapping_ops.
Is it worth to consider to implement these functions with the pointers?

> 
> -Denny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
