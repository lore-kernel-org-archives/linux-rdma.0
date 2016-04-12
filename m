From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RDMA PATCH 01/16] i40iw: Fix overflow of region length
Date: Tue, 12 Apr 2016 13:09:10 -0500
Message-ID: <20160412180909.GA12216@mustafai-MOBL>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
 <1460046664-552-2-git-send-email-mustafa.ismail@intel.com>
 <20160411092324.GG20252@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160411092324.GG20252-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 11, 2016 at 02:23:24AM -0700, Leon Romanovsky wrote:
> On Thu, Apr 07, 2016 at 11:30:49AM -0500, Mustafa Ismail wrote:
> > Change region_length to u64 as a region can be > 4GB.
> 
> I suppose that you will have a casting warning while setting u64 variable to u32 variable.
> $grep -r pbl_depth drivers/infiniband/hw/i40iw/*
> drivers/infiniband/hw/i40iw/i40iw_verbs.c:      u32 pbl_depth = 0;
> drivers/infiniband/hw/i40iw/i40iw_verbs.c:      pbl_depth = region_length >> 12;

I did not see any warnings from zero day testing. Good catch. We will fix in V2.
Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
