From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 18/18] ib_srp: Rework error handling
Date: Mon, 05 Mar 2012 19:42:24 +0000
Message-ID: <4F551720.9010604@acm.org>
References: <3109536.qySrY1Ts3e@asus> <2527465.kS0UWM2o6z@asus>  <1330238354.1026.93.camel@obelisk.thedillows.org>  <4F53A0E2.3080101@acm.org> <1330891386.1243.18.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330891386.1243.18.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/04/12 20:03, David Dillow wrote:
> multipath implements path-checking on a *per-LUN* basis from user space.
> Today. No redesign needed. It already works on all SCSI transports.
>
> iSCSI has a protocol-defined mechanism to tell us when all LUNs on a
> given target are unavailable without waiting for the connection to be
> broken on a command timeout. I don't think FC has that, but it does have
> notification that a target is out of the fabric -- and all LUNs are
> unavailable. Both of these situations are communicated via an existing
> sysfs ABI, and the user space multipath code knows how to fail over and
> avoid checking those paths that are known to be bad.
>
> SRP does not have a protocol-defined way to check the link to the
> target. IB can tell us when a target leaves the fabric, like FC, but
> that's not what you're trying to implement -- you are attempting to fake
> the ping capability of iSCSI.

Let's focus on what we agree about. I'll repost the patch series but
without the last two patches (those that add dev_loss_tmo,
fast_io_fail_tmo, ping_interval, ping_timeout, failed_reconnects and
reconnect_tmo).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
