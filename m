From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Fri, 27 May 2016 17:24:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB05C02D@ORSMSX109.amr.corp.intel.com>
References: <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com> <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com>
 <20160525205156.GB5525@obsidianresearch.com>
 <HE1PR05MB1418B4396F696F763D67A893B1410@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20160526184348.GA22174@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BBED@ORSMSX109.amr.corp.intel.com>
 <20160527165023.GA2449@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160527165023.GA2449-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > A lock associated with the idr is held while objects are acquired.
> > A simple reference count is bumped for each object when used.  If
> > exclusive access is required, a flag is set.  If the exclusive flag
> > is set, then any attempt to acquire the object is rejected and the
> > ioctl fails.
> 
> How is that different from your basic idr+kref locking scheme common
> in the kernel?

I don't view it as significantly different.  A kref is just an atomic anyway.

> What is a non-blocking exclusive useful for? Removal?

Removal and possibly modify calls.  Note that I only apply the exclusive flag to the first object in the list, so some ordering of what the objects are is required.  (I didn't expect clients to accept arbitrary ordering anyway.)

We can debate how the ioctl framework should serialize ioctl processing, versus pushing that functionality either into user space or the ioctl handlers.  My proposal serialized against device removal only, otherwise it failed the call if exclusive access was required.  This supports pushing the serialization either up or down, but it's outside the framework.

> > Coordination with the removal of the kernel client (i.e. device) is
> > done using a rw-lock.  Ioctls acquire a read lock, while the removal
> > processing acquires the write lock.
> 
> uverbs ended up using a more complex srcu scheme for this citing
> performance reasons.. I argued for the simpler rwlock at the time..

I guess I'm re-arguing for a simpler rwlock then.  :)  In any case, the actual locking mechanism can change.

> > synchronization seems sufficient.  Any lower-level locking is the
> > responsibility of the kernel client.
> 
> So there are still object locks, but the core doesn't help with them
> at all.

Moving this into a framework which doesn't understand what the objects actually are would be difficult.  I can see this being done by a uverbs core, which is one of the users of the ioctl framework.  The ucma is another user of this code.

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
