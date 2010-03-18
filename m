From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: adding path record wire format to libibverbs
Date: Thu, 18 Mar 2010 00:08:12 -0600
Message-ID: <20100318060812.GB28042@obsidianresearch.com>
References: <77007DB2D13246B9A031DE3B0094C024@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <77007DB2D13246B9A031DE3B0094C024-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 17, 2010 at 10:48:30AM -0700, Sean Hefty wrote:

> Would you accept a patch to libibverbs sa.h to add the wire format for a path
> record, shown below?  I'm not ready to submit a patch yet, just need to find a
> place for this.

Could we use the bitfield versions of this I posted awhile back? :)

Sean made the kernel accept information in this format a few change
sets ago so it seems appropriate to me to be in libibverbs..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
