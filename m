From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Verbs 2.0 questions
Date: Fri, 2 Feb 2018 15:21:05 -0700
Message-ID: <20180202222105.GF9080@ziepe.ca>
References: <14063C7AD467DE4B82DEDB5C278E8663A9F9F318@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663A9F9F318-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 02, 2018 at 09:35:17PM +0000, Ruhl, Michael J wrote:
> Hi,
> 
> I have been playing with the Verbs 2.0 interface a bit (ioctl interface),
> and have some comments and things to discuss.
> 
> Comments/code review:
> 
> 1) Some of the DECLARE_xxx() macros (and their associated
> UVERBS_TYPE_xxx(), etc) use 'sizeof(struct blah)', other use just a plain
> 'struct blah'.

Yeah, this should be consistent, also stuff like ordering:

 DECLARE_UVERBS_OBJECT(uverbs_object_srq, UVERBS_OBJECT_SRQ,
vs
 UVERBS_ATTR_PTR_OUT(DESTROY_CQ_RESP, struct ib_uverbs_destroy_cq_resp,

The constant should always be first.

> 2) Matan has a patch in a private tree: 
> 
> Author: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Tue Jan 23 15:55:04 2018 -0500
> 
>     IB/uverbs: Fix method merging in uverbs_ioctl_merge
>     
>     Fix a bug in uverbs_ioctl_merge that looked at objects iterators
>     number instead of methods iterators number when merging methods.
>     While we're at it, make the uverbs_ioctl_merge code a bit more clear
>     and faster.
> 
> That I need in my build environment, or I get a kernel panic when I add my new
> objects and methods.  Should (or could) patches like this be up-streamed more
> quickly?

The patch is in an 11 patch series coming that fixes various uverbs
ioctl things

  https://github.com/jgunthorpe/linux/commits/ioctl

Should be posted next week unless something wrong is found.

> 3)  The Open Fabrics Alliance Verbs Kernel ABI slide deck (slides 16 and 17) imply
> that the standard objects can be augmented with 'DEV Specific' methods and attributes.
> 
> Since the methods are defined in the DECLARE_UVERBS_OBJECT(), it is not
> clear how to add methods to, say 'uverbs_object_qp' in my driver specific
> code.
> 
> Are there any examples of how this should be done?

I don't think it has ever been done yet.

Honestly I think the entire driver hookup process needs a second set
of eyes to check if it is really the best it can be...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
