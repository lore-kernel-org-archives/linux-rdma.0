From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Wed, 20 Jul 2016 19:56:13 -0600
Message-ID: <20160721015613.GB8279@obsidianresearch.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-6-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1607192021500.5828@east.gentwo.org>
 <53dd8337-0779-341e-49f5-ad675269bfe6@mellanox.com>
 <alpine.DEB.2.20.1607200448370.12616@east.gentwo.org>
 <20160720172143.GG21460@obsidianresearch.com>
 <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1607201950160.24804-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 20, 2016 at 07:57:09PM -0500, Christoph Lameter wrote:

> > The device_id part of the extension allows each driver to have its own
> > globally unique number space without requireing another ioctl block.
> 
> But you already have that uniqueness if the ioctl filehandle provides
> that.

The argument is that ioctls should be self-describing and never rely
on the filehandle to uniq them. That is basically standard in the
kernel, and why we have Documentation/ioctl/ioctl-number.txt
describing how to uniquely assign ioctl numbers.

There is nothing special here, we are just creating a much larger
ioctl # space by using (ioctl #, operation, device_id) as the globally
unique key, following existing best-practice if self-identifying ioctls.

> multi-device requirements in the network code require a new device that
> aggregates the other ones. The aggregation device is not world accessible.
> The same approach could be used for RDMA.

Some do, some don't. The rdma_cm requirement is more like
listen(0.0.0.0) which does not require special net device aggregation.

> > No, strace doesn't know what an open FD is, it just inspects the ioctl
> > # and content to do its decode. Requiring strace to decode differently
> > depending on what was opened would be the deviation from what we do
> > today.
> 
> It is the  basic Unix convention to have a descriptor/file handle refer to
> a device. There is nothing special required here from strace.

Sometimes yes, sometimes no. There are lots of examples both ways.

/dev/pts/ptmx, /dev/mapper/control, /dev/btrfs-control, etc, etc are
all examples of multi-device control fds similar to the proposed
single char dev.

.. and bear in mind that /dev/uverbs0 doesn't even really make that
much sense as it aggregates two physical ports. There is already no
way to split permissions up by port, which is a logical thing to want
for some dual-rail configurations.

What we have today really doesn't make much sense.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
