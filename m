From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v2 02/15] IB/srp: Fix race between srp_queuecommand()
 and srp_claim_req()
Date: Fri, 28 Jun 2013 16:42:21 +0200
Message-ID: <51CDA0CD.6060504@profitbricks.com>
References: <51CD856A.3010102@acm.org> <51CD8604.5010801@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD8604.5010801-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28.06.2013 14:48, Bart Van Assche wrote:
> Avoid that srp_claim_command() can claim a command while
> srp_queuecommand() is still busy queueing the same command.
> Found this via source reading.

Nice, that's much less re-acquiring of the target lock in error case in
srp_queuecommand().
But if we have to change that many locations for srp_put_tx_iu() anyway,
wouldn't it make sense to rename it into __srp_put_tx_iu() as well?

Then we can also put a little description to it and it looks familiar
compared to __srp_get_tx_iu().

The description could look like follows:
/*
 * Return an IU and possible credit to the free pool
 *
 * Must be called with target->lock held to protect free_tx.
 */

I'm not sure if we still need that lockdep_assert_held() then. There is
no other location with lock debugging in ib_srp.

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
