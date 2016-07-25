From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Mon, 25 Jul 2016 11:39:32 -0600
Message-ID: <20160725173932.GA18773@obsidianresearch.com>
References: <20160720172143.GG21460@obsidianresearch.com>
 <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org>
 <20160721015613.GB8279@obsidianresearch.com>
 <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org>
 <20160721032803.GA12093@obsidianresearch.com>
 <alpine.DEB.2.20.1607202340280.26638@east.gentwo.org>
 <20160721054439.GA19329@obsidianresearch.com>
 <20160721080433.GA21060@infradead.org>
 <20160721162033.GB19849@obsidianresearch.com>
 <alpine.DEB.2.20.1607251131000.23039@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1607251131000.23039-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 25, 2016 at 11:32:23AM -0500, Christoph Lameter wrote:
> On Thu, 21 Jul 2016, Jason Gunthorpe wrote:
> 
> > I'm not so sure I want to see MLX5_CREATE_QP, MLX4_CREATE_QP,
> > QIB_CREATE_QP, etc, etc as ioctl numbers, that seems difficult
> > to implement the common code for.
> 
> Nobody wants that.... Why would that follow? Of course we would have
> common ioctls that create QPs in the same way for all drivers.

No, not of course. We don't have that today. Today every single
command is split between a commmon part and a variable sized (two-way)
driver-specific part. Nobody has come up with some way to avoid that,
so the plan is to continue that scheme.

Thus, every ioctl has a unique struct layout for every driver.

Christoph H. just said dynamic variable sized ioctl input structures
are ugly, so this is an alternative. Is this alternative less ugly
than the variable struct?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
