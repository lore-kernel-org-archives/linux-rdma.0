From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 02/14] IB/srp: Fix race between srp_queuecommand() and
 srp_claim_req()
Date: Wed, 12 Jun 2013 17:14:06 +0200
Message-ID: <51B8903E.3000609@acm.org>
References: <51B87501.4070005@acm.org> <51B875EE.3030702@acm.org> <51B88C7C.4030209@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B88C7C.4030209-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/12/13 16:58, Sebastian Riemer wrote:
> Wait a minute, so you've changed this commit to also hold that target
> lock in the following functions in error case:
>
> srp_unmap_data(),
> srp_put_tx_iu()
>
> This is different from:
> https://github.com/bvanassche/ib_srp-backport/commit/6ce0e30dbb69973926df84292239f0c20f6a2d6c
>
> srp_unmap_data() calls ib_fmr_pool_unmap() which uses an own spin lock
> (pool->pool_lock).
>
> srp_put_tx_iu() acquires the target lock as well (target->lock). That's
> spin lock in spin lock. I would say that this dead locks.
>
> I like the other version more.

Not sure how I missed that ... I will drop this version and replace it 
with the proper fix.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
