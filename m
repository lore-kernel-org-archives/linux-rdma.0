From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Thu, 21 Jul 2016 10:20:33 -0600
Message-ID: <20160721162033.GB19849@obsidianresearch.com>
References: <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com>
 <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org>
 <20160720172143.GG21460@obsidianresearch.com>
 <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org>
 <20160721015613.GB8279@obsidianresearch.com>
 <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org>
 <20160721032803.GA12093@obsidianresearch.com>
 <alpine.DEB.2.20.1607202340280.26638@east.gentwo.org>
 <20160721054439.GA19329@obsidianresearch.com>
 <20160721080433.GA21060@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160721080433.GA21060-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 21, 2016 at 01:04:33AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 20, 2016 at 11:44:39PM -0600, Jason Gunthorpe wrote:
> > How many ioctls have you used that use a complex variable sized struct
> > as the parameter?
> > 
> > There are a few and they ones I've used are self-describing one way or
> > another. Perhaps they have an op code or something in the struct, or a
> > netlink-like format, or *something* but you don't need to know what
> > the fd is connected to in order to parse the struct. The ioctl # and
> > the argument should be enough to parse.
> 
> In that case they are designed by taste-less fools.  No need to
> to spread that BS even further.

Well, what do you suggest then? This sounds like we are back to the
~500 ioctls. Is that OK & better?

This is not a small interface, and when you add in all the
driver-specific stuff there are *alot* of different API
call signatures..

I'm not so sure I want to see MLX5_CREATE_QP, MLX4_CREATE_QP,
QIB_CREATE_QP, etc, etc as ioctl numbers, that seems difficult
to implement the common code for.

> > You are really surprised by the rdma_cm architecture??? I know it is
> > goofy, but we are stuck with it..
> 
> Are we?  We'll need to stick to the wire format obviously, but the
> software architectures needs to die rather sooner than later.  It's the
> worst pile of junk in the RDMA subsystem, and that really means
> something.  It's almost impossible to use it correctly due to all the
> warts and un- or under-documented assumtions in it's APIs.

I think we are, it is baked into user space ...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
