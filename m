From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: stalled again
Date: Tue, 1 Dec 2015 10:13:10 -0800
Message-ID: <20151201181310.GB14080@kroah.com>
References: <565DCB24.7020304@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <565DCB24.7020304-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 01, 2015 at 06:30:28PM +0200, Or Gerlitz wrote:
> Doug,
> 
> We're against into this... upstream is on 4.4-rc3 while your latest branch
> in kernel.org (the one that carries thefor-next tag) is rebased to
> 4.3-rc3...
> 
> --> our internal build and review systems for patches to linux-rdma
> can'tmake any use of your tree. People here have to rebase their work
> against their own clones of Linus tree and can't work with our internal
> Gerrit rdma-next branch, etc, etc.

Why is your broken internal development process a concern to the kernel
community in general?

> We have to work in a very inefficient manner.

Then stop doing foolish things :)

> Any reason on earth not to rebase your tree (== create new branch, move
> their the for-next tag) after an rc1 is out? how long does this take?

Why does that matter?  You have access to everything, base your patches
on a -rc release.

And why are you concerning me with linux-rdma things, come on, you all
really don't want to drag me into this again...

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
