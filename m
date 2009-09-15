From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Tue, 15 Sep 2009 01:27:57 -0700
Message-ID: <adad45shasy.fsf@cisco.com>
References: <20090911064019.GZ4973@obsidianresearch.com>
	<adaljklifkt.fsf@cisco.com>
	<20090915155231.DB86.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751260AbZIOI2E@vger.kernel.org>
In-Reply-To: <20090915155231.DB86.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's
	message of "Tue, 15 Sep 2009 16:03:04 +0900 (JST)")
Sender: linux-kernel-owner@vger.kernel.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Brice Goglin <Brice.Goglin@inria.fr>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, general@lists.openfabrics.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, jsquyres@cisco.com
List-Id: linux-rdma@vger.kernel.org


 >  - I guess you have your MPI implementaion w/ ummunotify, right?

Yes, Jeff Squyres (cc'ed) has an Open MPI prototype (mercurial tree at
http://bitbucket.org/jsquyres/ummunot/).

 >  - I guess you have test sevaral pattern, right?
 >    if so, can we see your test result?

Open MPI has a pretty extensive automated test fabric -- I don't have a
link handy but I believe all the tests that pass with unmodified Open
MPI currently still pass with ummunotify.  Maybe Jeff has a link.

 >  - I think you can explain your MPI advantage/disadvantage against
 >    current OpenMPI (or mpich et al).

The advantage is as Jeff explained in his blog post
(http://blogs.cisco.com/ciscotalk/performance/comments/better_linux_memory_tracking/),
namely the performance improvement of memory registration caching
without the reliability problems caused by previous approaches to
caching such as trying to hook malloc etc (which are fragile because the
great diversity of MPI-using codes find ways to mess up all previous
userspace-only approaches).

 >  - I guess your patch dramatically improve MPI implementaion, but
 >    it's not free. it request some limitation to MPI application, right?

Not that I know of, beyond already existing limitations.

 >  - I imagine multi thread and fork. Is there another linmitaion?

There are no new limitations on multi-threaded codes or on use of fork
that I know of.  Of course, buggy code that does something like passing
a buffer to MPI in one thread and then freeing that buffer from another
thread before MPI is done with it is still buggy; but ummunotify
actually increases the ability of the MPI implementation to detect such
bugs and give useful diagnostic information.

 >  - In past discuttion, you said ummunotify user should not use
 >    multi threading. you also think user should not fork?

I don't recall where I said ummunotify users should not be
multithreaded.  I don't know of any problem with that.

Also code using ummunotify can fork -- ummunotify simply does not fix
issues with copy-on-write for buffers that are in use, just as it does
not fix multithreaded code that has a race between using a buffer and
freeing the same buffer.

Hope this clarifies things.

 - Roland
