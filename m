From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 05/18] ib_srp: Separate connection and host state
Date: Sat, 03 Mar 2012 14:37:03 +0000
Message-ID: <4F522C8F.3020503@acm.org>
References: <3109536.qySrY1Ts3e@asus> <2010394.C571grUHsm@asus> <1330237948.1026.83.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330237948.1026.83.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/26/12 06:32, David Dillow wrote:
> On Sat, 2012-01-14 at 12:43 +0000, Bart Van Assche wrote:
>> Separate connection and host state. Only report QP errors while
>> connected. Only invoke ib_send_cm_dreq() from inside
>> srp_disconnect_target() when connected such that invoking
>> srp_disconnect_target() after having received a DREQ does not
>> cause an error message to be printed.
> I'm not sure that splitting connection state from the target state is
> really buying you anything other than more storage and complexity.
> I looked to later patches for a reason this makes sense, but I'm coming
> up short, so maybe I'm just missing it.

As explained in the description of this patch, this patch makes sense
even without the later changes.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
