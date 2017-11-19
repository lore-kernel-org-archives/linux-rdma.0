From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: mthca misuse of get_user_pages() (was Re: [git pull] vfs.git
 get_user_pages_fast() conversion)
Date: Sun, 19 Nov 2017 21:23:54 +0000
Message-ID: <20171119212354.GU21978@ZenIV.linux.org.uk>
References: <20171117030205.GL21978@ZenIV.linux.org.uk>
 <CA+55aFy+gsHRm+rBmimU3-PS_NUWyAd5Aq12=ygezQdX7_7LAg@mail.gmail.com>
 <20171117213215.GQ21978@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171117213215.GQ21978@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 17, 2017 at 09:32:15PM +0000, Al Viro wrote:

[snip]
> drivers/infiniband/hw/mthca/mthca_memfree.c:475:        ret = get_user_pages(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages, NULL);
[snip]

> Itanic
> one is almost certainly buggered - we are not holding ->mmap_sem there.

So's the mthca one - that caller (mthca_map_user_db()) does not take ->mmap_sem
and at least some of its calls are immediately preceded by copy_from_user().
If we don't have ->mmap_sem there, this get_user_pages() is oopsably racy; if
we do, those copy_from_user() calls is deadlock-prone.

To make things even nastier, mthca_map_user_db() does grab a mutex around the
chunk that contains get_user_pages() call:
        mutex_lock(&db_tab->mutex);
several lines prior.  And _that_ is taken on a whole lot of codepaths; if any of
those happen to be under ->mmap_sem, we can't grab ->mmap_sem just around that
get_user_pages().  I've poked around a bit, but I'm really unfamiliar with that
code...  The questions so far:
	* can mthca_map_user_db() ever be called under ->mmap_sem?  Looks like
it shouldn't, but...
	* do we really need that get_user_pages() under ->mutex?  Would something
like
	....
        if (db_tab->page[i].refcount) {
                ++db_tab->page[i].refcount;
                goto out;
        }
        mutex_unlock(&db_tab->mutex);
	ret = get_user_pages_fast(uaddr & PAGE_MASK, 1, true, pages);
        if (ret < 0)
                return ret;
        mutex_lock(&db_tab->mutex);
        if (unlikely(db_tab->page[i].refcount)) {
		/* lost the race */
		put_page(pages[0]);
                ++db_tab->page[i].refcount;
                goto out;
	}
	....
in place of the current
        if (db_tab->page[i].refcount) {
                ++db_tab->page[i].refcount;
                goto out;
        }

        ret = get_user_pages(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages, NULL);
        if (ret < 0)
                goto out;
be a usable solution?

Comments?
