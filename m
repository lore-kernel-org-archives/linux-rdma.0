From: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] IB/srp: disconnect to SRP target before removing SCSI
 host
Date: Fri, 11 Jan 2013 15:07:06 +0100
Message-ID: <20130111140706.GK7859@gmail.com>
References: <1357394162-26316-1-git-send-email-dongsu.park@profitbricks.com>
 <50EAB2E1.7050702@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50EAB2E1.7050702-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On 07.01.2013 12:34, Bart Van Assche wrote:
> Sorry but this patch looks wrong to me, and that because of the
> following reasons:
> - A root cause analysis is missing. It has been mentioned in the patch
>   description that device_del() did hang but an analysis of why that
>   hang occurred is missing.
> - An explanation of why the above patch prevents device_del() to hang is
>   missing.
> - Invoking srp_disconnect_target() before scsi_remove_host() is wrong
>   because it prevents the SYNCHRONIZE CACHE command issued by
>   sd_shutdown() to reach the SRP target.

I'm sorry for confusion. Please ignore my patch.
I agree with you, that was not the solution.
Last week there was a confusion in our local test environment.

Let me describe the problem more clearly.

Let's say an SRP target machine crashed accidently without giving back
any IB events. Immediately after that crash, on the initiator-side,
the administrator tries to destroy the SRP target or deleting remote
port, in order to perform any emergency action.

However, that action will hang forever until the target machine comes up
again. Precisely it's blocked on scsi_execute() directly after sending
SYNCHRONIZE_CACHE command to the first target of the host. As IB stack
is not able to give any response, further target remove cannot be done.

After doing git bisect, I found out 1 commit that causes the problem:
4b2e8ea "IB/srp: Keep processing commands during host removal".
Reverting this commit, the problem is gone. No blocking any more.

But the symptom seems to differ slightly according to kernel versions.
With srp-ha v4/v5 on top of kernel 3.4.23, the revert is necessary.
But on your current tree srp-ha-v3.7 on top of kernel 3.7, the revert
is not needed any more. It just works without blocking on target remove.
I'm not sure exactly what has changed between 3.4.23 and 3.7.

Anyway I'm now satisfied with the current revert patch on top of 3.4.23.
See also my github branches.
<https://github.com/advance38/linux/tree/srp-ha-v4-3.4.23>

> Note: although I'm not sure which issue exactly you ran into, this
> patch may help: "[PATCH for-next] IB/srp: Make SCSI error handling
> finish" (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg13711.html).

No, that was not the problem I meant.
The patch didn't bring anything either.

Regards,
Dongsu

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
