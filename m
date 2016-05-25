From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 19:59:29 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com> <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160525190039.GA5525-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> It is time for the people who are hand waving about non-verbs, non-qp,
> 'new data transfers' to sit down and specify what they want to see out
> of the kernel uABI.

I want the core ioctl framework to do this:

1. Map user objects to/from the kernel to validate pointers.
2. Provide reference counting on such objects, in order to protect against the user attempting to destroy objects that are in use.
3. Provide protection that the state of an object is not driven in two different directions.
4. Safely process the removal of the underlying driver or device.
5. Support driver specific operations to the kernel.
6. Report events from multiple sources to a single file descriptor.
7. Minimize the kernel footprint for allocated kernel objects.
8. Minimize the code path needed to process any ioctl, without greatly affecting maintainability.
9. Copy ioctl input/output data to/from the kernel.

If designed correctly, I believe that the ioctl core will be suitably generic to support uverbs, ucm (if kept), urdma cm, umad (if there's a reason to add new ioctls), and any drivers.  Honestly, there's very little that would stand in the way of future subsystems (e.g. accelerators like Xeon Phi, maybe nvm) adopting it, if they so choose, though I'm not suggesting that be a goal.

Even limiting the discussion to short term needs, the rdma cm requires the same update.  The same ioctl core should work there as well.  Otherwise, it's a very good indication that we will not meet the needs of whatever future drivers are thrown to linux-rdma, except to say use a driver specific channel and re-implement the above functionality.  I would go as far as mixing rdma cm, verbs, and driver ioctls on the same fd (driven by shared event reporting), and that's a different file structure than what we have today.

IMO, the format of the ioctl data is a much lower concern and not something the framework should be concerned about.  From the above requirements, the framework needs to understand specific types of operations: creation, close, and ones that require exclusive access.  Event handling requires more thought.

I started re-working my patch to address the rdma cm.  The original proposal wasn't generic enough and provided a poor fit, because the rdma cm has a single object and 25 versions of 'modify'.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
