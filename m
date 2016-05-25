From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 11:06:51 -0600
Message-ID: <20160525170651.GA10940@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0502ED@ORSMSX109.amr.corp.intel.com>
 <20160524231359.GA10664@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050592@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB050592-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2016 at 02:59:41PM +0000, Hefty, Sean wrote:
> > As I outlined, the genesis to do this was to migrate libibverbs to an
> > ioctl interface and in the process set a better stage for all the
> > other things people want to do. That includes better supporting
> > non-libibverbs libraries (dpdk, libfabric, whatever)
> 
> Then create ioctl 1 - direct mapping of the write interface
> Ioctl 2-255 - extensions

That is an option..

> > The purpose of the object/method style framework was to better set the
> > stage for the core code to provide that kind of wider interface for
> > the drivers.
> 
> I tried applying this to the rdma cm.  It's a very poor fit.

I'm very surprised by this, what do we have to do for rdma cm then?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
