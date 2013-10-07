From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Date: Mon, 7 Oct 2013 15:38:24 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211B07B7@FMSMSX107.amr.corp.intel.com>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
 <32E1700B9017364D9B60AED9960492BC211B0176@FMSMSX107.amr.corp.intel.com>
 <20131004183315.GA19557@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20131004183315.GA19557@quack.suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> > This patch and the sibling ipath patch will nominally take the mmap_sem
> > twice where the old routine only took it once.   This is a performance
> > issue.
>   It will take mmap_sem only once during normal operation. Only if
> get_user_pages_unlocked() fail, we have to take mmap_sem again to undo
> the change of mm->pinned_vm.
>=20
> > Is the intent here to deprecate get_user_pages()?

The old code looked like:
__qib_get_user_pages()
	(broken) ulimit test
             for (...)
		get_user_pages()

qib_get_user_pages()
	mmap_sem lock
	__qib_get_user_pages()
             mmap_sem() unlock

The new code is:

get_user_pages_unlocked()
	mmap_sem  lock
	get_user_pages()
	mmap_sem unlock

qib_get_user_pages()
	mmap_sem lock
             ulimit test and locked pages maintenance
             mmap_sem unlock
	for (...)
		get_user_pages_unlocked()

I count an additional pair of mmap_sem transactions in the normal case.

>=20
> > Could the lock limit test be pushed into another version of the
> > wrapper so that there is only one set of mmap_sem transactions?
>   I'm sorry, I don't understand what you mean here...
>=20

This is what I had in mind:

get_user_pages_ulimit_unlocked()
	mmap_sem  lock
	ulimit test and locked pages maintenance (from qib/ipath)
             for (...)
	       get_user_pages_unlocked()=09
	mmap_sem unlock
=09
qib_get_user_pages()
	get_user_pages_ulimit_unlocked()

This really pushes the code into a new wrapper common to ipath/qib and any =
others that might want to combine locking with ulimit enforcement.

Mike

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
