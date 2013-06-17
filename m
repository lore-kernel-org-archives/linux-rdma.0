From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] mm: Revert pinned_vm braindamage
Date: Mon, 17 Jun 2013 14:28:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1306171417450.4234@ionos.tec.linutronix.de>
References: <20130606124351.GZ27176@twins.programming.kicks-ass.net> <20130613140632.15982af2ebc443b24bfff86a@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130613140632.15982af2ebc443b24bfff86a-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 13 Jun 2013, Andrew Morton wrote:
> Let's try to get this wrapped up?
> 
> On Thu, 6 Jun 2013 14:43:51 +0200 Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> > 
> > Patch bc3e53f682 ("mm: distinguish between mlocked and pinned pages")
> > broke RLIMIT_MEMLOCK.
> 
> I rather like what bc3e53f682 did, actually.  RLIMIT_MEMLOCK limits the
> amount of memory you can mlock().  Nice and simple.
> 
> This pinning thing which infiniband/perf are doing is conceptually
> different and if we care at all, perhaps we should be looking at adding
> RLIMIT_PINNED.

Actually PINNED is just a stronger version of MEMLOCK. PINNED and
MEMLOCK are both preventing the page from being paged out. PINNED adds
the constraint of preventing minor faults as well.

So I think the really important tuning knob is the limitation of pages
which cannot be paged out. And this is what RLIMIT_MEMLOCK is about.

Now if you want to add RLIMIT_PINNED as well, then it only limits the
number of pages which cannot create minor faults, but that does not
affect the limitation of total pages which cannot be paged out.

Thanks,

	tglx
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
