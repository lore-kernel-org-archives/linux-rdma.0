From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: stalled again
Date: Tue, 1 Dec 2015 11:33:52 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512011123010.6809@east.gentwo.org>
References: <565DCB24.7020304@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565DCB24.7020304-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 1 Dec 2015, Or Gerlitz wrote:

> We're against into this... upstream is on 4.4-rc3 while your latest branch in
> kernel.org (the one that carries thefor-next tag) is rebased to 4.3-rc3...

Seems that everything was merged? So you can directly use 4.4-rc1
until he comes up with a for-next for 4.5.

> --> our internal build and review systems for patches to linux-rdma can'tmake
> any use of your tree. People here have to rebase their work against their own
> clones of Linus tree and can't work with our internal Gerrit rdma-next branch,
> etc, etc.

AFACIT The primary use for the next-trees is testing and merging. You
should be basing your work on 4.4-rc1 and all the patches you are carrying
need to apply to 4.4-rc1 cleanly. Unless you depend on functionality that
was added for the next merge cycle of course. But since there is no tree
yet nothing was added so there is nothing there for you to rely on.

Please do not base patches by default on -next tree's unless there is a
good reason for it. If you do otherwise the code base will change too
frequently. If the maintainer decides to drop a certain patchset your
patches may no longer apply cleanly.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
