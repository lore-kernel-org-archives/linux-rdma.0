From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 11/20] ib_srp: Make srp_disconnect_target() wait for IB
 completions
Date: Thu, 23 Aug 2012 16:43:47 +0000
Message-ID: <50365DC3.1050807@acm.org>
References: <5023DA39.7020000@acm.org> <5023DCFF.4020709@acm.org> <5036536B.1000003@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5036536B.1000003-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/23/12 15:59, Sebastian Riemer wrote:
> we've triggered the WARN_ON() in srp_wait_last_send_wqe() by connecting
> to a disabled SCST SRP target.
> 
> I would remove that one.
> 
> [ ... ]
>
>> +	while (!target->last_send_wqe && time_before(jiffies, deadline)) {
>> +		srp_send_completion(target->send_cq, target);
>> +		msleep(20);
>> +	}
>> +
>> +	WARN_ON(!target->last_send_wqe);
> 
> <-- here it is - remove it

But why was that WARN_ON() statement hit ? srp_wait_last_send_wqe() is
invoked after the QP has been transitioned into the error state. It is
the responsibility of the HCA to generate an error completion for any
work queued on a QP that is in the error state. If that WARN_ON()
statement has been hit that means that it took more than the RC timeout
before the HCA finished processing earlier queued work and generated an
error completion. That's not really something I had expected.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
