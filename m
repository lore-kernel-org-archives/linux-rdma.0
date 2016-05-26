From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Thu, 26 May 2016 18:07:02 +0000
Message-ID: <HE1PR05MB1418B4396F696F763D67A893B1410@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com> <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com>
 <20160525205156.GB5525@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160525205156.GB5525-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Wednesday, May 25, 2016 11:52 PM

> >
> > I want the core ioctl framework to do this:
> >
> > 1. Map user objects to/from the kernel to validate pointers.
> > 2. Provide reference counting on such objects, in order to protect against the
> user attempting to destroy objects that are in use.
> > 3. Provide protection that the state of an object is not driven in two different
> directions.
> > 4. Safely process the removal of the underlying driver or device.
> > 5. Support driver specific operations to the kernel.
> > 6. Report events from multiple sources to a single file descriptor.
> > 7. Minimize the kernel footprint for allocated kernel objects.
> > 8. Minimize the code path needed to process any ioctl, without greatly
> affecting maintainability.
> > 9. Copy ioctl input/output data to/from the kernel.
> 
> I agree with all of this as a suitable goal for the common dispatch/marshal
> framework.
> 

The goals are OK.
However, I think that processing object locking before validation is not secure.
A malicious user could easily cause a deadlock due to ordering.

Rather, IDR processing should be offered as helper functions to method handlers *after* parameter validation.
This also removes the need to pass arrays of objects separately from the command attributes, which looks cumbersome.

I hope that we can show this in our next revision.
--Liran

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
