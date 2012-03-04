From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 18/18] ib_srp: Rework error handling
Date: Sun, 04 Mar 2012 15:03:06 -0500
Message-ID: <1330891386.1243.18.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <2527465.kS0UWM2o6z@asus>
	 <1330238354.1026.93.camel@obelisk.thedillows.org>
	 <4F53A0E2.3080101@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F53A0E2.3080101-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2012-03-04 at 17:05 +0000, Bart Van Assche wrote:
> On 02/26/12 06:39, David Dillow wrote:
> > As I've previously said, this is better handled by user space and
> > you add additional failure cases when you try to retrofit a transport
> > ping into SRP.
> 
> Let's look at this from another point of view. If it's possible for the
> SRP protocol to implement most of the transport layer checking and error
> handling in user space then that's possible for iSCSI and FC too. Are
> you claiming that the device mapper layer and the multipath software
> should be redesigned such that certain parts of the transport checking
> and recovery mechanisms are moved from kernel space to user space,
> including a backwards-incompatible change of the kernel ABI (sysfs) the
> multipath software uses today ?

You mean, let's do it the way it already works?

multipath implements path-checking on a *per-LUN* basis from user space.
Today. No redesign needed. It already works on all SCSI transports.

iSCSI has a protocol-defined mechanism to tell us when all LUNs on a
given target are unavailable without waiting for the connection to be
broken on a command timeout. I don't think FC has that, but it does have
notification that a target is out of the fabric -- and all LUNs are
unavailable. Both of these situations are communicated via an existing
sysfs ABI, and the user space multipath code knows how to fail over and
avoid checking those paths that are known to be bad.

SRP does not have a protocol-defined way to check the link to the
target. IB can tell us when a target leaves the fabric, like FC, but
that's not what you're trying to implement -- you are attempting to fake
the ping capability of iSCSI.

Implementing "most" of the transport layer checking gives you a partial
kernel implementation of the pinging already performed by user space,
and adds bugs to it in that a single LUN experiencing issues may fail
the whole path when the rest of the target is perfectly fine.

Adding bugs while re-implementing user space prevents me from signing
off on it.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
