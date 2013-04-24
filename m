From: Christoph Lameter <cl@linux.com>
Subject: Re: Infiniband use of get_user_pages()
Date: Wed, 24 Apr 2013 15:43:58 +0000
Message-ID: <0000013e3cb72e66-58330751-246a-4ac4-94d7-897754e59b3d-000000@email.amazonses.com>
References: <20130424153810.GA25958@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130424153810.GA25958@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 24 Apr 2013, Jan Kara wrote:

>   Hello,
>
>   when checking users of get_user_pages() (I'm doing some cleanups in that
> area to fix filesystem's issues with mmap_sem locking) I've noticed that
> infiniband drivers add number of pages obtained from get_user_pages() to
> mm->pinned_vm counter. Although this makes some sence, it doesn't match
> with any other user of get_user_pages() (e.g. direct IO) so has infiniband
> some special reason why it does so?

get_user_pages typically is used to temporarily increase the refcount. The
Infiniband layer needs to permanently pin the pages for memory
registration.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
