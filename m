From: Hoang-Nam Nguyen <HNGUYEN-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ehca: Reduce number of spin_lock/spin_unlocks in
 ehca_poll_eqs
Date: Mon, 30 Nov 2009 09:19:17 +0100
Message-ID: <OF3F51C78F.30BE96FC-ONC125767E.002C8F45-C125767E.002DB662@de.ibm.com>
References: <20091127031320.GV32182@kryten> <adad430y450.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adad430y450.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joachim Fenkes <FENKES-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Roscher <ossrosch-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,
Yes, you're right. The loop below is a fallback to detect possibly missing
irq events
by checking the eq pointer, which can be changed by irq handler.
@Anton, for above reason we can not remove the lock/unlock within the loop.
Thanks,
Nam

Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote on 30.11.2009 06:26:35:

> [image removed]
>
> Re: [PATCH] IB/ehca: Reduce number of spin_lock/spin_unlocks in
ehca_poll_eqs
>
> Roland Dreier
>
> to:
>
> Anton Blanchard
>
> 30.11.2009 06:26
>
> Cc:
>
> Hoang-Nam Nguyen, Christoph Raisch, Stefan Roscher, Alexander
> Schmidt, Joachim Fenkes, linux-rdma
>
>
>  > +
>  >           spin_lock_irqsave(&eq->spinlock, flags);
>  > +
>  >           q_ofs = eq->ipz_queue.current_q_offset;
>  > -         spin_unlock_irqrestore(&eq->spinlock, flags);
>  >           do {
>  > -            spin_lock_irqsave(&eq->spinlock, flags);
>  >              q_ofs2 = eq->ipz_queue.current_q_offset;
>  > -            spin_unlock_irqrestore(&eq->spinlock, flags);
>  >              max--;
>  >           } while (q_ofs == q_ofs2 && max > 0);
>  > +
>  > +         spin_unlock_irqrestore(&eq->spinlock, flags);
>  > +
>
> Does this loop have to drop the lock to give the EQ code a chance to
> update the queue pointer?  If I understand this correctly, the EQ
> polling code is just trying to have a fallback if interrupts don't
> work...
>
>  - R.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
