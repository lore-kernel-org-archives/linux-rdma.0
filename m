From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/qib: fix test of unsigned variable
Date: Mon, 11 May 2015 12:49:28 -0600
Message-ID: <20150511184928.GC25405@obsidianresearch.com>
References: <20150511121315.21044.78464.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150511121315.21044.78464.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 11, 2015 at 08:13:15AM -0400, Mike Marciniszyn wrote:
> Commit d4988623cc60 ("IB/qib: use arch_phys_wc_add()")
> adjusted mtrr inititialization to use the new interface.
> 
> Unfortunately, the new interface returns a signed
> value and the patch tested the unsigned wc_cookie.

Looks like wc_cookie is only used with arch_phys_wc_add/del, so it
should become an int, not casted..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
