From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 15/18] ib_srp: Maintain a single connection per I_T nexus
Date: Sat, 03 Mar 2012 15:30:04 +0000
Message-ID: <4F5238FC.1040703@acm.org>
References: <3109536.qySrY1Ts3e@asus> <6527223.rH6NsR1Dga@asus> <1330238040.1026.89.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330238040.1026.89.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/26/12 06:34, David Dillow wrote:
> On Sat, 2012-01-14 at 12:54 +0000, Bart Van Assche wrote:
>> The sysfs attribute 'add_target' may be used to relogin to a
>> target. An SRP target that receives a second login request from
>> an initiator will disconnect the previous connection. So before
>> trying to reconnect, check whether another connection to the
>> same SRP target identifier already exists. If so, remove the
>> target port.  Add a target to the target list before connecting
>> instead of after such that this algorithm has a chance to work.
> I was OK before with preventing the addition of a duplicate connection,
> but the initiator shouldn't be enforcing the removal of previous
> connections -- that should happen via the target issuing a DREQ.
>
> If you're going to disallow duplicate requests, then just disallow
> adding the new one, don't tear down the old one -- let the admin
> manually do that if desired.

But why to wait with disconnecting stale connections until the target
sends a DREQ if we know the target is going to send it anyway ? Such an
approach would make it necessary to introduce an extra state ("stale
connection but not yet cleaned up by target"). Does that approach have
any advantage over the approach followed in the patch I posted ?

Please note that this behavior was introduced because one of your
comments on the v1 series was that you considered allowing an
administrator to issue a duplicate login request as useful functionality
(http://www.spinics.net/lists/linux-rdma/msg10451.html).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
