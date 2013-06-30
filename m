From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 02/15] IB/srp: Fix race between srp_queuecommand()
 and srp_claim_req()
Date: Sun, 30 Jun 2013 15:59:07 -0400
Message-ID: <1372622347.12468.9.camel@haswell.thedillows.org>
References: <51CD856A.3010102@acm.org> <51CD8604.5010801@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD8604.5010801-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-06-28 at 14:48 +0200, Bart Van Assche wrote:
> Avoid that srp_claim_command() can claim a command while

I think you meant srp_claim_req() ?

> srp_queuecommand() is still busy queueing the same command.
> Found this via source reading.

The main issue seems to be a broken, possibly malicious, target? I'm not
sure I see another path to get into this race, as the scsi layer should
protect us from queue submission and error handling at the same time,
correct?

I'm not keen on giving up the command submission concurrency we worked
so hard to get -- you completely serialize command submission again. If
we really need to protect against this race -- and we probably should,
to guard against broken targets -- I think we can achieve the
concurrency and safety by improving the receive and error handling sides
-- especially if we can push it into error handling, as that's already a
slow path.

Let's push this patch to the back of the pile for any respin; I don't
think the others rely on it (haven't gotten there yet) and would rather
not hold them up for this.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
