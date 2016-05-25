From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 21:46:16 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB050A07@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com> <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com>
 <20160525205156.GB5525@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160525205156.GB5525-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I want the core ioctl framework to do this:
> >
> > 1. Map user objects to/from the kernel to validate pointers.
> > 2. Provide reference counting on such objects, in order to protect against the user attempting to
> destroy objects that are in use.
> > 3. Provide protection that the state of an object is not driven in two different directions.
> > 4. Safely process the removal of the underlying driver or device.
> > 5. Support driver specific operations to the kernel.
> > 6. Report events from multiple sources to a single file descriptor.
> > 7. Minimize the kernel footprint for allocated kernel objects.
> > 8. Minimize the code path needed to process any ioctl, without greatly affecting maintainability.
> > 9. Copy ioctl input/output data to/from the kernel.
> 
> I agree with all of this as a suitable goal for the common
> dispatch/marshal framework.
> 
> I like the idea of the generic uobject stuff in your patches.
> 
> #6 seems 'not like the others' - seems like a reasonable concrete
> thing to consider as we build the objects on the
> framework. [understanding that compat operation is still required]

I agree.  Handling event reporting in general is slightly different from the other objections.  But it ties in with object close processing, so I think the framework needs something here.

#6 is based on examining the application APIs and driving requirements down.  I.e. poll a single fd to get all events: CQ notifications, async events, CM disconnect events, etc.  And while I'm thinking about it, expand events to support user specified.  This would allow many apps to rid themselves of socketpairs which currently fill that role.


> This is why I wasn't thinking of using the ioctl # to dispatch the
> method. It is best if the driver specific calls have globally unique
> identifiers of some sort to protect against calling a method on the
> wrong driver.

I thought of this as well.  I'll see if I can fit it into my next revision.


> I would encourage you to go as far as Mellanox's series does and
> demonstrate the verbs context object in this framework ...

I'm planning on going as far as issuing rdma cm commands, though through a 'quick' method that leaves the existing kernel code mostly intact.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
