From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 18/18] ib_srp: Rework error handling
Date: Sun, 04 Mar 2012 17:05:38 +0000
Message-ID: <4F53A0E2.3080101@acm.org>
References: <3109536.qySrY1Ts3e@asus> <2527465.kS0UWM2o6z@asus> <1330238354.1026.93.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330238354.1026.93.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/26/12 06:39, David Dillow wrote:
> On Sat, 2012-01-14 at 12:57 +0000, Bart Van Assche wrote:
>> Add fast_io_fail_tmo and dev_loss_tmo sysfs attributes. Block
>> the SCSI target as soon as a transport layer error has been
>> detected (ping timeout, disconnect or IB error completion). Try
>> to reconnect until dev_loss_tmo elapses.
>>
>> Disconnect the IB connection earlier in srp_remove_target() to
>> make sure that error recovery is not triggered during host
>> removal. Swap the "connected" and "removed" tests in
>> srp_queuecommand() because of this change.
>>
>> Rescan LUNs after having unblocked a SCSI target controlled by
>> ib_srp.
> As I've previously said, this is better handled by user space and
> you add additional failure cases when you try to retrofit a transport
> ping into SRP.

Let's look at this from another point of view. If it's possible for the
SRP protocol to implement most of the transport layer checking and error
handling in user space then that's possible for iSCSI and FC too. Are
you claiming that the device mapper layer and the multipath software
should be redesigned such that certain parts of the transport checking
and recovery mechanisms are moved from kernel space to user space,
including a backwards-incompatible change of the kernel ABI (sysfs) the
multipath software uses today ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
