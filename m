From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] rdma/cm: support option to allow manually setting
	IB path
Date: Tue, 20 Oct 2009 13:14:04 -0600
Message-ID: <20091020191404.GH14520@obsidianresearch.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com> <20091020181458.GD14520@obsidianresearch.com> <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <46770152ACA04B6C8AA9497C45AC8FD0-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2009 at 11:34:01AM -0700, Sean Hefty wrote:
> >Can you please have some way for this to pass APM data and the
> >reversible GMP path as well? We know this is a problem, lets not
> >introduce new userspace APIs that further enshrine it..
> 
> Did you have something specific in mind?

Maybe something simple:

struct ibv_kern_path_rec2
{
   u32 flags;
   struct ibv_kern_path_rec rec;
}

(actually it would be really nice if ibv_kern_path_rec could be in
 MAD format not yet again another format)

Input to RDMA_OPTION_IB is an array of ibv_kern_path_rec2

flags is a combination of the following
 - GMP_PRIMARY
 - FORWARD_PRIMARY
 - RETURN_PRIMARY
 - RETURN_PRIMARY_REV
 - GMP_SECONDARY
 - FORWARD_SECONDARY
 - RETURN_SECONDARY
 - RETURN_SECONDARY_REV

The _REV notation indicates the path is stored in reversed format.

Today the kernel only supports up to two paths, with flags:
 GMP_PRIMARY | FORWARD_PRIMARY | RETURN_PRIMARY_REV
 FORWARD_SECONDARY | FORWARD_SECONDARY_REV

Future kernels can support up to 6 paths labeled:
 GMP_PRIMARY
 FORWARD_PRIMARY
 RETURN_PRIMARY
 GMP_SECONDARY
 FORWARD_SECONDARY
 RETURN_SECONDARY

The rdma_getaddrinfo resolver would ask the SA for a FORWARD path, if
the result comes back with reversible set then it just passes it to
the kernel as a single:
 GMP_PRIMARY | FORWARD_PRIMARY | RETURN_PRIMARY_REV
Otherwise the resolver does two more queries to get a GMP reversible
path and a return path, and the kernel gets 3 records.

A successful RDMA_OPTION_IB must locate at least GMP_PRIMARY,
FORWARD_PRIMARY(_REV), and RETURN_PRIMARY(_REV) paths in the included
description. Kernel searches in order.

The kernel supported capabilities should be viewable from a sysfs
location. When the kernel learns to do GMP_PRIMARY and RETURN_PRIMARY
standalone, then userpsace should be able to know that prior to
constructing the array. (ie once the kernel learns to do that then the
resolver should not ask the SA for a reversible FORWARD path.)

But even so, this resolver should be able to construct this data blob:
 FORWARD_PRIMARY
 RETURN_PRIMARY
 GMP_PRIMARY | FORWARD_PRIMARY | RETURN_PRIMARY_REV

Current kernels will ignore the first two flag sets (does not
understand that combiantion) and fall through to the last one. Someday
new kernels will pickup the FORWARD/RETURN paths from the earlier two
records and ignore the latter FORWARD_PRIMARY | PRETURN_PRIMARY_REV
flag.

This lets new path types by added in future too, using the same basic
scheme.

This would be the same format returned by a rdma_getaddrinfo call.

> ucma_set_ib_paths should be able to accommodate this; we just need
> some rules defined.  More invasive kernel changes are needed to do
> anything with the extra paths.

Yes, it isn't something that needs to be done right away, but having
the API means that someone could do the kernel work someday. As I
would see this working an opaque channel from the rdma_getaddrinfo
call to the kernel must be provided for this data to flow.

Passing a new SECONDARY/PRIAMRY path through RDMA_OPTION_IB seems
reasonable to me.

> For APM, I'm guessing that you'd like a way to set a new alternate
> path after establishing a connection.  ucma_set_ib_paths could still
> do this based on the state of the connection.

Yes, that would be necessary to obsolete the IB UCM API.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
