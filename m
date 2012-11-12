From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] Remove bashisms from infiniband-diags
Date: Mon, 12 Nov 2012 15:22:54 -0800
Message-ID: <20121112152254.c3d092185861a95aaec570d8@llnl.gov>
References: <alpine.BSF.2.00.1211111101390.70593@toaster.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.BSF.2.00.1211111101390.70593-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Sun, 11 Nov 2012 11:05:32 -0800
Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Signed-off-by: Garrett Cooper <gcooper-nKaf5Oxk4VbQT0dZR+AlfA@public.gmane.org>

Please note that the following scripts are _deprecated_ and should no longer
be used.

 scripts/ibcheckerrors.in    |  6 +++---
 scripts/ibcheckerrs.in      | 12 ++++++------
 scripts/ibchecknet.in       |  6 +++---
 scripts/ibchecknode.in      |  8 ++++----
 scripts/ibcheckport.in      |  8 ++++----
 scripts/ibcheckportstate.in |  8 ++++----
 scripts/ibcheckportwidth.in |  8 ++++----
 scripts/ibcheckstate.in     |  6 +++---
 scripts/ibcheckwidth.in     |  6 +++---
 scripts/ibclearcounters.in  |  6 +++---
 scripts/ibclearerrors.in    |  6 +++---
 scripts/ibdatacounters.in   |  6 +++---
 scripts/ibdatacounts.in     |  8 ++++----
 scripts/set_nodedesc.sh     |  2 +-

That said, what are you trying to fix here?  Is there a reason bash can't be used on your system?

Thanks,
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
