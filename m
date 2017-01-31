From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Tue, 31 Jan 2017 10:35:00 -0700
Message-ID: <20170131173500.GA11210@obsidianresearch.com>
References: <1485446147.4194.4.camel@profitbricks.com>
 <20170126171325.GA16562@obsidianresearch.com>
 <20170126173548.GA15006@infradead.org>
 <1485865383.4257.10.camel@profitbricks.com>
 <1485875171.4257.18.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485875171.4257.18.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 31, 2017 at 04:06:11PM +0100, Benjamin Drung wrote:

> One private feedback was that removing symbols without bumping the
> soname is a really bad idea (even if they are private symbols). So one
> option would be to bump the soname once and remove all private symbols
> in that run.

Bumping the soname is also a really bad idea - we need to pick which
one is less bad :)

> I searched for "ibv_cmd_" in Debian's source code:
> https://codesearch.debian.net/search?q=ibv_cmd_
> It boils down to these source packages:

Neat. I also looked at the removed headerfiles which will cause FTBS.

dmtcp seems to include an old wrong copy of
libibverbs/examples/devinfo.c - I have no idea why.

usr/include/infiniband/arch.h
 dpdk 
 dmtcp
 fio
 qlvnictools
These seem to be using htonll/etc (replace with glibc's htobe64)

usr/include/infiniband/driver.h
 openmpi
 dmtcp
 libfabric
Most of these are probably unnecessary..

infiniband/marshall.h has none

> openmpi uses ibv_cmd_open_xrcd in config/opal_check_openfabrics.m4:
> 
>    # We have to check functions both exits *and* are declared
>    # since some distro ship broken ibverbs devel headers
>    # IBV_DEVICE_XRC is common to all OFED versions
>    # ibv_create_xrc_rcv_qp was added in OFED 1.3
>    # ibv_cmd_open_xrcd (aka XRC Domains) was added in  OFED 3.12
> 
> So I recommend to contact openmpi to let them change their configure
> check to not check for ibv_cmd_open_xrcd any more.

Yes, they will need to make a few small changes

This is a very small amount of usage and other than the htonll stuff,
none of it looks at all right to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
