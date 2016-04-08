From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RDMA PATCH 16/16] i40iw: Adding queue drain functions
Date: Fri, 8 Apr 2016 13:44:48 -0500
Message-ID: <20160408184448.GA12292@mustafai-MOBL>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
 <1460046664-552-17-git-send-email-mustafa.ismail@intel.com>
 <20160408004638.GD20252@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160408004638.GD20252-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 07, 2016 at 05:46:38PM -0700, Leon Romanovsky wrote:
> On Thu, Apr 07, 2016 at 11:31:04AM -0500, Mustafa Ismail wrote:
> > Adding sq and rq drain functions, which block until all
> > previously posted wr-s in the specified queue have completed.
> > A completion object is signaled to unblock the thread,
> > when the last cqe for the corresponding queue is processed.
> > 
> > Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> I want to bring back last conversation about need special function to
> drain QPs for iWARP devices.
> Come on guys, it is already third place there is the same implementation
> is introduced in last 2 months.

In order to move this into core, the core would need to determine if the
sq and rq are empty. To do this it will need the driver's internal sq and
rq information such as head and tail. Then if not empty it will need
more information about the qp's cq processing. All this is device specific.

It is just a few lines of code in each driver to check if its hw sq and rq
are empty and if not, handle it from its cq processing.

For this reason, it seems best left to each iWARP driver to handle.

Thanks,

Mustafa
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
