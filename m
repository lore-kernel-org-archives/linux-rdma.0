From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/qib: Support creating qps with GFP_NOIO flag
Date: Mon, 11 Jan 2016 11:13:54 -0700
Message-ID: <20160111181354.GA19166@obsidianresearch.com>
References: <20160111175725.743.92967.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160111175725.743.92967.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 11, 2016 at 12:57:25PM -0500, Mike Marciniszyn wrote:
> From: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> The current code is problematic when the QP creation and ipoib is used to
> support NFS and NFS desires to do IO for paging purposes. In that case, the
> GFP_KERNEL allocation in qib_qp.c causes a deadlock in tight memory
> situations.

Are you trying to do swap over NFS? I didn't think that worked
reliably, or has that changed?

It doesn't make much sense for one driver to have a different GFP
policy for some calls compared with other drivers. Are you sure the
GFP agrument shouldn't be pushed up to the real caller?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
