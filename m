From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next v2 06/16] IB/hfi1: Fix for potential refcount
 leak in hfi1_open_file()
Date: Fri, 26 Jan 2018 15:33:48 -0700
Message-ID: <20180126223348.GF23869@ziepe.ca>
References: <20180126211126.12097.47410.stgit@scvm10.sc.intel.com>
 <20180126212933.12097.3989.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180126212933.12097.3989.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael J Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 26, 2018 at 01:29:36PM -0800, Dennis Dalessandro wrote:
> From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> The dd refcount is speculatively incremented prior to allocating
> the fd memory with kzalloc(). If that kzalloc() failed the dd
> refcount leaks.
> Increment refcount on kzalloc success.
> 
> Fixes: e11ffbd57520 ("IB/hfi1: Do not free hfi1 cdev parent structure early")
> Reviewed-by: Michael J Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Change-Id: I660296d5860205722b3db3d0c8b0746fd8f655ab

*blark* Change-Id *blark*

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
