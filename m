From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V1 4/8] RDMA/core: Add support for custom types
Date: Wed, 20 Jul 2016 11:49:05 -0600
Message-ID: <20160720174905.GL21460@obsidianresearch.com>
References: <20160712192345.GC8206@obsidianresearch.com>
 <081a02c0-0650-d0c2-494c-19a64b83cbc1@mellanox.com>
 <20160713163924.GA19657@obsidianresearch.com>
 <0959d391-75fb-75e8-ef2e-9d8c06b1b96f@mellanox.com>
 <20160713172116.GC19657@obsidianresearch.com>
 <5fdae959-5ab2-ee17-e36e-3642ddd3e6ce@mellanox.com>
 <20160714164121.GA2046@obsidianresearch.com>
 <a1fcb1a7-0028-329a-d34a-ca8b52323916@mellanox.com>
 <20160719203609.GD16042@obsidianresearch.com>
 <9727f6e6-47fd-fb0a-537f-6264e8d742a9@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9727f6e6-47fd-fb0a-537f-6264e8d742a9-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 20, 2016 at 11:01:18AM +0300, Matan Barak wrote:

> But how would you know if rdma-cm is loaded and available? Don't we want to
> have a decent query interface rather than iterating through sysfs?
> I agree that it could be lower priority than the rest.

1) 'loaded available' I think you will agree we have a fairly bad user
   experience when it comes to autoloading modules. If we have one fd,
   and the core of that FD is part of the ib_core module that is
   pulled in on driver load then the a request for an API segment (eg uverbs,
   rdma_cm) can now actually trigger a module load, just like net does
   for PF's. So we actually get to a better, saner, place.

2) Yes, an in-band query interface makes much more sense than
   schlepping around sysfs. That could be done in the ioctl, or maybe
   via netlink, but as you say, lower priority.

> I meant moving to /dev/rdma_uapi, but when you fopen the device and get a
> fd, you could either have fd->NULL or fd->single_rdma_dev mapping.
> It's a little bit simpler, however, not that much from just doing 1:N
> mapping.

A major point of the unified interface is to sanely support rdma_cm
when working with multiple devices, so I'd expect 1:N is the only
reasonable option for that interface..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
