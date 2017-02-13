From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: IB/hfi1: Use memdup_user() rather than duplicating its
 implementation in hfi1_user_sdma_process_request()
Date: Mon, 13 Feb 2017 17:01:56 +0300
Message-ID: <20170213140156.GD4162@mwanda>
References: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
 <b19e44b3-601f-c642-b8d3-12c000511ce2@users.sourceforge.net>
 <477c8499-93ad-253d-aa2b-8f209ecfad62@intel.com>
 <20170213105350.GA4108@mwanda>
 <4094dc04-bb2c-a74e-8d4d-8879ac4e7761@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4094dc04-bb2c-a74e-8d4d-8879ac4e7761-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 13, 2017 at 12:12:51PM +0100, SF Markus Elfring wrote:
> >> Thanks for the patch, but this one is already taken care of along
> >> with other similar uses of kmalloc/copy:
> >>
> >> http://marc.info/?l=linux-rdma&m=148656088729538&w=2
> >>
> > 
> > Michael's patch doesn't change user_sdma_free_request() so it introduces
> > a kfreeing an error pointer bug.
> 
> Did you notice that another local variable “tmp” was introduced in the update step
> “[PATCH 27/27] IB/hfi1: Code reuse with memdup_copy” so that
> the mentioned function will usually get a null pointer after a failure there?
> 

Ah right.  Thanks.  I missed that.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
