From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: [WTF] utterly tasteless ABI in hfi1 (around ->write()/->write_iter())
Date: Wed, 16 Mar 2016 04:17:18 +0000
Message-ID: <20160316041717.GJ17997@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

	Folks, we'd discussed that kind of crap already; why, in name of
everything unholy, is that kind of garbage brought back in a new driver?

	Having both ->write() and ->write_iter() *AND* having entirely
unrelated interpretation of user input on those two on the same device
is bogus, with the capital Stop That Shit Right Now.

	As it is, write(fd, p, len) and writev(fd, &(struct iovec){p,len}, 1)
are interpreted in absolutely unrelated ways.  As in, entirely different
set of commands.  Moreover, aio IOCB_CMD_PWRITE matches writev(), not write().

	What's going on?  Sure, ipathfs is a precious snowflake with the same
kind of braindamage.  Back when it had been brought to your attention
(along with the fact that this piece of idiocy happens to be a file on
filesystem of your own, under your full control and no need whatsofuckingever
to multiplex completely unrelated sets of commands on the same file with
"was it write(2) or writev(2)?" used as a selector) the answer had been
basically "it doesn't have to make sense, it's Special".  Now it turns out
that it has grown an equally special sibling.  With the idiocy directly
exposed as userland ABI.  Could we please fix that thing before it's cast in
stone?

	Take a look at drivers/staging/rdma/hfi1/file_ops.c in -next and
compare hfi1_write_iter() with hfi1_file_write().  Folks, this ABI is too
ugly to live, let alone to be allowed breeding.

	It's also brittle as hell - trivial massage around fs/read_write.c
and fs/aio.c is quite capable of breaking that shit.  Arguably, IOCB_CMD_PWRITE
and IOCB_CMD_PWRITEV both triggering your writev() semantics is an example of
just such breakage.  Sigh...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
