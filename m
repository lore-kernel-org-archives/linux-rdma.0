From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/qib: Support creating qps with GFP_NOIO flag
Date: Mon, 11 Jan 2016 18:20:30 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259E9BB7@fmsmsx120.amr.corp.intel.com>
References: <20160111175725.743.92967.stgit@phlsvslse11.ph.intel.com>
 <20160111181354.GA19166@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160111181354.GA19166-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

with GFP_NOIO flag
> 

[MAM] 
> > The current code is problematic when the QP creation and ipoib is used
> > to support NFS and NFS desires to do IO for paging purposes. In that
> > case, the GFP_KERNEL allocation in qib_qp.c causes a deadlock in tight
> > memory situations.
> 
> Are you trying to do swap over NFS? I didn't think that worked reliably, or
> has that changed?
> 
> It doesn't make much sense for one driver to have a different GFP policy for
> some calls compared with other drivers. Are you sure the GFP agrument
> shouldn't be pushed up to the real caller?
> 

The equivalent change has already been made for mlx4 in commit 40f2287bd and
Ib_verbs.h core include file in 09b93088d7.

This is a follow-on to that work.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
