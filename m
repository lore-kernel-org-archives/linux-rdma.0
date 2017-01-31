From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Tue, 31 Jan 2017 16:06:11 +0100
Message-ID: <1485875171.4257.18.camel@profitbricks.com>
References: <1485446147.4194.4.camel@profitbricks.com>
         <20170126171325.GA16562@obsidianresearch.com>
         <20170126173548.GA15006@infradead.org>
         <1485865383.4257.10.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485865383.4257.10.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Dienstag, den 31.01.2017, 13:23 +0100 schrieb Benjamin Drung:
> Am Donnerstag, den 26.01.2017, 09:35 -0800 schrieb Christoph Hellwig:
> > On Thu, Jan 26, 2017 at 10:13:25AM -0700, Jason Gunthorpe wrote:
> > > I missed asking for this when the ibv_cmd_create_ah@IBVERBS_1.4
> > > patch
> > > was merged, but before we release 13 we need to drop all the
> > > ibv_cmd_*
> > > entry points from the public headers so that nothing outside
> > > rdma-
> > > core
> > > can link to these symbols.
> > 
> > A good thing would be to move all these symbols into a
> > @IBVERBS_PRIVATE
> > namespace, similar to what glibc does for it's internal library
> > only
> > exports.
> 
> I am fine with moving the private symbols into a IBVERBS_PRIVATE_XX
> namespace as long as all consumers of the private symbols are build
> from the rdma-core source package. I need to check if there is a
> package in Debian that uses the private symbols.

I brought this question to the debian-devel mailing list:
https://lists.debian.org/debian-devel/2017/01/msg00791.html

One private feedback was that removing symbols without bumping the
soname is a really bad idea (even if they are private symbols). So one
option would be to bump the soname once and remove all private symbols
in that run.

I searched for "ibv_cmd_" in Debian's source code:
https://codesearch.debian.net/search?q=ibv_cmd_
It boils down to these source packages:

shipped by rdma-core
====================

* librdmacm
* libibverbs

provided by ibverbs-providers
=============================

* libcxgb3
* libmlx5
* libmthca
* libnes
* libipathverbs
* libmlx4

remaining
=========

* openmpi

openmpi uses ibv_cmd_open_xrcd in config/opal_check_openfabrics.m4:

   # We have to check functions both exits *and* are declared
   # since some distro ship broken ibverbs devel headers
   # IBV_DEVICE_XRC is common to all OFED versions
   # ibv_create_xrc_rcv_qp was added in OFED 1.3
   # ibv_cmd_open_xrcd (aka XRC Domains) was added in  OFED 3.12

So I recommend to contact openmpi to let them change their configure
check to not check for ibv_cmd_open_xrcd any more.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:  http://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
