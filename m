From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] Remove bashisms from infiniband-diags
Date: Thu, 15 Nov 2012 15:56:18 -0800
Message-ID: <20121115155618.d642e5e32c0596060ff5c9f9@llnl.gov>
References: <alpine.BSF.2.00.1211111101390.70593@toaster.local>
	<20121112152254.c3d092185861a95aaec570d8@llnl.gov>
	<B9A894BE-AA18-480B-8670-C0869013EB5B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B9A894BE-AA18-480B-8670-C0869013EB5B-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 12 Nov 2012 15:44:54 -0800
Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Nov 12, 2012, at 3:22 PM, Ira Weiny wrote:
> 
> > On Sun, 11 Nov 2012 11:05:32 -0800
> > Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 
> >> Signed-off-by: Garrett Cooper <gcooper-nKaf5Oxk4VbQT0dZR+AlfA@public.gmane.org>
> > 
> > Please note that the following scripts are _deprecated_ and should no longer
> > be used.
> 
> 	Ok :/.. where is the functionality being moved to?

Each of the tools has pointers to other tools which provide similar functionality.  For example ibcheckerrors is replaced by ibqueryerrors.  ibcheck[node|port|width] don't really have equivalents because they mostly checked for 4x DDR links which is not useful in general.  The best tool for that is probably iblinkinfo which reports links which could be running at faster speed/widths.  set_nodedesc.sh is no longer needed as all the distros/OFED have start up scripts which do the same thing.

> 
> > scripts/ibcheckerrors.in    |  6 +++---
> > scripts/ibcheckerrs.in      | 12 ++++++------
> > scripts/ibchecknet.in       |  6 +++---
> > scripts/ibchecknode.in      |  8 ++++----
> > scripts/ibcheckport.in      |  8 ++++----
> > scripts/ibcheckportstate.in |  8 ++++----
> > scripts/ibcheckportwidth.in |  8 ++++----
> > scripts/ibcheckstate.in     |  6 +++---
> > scripts/ibcheckwidth.in     |  6 +++---
> > scripts/ibclearcounters.in  |  6 +++---
> > scripts/ibclearerrors.in    |  6 +++---
> > scripts/ibdatacounters.in   |  6 +++---
> > scripts/ibdatacounts.in     |  8 ++++----
> > scripts/set_nodedesc.sh     |  2 +-
> > 
> > That said, what are you trying to fix here?  Is there a reason bash can't be used on your system?
> 
> 	Good question!
> 	1. FreeBSD (which is a downstream consumer of OFED to some degree) doesn't come with /bin/bash for licensing reasons.
> 	2. Some Linux distro configs (thinking of busy box, etc) don't use bash because it's too bloated to include in the base image; they use dash (the parent shell which was ash from FreeBSD), mksh, etc instead.
> 	The goal was to use portable idioms so POSIX capable bourne shells could use the scripts.

I like this idea but I worry about maintaining non-bashisms in scripts.  I don't have ready access to a wide range of systems.  Would you agree that dash is a least common denominator which would be a good tool to use as an automatic checker?  To this end I could add a make check target which uses dash to check the scripts.

Thoughts?
Ira

-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
