From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [GIT PULL] please pull ummunotify
Date: Tue, 15 Sep 2009 13:34:34 +0200
Message-ID: <20090915113434.GF1328@ucw.cz>
References: <aday6omhz9d.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753262AbZIOLeq@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aday6omhz9d.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, jsquyres@cisco.com, linux-rdma@vger.kernel.org, general@lists.openfabrics.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi!

> Linus, please consider pulling from
> 
>     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git ummunotify
> 
> This tree is also available from kernel.org mirrors at:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git ummunotify
> 
> This will get "ummunotify," a new character device that allows a
> userspace library to register for MMU notifications; this is
> particularly useful for MPI implementions (message passing libraries
> used in HPC) to be able to keep track of what wacky things consumers
> do to their memory mappings.  My colleague Jeff Squyres from the Open
> MPI project posted a blog entry about why MPI wants this:
> 
> http://blogs.cisco.com/ciscotalk/performance/comments/better_linux_memory_tracking/
> 
> His summary of ummunotify:
> 
>   "It???s elegant, doesn???t require strange linker tricks, and seems to
>    work in all cases.  Yay!"
> 
> This code went through several review iterations on lkml and was in
> -mm and -next for quite a few weeks.  Andrew is OK with merging it (I
> think -- Andrew please correct me if I misunderstood you).

I don't remember seeing discussion of this on lkml. Yes it  is in
-next...

Basically it allows app to 'trace itself'? ...with interesting mmap()
interface, exporting int to userspace, hoping it behaves atomically...? 
	
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
