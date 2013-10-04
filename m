From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Date: Fri, 4 Oct 2013 20:33:15 +0200
Message-ID: <20131004183315.GA19557@quack.suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
 <32E1700B9017364D9B60AED9960492BC211B0176@FMSMSX107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211B0176-AtyAts71sc9zLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri 04-10-13 13:52:49, Marciniszyn, Mike wrote:
> > Convert qib_get_user_pages() to use get_user_pages_unlocked().  This
> > shortens the section where we hold mmap_sem for writing and also removes
> > the knowledge about get_user_pages() locking from ipath driver. We also fix
> > a bug in testing pinned number of pages when changing the code.
> > 
> 
> This patch and the sibling ipath patch will nominally take the mmap_sem
> twice where the old routine only took it once.   This is a performance
> issue.
  It will take mmap_sem only once during normal operation. Only if
get_user_pages_unlocked() fail, we have to take mmap_sem again to undo
the change of mm->pinned_vm.

> Is the intent here to deprecate get_user_pages()?
  Well, as much as I'd like to, there are really places in mm code which
need to call get_user_pages() while holding mmap_sem to be able to inspect
corresponding vmas etc. So I want to reduce get_user_pages() use as much as
possible but I'm not really hoping in completely removing it.

> I agree, the old code's lock limit test is broke and needs to be fixed.
> I like the elimination of the silly wrapper routine!
> 
> Could the lock limit test be pushed into another version of the wrapper
> so that there is only one set of mmap_sem transactions?
  I'm sorry, I don't understand what you mean here...

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
