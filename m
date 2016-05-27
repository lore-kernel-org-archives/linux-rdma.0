From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Fri, 27 May 2016 10:50:23 -0600
Message-ID: <20160527165023.GA2449@obsidianresearch.com>
References: <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com>
 <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com>
 <20160525205156.GB5525@obsidianresearch.com>
 <HE1PR05MB1418B4396F696F763D67A893B1410@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20160526184348.GA22174@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BBED@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05BBED-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 27, 2016 at 12:22:56AM +0000, Hefty, Sean wrote:

> A lock associated with the idr is held while objects are acquired.
> A simple reference count is bumped for each object when used.  If
> exclusive access is required, a flag is set.  If the exclusive flag
> is set, then any attempt to acquire the object is rejected and the
> ioctl fails.

How is that different from your basic idr+kref locking scheme common
in the kernel?

What is a non-blocking exclusive useful for? Removal?

> Coordination with the removal of the kernel client (i.e. device) is
> done using a rw-lock.  Ioctls acquire a read lock, while the removal
> processing acquires the write lock.

uverbs ended up using a more complex srcu scheme for this citing
performance reasons.. I argued for the simpler rwlock at the time..

> synchronization seems sufficient.  Any lower-level locking is the
> responsibility of the kernel client.

So there are still object locks, but the core doesn't help with them
at all.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
