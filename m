From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 6/7] IB/core: Add support for fd objects
Date: Tue, 21 Feb 2017 12:24:33 -0700
Message-ID: <20170221192433.GE13138@obsidianresearch.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-7-git-send-email-matanb@mellanox.com>
 <20170210210350.GE4335@obsidianresearch.com>
 <CAAKD3BDbQVfC06Kzud=j=+a32YFxwcxrqm41SyhL0uWXm0O0Hw@mail.gmail.com>
 <20170215185448.GE19162@obsidianresearch.com>
 <CAAKD3BD-Uyg9bN=EaB3GbqhaKsKUszKXD6YaVAUxBp8cQcJgbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BD-Uyg9bN=EaB3GbqhaKsKUszKXD6YaVAUxBp8cQcJgbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 19, 2017 at 02:47:02PM +0200, Matan Barak wrote:

> >>
> >> All these callbacks are assumed to run when the context is alive.
> >
> > 'uboject->context' is touched outside the SRCU, eg in
> > uverbs_close_fd() - so it absolutely needs locking.
> >
> 
> uobject->context isn't protected by SRCU as intended.
> lookup_get_fd_uobject can't be executed concurrently with
> uverbs_close_fd, as uverbs_close_fd is called when the last
> reference of the fd is put and in that case fget called by
> lookup_get_fd_uobject would simply fail. Since fput and fget are
> atomically safe, this should be safe.

That is so tricky it needs a comment, but yes, that argument makes
sense for uverbs_close_fd().

But, you've just explained away every reason for this test:

+	if (f->f_op != fd_type->fops ||
+	    !uobject->context) {

It should probably be

	if (f->f_op != fd_type->fops) {
		fput(f);
		return ERR_PTR(-EBADF);
	}

	/* fget(id) ensures we are not currently running
	 * uverbs_close_fd, and the caller is expected to ensure
	 * that uverbs_cleanup_ucontext is never done while
	 * a call top lookup is possible. */
	WARN_ON(!uobject->context);
	if (!uobject->context) {
	        // Try to recover
		fput(f);
		return ERR_PTR(-EBADF);
	}

Or you need to explain where context = null comes from..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
