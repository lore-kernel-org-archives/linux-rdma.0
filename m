From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 14:51:56 -0600
Message-ID: <20160525205156.GB5525@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com>
 <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB050907-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2016 at 07:59:29PM +0000, Hefty, Sean wrote:
> > It is time for the people who are hand waving about non-verbs, non-qp,
> > 'new data transfers' to sit down and specify what they want to see out
> > of the kernel uABI.
> 
> I want the core ioctl framework to do this:
> 
> 1. Map user objects to/from the kernel to validate pointers.
> 2. Provide reference counting on such objects, in order to protect against the user attempting to destroy objects that are in use.
> 3. Provide protection that the state of an object is not driven in two different directions.
> 4. Safely process the removal of the underlying driver or device.
> 5. Support driver specific operations to the kernel.
> 6. Report events from multiple sources to a single file descriptor.
> 7. Minimize the kernel footprint for allocated kernel objects.
> 8. Minimize the code path needed to process any ioctl, without greatly affecting maintainability.
> 9. Copy ioctl input/output data to/from the kernel.

I agree with all of this as a suitable goal for the common
dispatch/marshal framework.

I like the idea of the generic uobject stuff in your patches.

#6 seems 'not like the others' - seems like a reasonable concrete
thing to consider as we build the objects on the
framework. [understanding that compat operation is still required]

> I started re-working my patch to address the rdma cm.  The original
> proposal wasn't generic enough and provided a poor fit, because the
> rdma cm has a single object and 25 versions of 'modify'.

I was imagining that all objects would be able to have a set of object
specific functions beyond the common set. IIRC some verbs objects will
need this as well, and I expect drivers to want it.

This is why I wasn't thinking of using the ioctl # to dispatch the
method. It is best if the driver specific calls have globally unique
identifiers of some sort to protect against calling a method on the
wrong driver.

I would encourage you to go as far as Mellanox's series does and
demonstrate the verbs context object in this framework ...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
