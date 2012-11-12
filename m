From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Remove bashisms from infiniband-diags
Date: Mon, 12 Nov 2012 15:44:54 -0800
Message-ID: <B9A894BE-AA18-480B-8670-C0869013EB5B@gmail.com>
References: <alpine.BSF.2.00.1211111101390.70593@toaster.local> <20121112152254.c3d092185861a95aaec570d8@llnl.gov>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121112152254.c3d092185861a95aaec570d8-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Nov 12, 2012, at 3:22 PM, Ira Weiny wrote:

> On Sun, 11 Nov 2012 11:05:32 -0800
> Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> Signed-off-by: Garrett Cooper <gcooper-nKaf5Oxk4VbQT0dZR+AlfA@public.gmane.org>
> 
> Please note that the following scripts are _deprecated_ and should no longer
> be used.

	Ok :/.. where is the functionality being moved to?

> scripts/ibcheckerrors.in    |  6 +++---
> scripts/ibcheckerrs.in      | 12 ++++++------
> scripts/ibchecknet.in       |  6 +++---
> scripts/ibchecknode.in      |  8 ++++----
> scripts/ibcheckport.in      |  8 ++++----
> scripts/ibcheckportstate.in |  8 ++++----
> scripts/ibcheckportwidth.in |  8 ++++----
> scripts/ibcheckstate.in     |  6 +++---
> scripts/ibcheckwidth.in     |  6 +++---
> scripts/ibclearcounters.in  |  6 +++---
> scripts/ibclearerrors.in    |  6 +++---
> scripts/ibdatacounters.in   |  6 +++---
> scripts/ibdatacounts.in     |  8 ++++----
> scripts/set_nodedesc.sh     |  2 +-
> 
> That said, what are you trying to fix here?  Is there a reason bash can't be used on your system?

	Good question!
	1. FreeBSD (which is a downstream consumer of OFED to some degree) doesn't come with /bin/bash for licensing reasons.
	2. Some Linux distro configs (thinking of busy box, etc) don't use bash because it's too bloated to include in the base image; they use dash (the parent shell which was ash from FreeBSD), mksh, etc instead.
	The goal was to use portable idioms so POSIX capable bourne shells could use the scripts.
Thanks!
-Garrett--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
