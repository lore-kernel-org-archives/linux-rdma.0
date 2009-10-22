From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] [RFC] rdma/cm: support option to allow manually
	setting IB path
Date: Thu, 22 Oct 2009 12:11:01 -0600
Message-ID: <20091022181101.GY14520@obsidianresearch.com>
References: <20091020181458.GD14520@obsidianresearch.com> <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com> <20091020191404.GH14520@obsidianresearch.com> <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com> <20091022004245.GV14520@obsidianresearch.com> <AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com> <20091022013542.GX14520@obsidianresearch.com> <B7E97540810E4A2785FF1FC8CB96F453@amr.corp.intel.com> <20091022165414.GH26003@obsidianresearch.com> <1438C87E89284364A56E08A40DFE199E@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438C87E89284364A56E08A40DFE199E-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 22, 2009 at 10:52:13AM -0700, Sean Hefty wrote:
> >> +static int ucma_set_ib_path(struct ucma_context *ctx,
> >> +			    struct ib_path_rec_data *path_data, size_t optlen)
> >> +{
> >> +	struct ib_sa_path_rec sa_path;
> >> +	struct rdma_cm_event event;
> >> +	int ret;
> >> +
> >> +	if (optlen != sizeof(*path_data))
> >> +		return -EINVAL;
> >> +
> >> +	if (path_data->flags != IB_PATH_GMP | IB_PATH_PRIMARY |
> >> +				IB_PATH_OUTBOUND | IB_PATH_INBOUND)
> >> +		return -EINVAL;
> >
> >This should accept an array here, to aid easing in APM support:
> 
> I agree - I thought about this after sending the patch.  This is more what I
> think is needed at this point:
> 
> if ((optlen % sizeof(*path_data)) != 0) return -EINVAL;
> 
> if (number of paths > 1)
> 	return -ENOSYS;

This is really no different than what you had at first.

My idea was to have the kernel search the array for the entries it
needs/supports. First one found wins. This provides future
API compatability.

Some future userspace, to support some future kernel APM, would pass in 2
entries:
 IB_PATH_GMP | IB_PATH_PRIMARY | IB_PATH_OUTBOUND | IB_PATH_INBOUND
 IB_PATH_GMP | IB_PATH_ALTERNATE | IB_PATH_OUTBOUND | IB_PATH_INBOUND

This shouldn't break old kernels.

Again, some even future kernel would support 6 entries, future user
space would send this:
 IB_PATH_PRIMARY | IB_PATH_INBOUND
 IB_PATH_PRIMARY | IB_PATH_OUTBOUND
 IB_PATH_GMP | IB_PATH_PRIMARY | IB_PATH_OUTBOUND | IB_PATH_INBOUND
 IB_PATH_ALTERNATE | IB_PATH_INBOUND
 IB_PATH_ALTERNATE | IB_PATH_OUTBOUND
 IB_PATH_GMP | IB_PATH_ALTERNATE | IB_PATH_OUTBOUND | IB_PATH_INBOUND

This shouldn't break old kernels either.

Maybe it is worth returning a postive integer from the syscall
indicating the number of paths the kernel accepted. Although I suspect
most use models of this will ignore that.

> >I like the PATH_PRIMARY/PATH_ALTERNATE idea,
> >
> >But I think IB_PATH_OUTBOUND_REV is still required.
> 
> I'm not fond of the reverse idea.  Why do you think it's needed?

Alignment with the SM. (Actually, it would be IB_PATH_INBOUND_REV) 

You have a PR query where SGID=local, DGID=remote that gives you
IB_PATH_OUTBOUND. Then you do a query with SGID=remote, DGID=local,
that gives you IB_PATH_INBOUND. ie the SGID is different in each
result. This is necessary, non-reversible paths are uni-directional.

If you use a reversible path then the IB_PATH_OUTBOUND == IB_PATH_GMP
== IB_PATH_INBOUND_REV (ie the inbound side is always the one that has
SGID/DGID direction swapped)

Since this is going with the raw PR from the SA, I think it is wise to
not require any modification of the PR as it flows from the SA to the
kernel. Thus there are two PR representations for IB_PATH_INBOUND -
one that has SGID=local (_REV) and one that has SGID=remote.

So either IB_PATH_INBOUND_REV is explicitly part of the flags
structure, or IB_PATH_INBOUND | IB_PATH_OUTBOUND implicity means
IB_PATH_INBOUND_REV | IB_PATH_OUTBOUND

The implict behavior seems way to subtle to me, making it explicit
clears up which is which.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
