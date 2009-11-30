From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/ehca: Reduce number of spin_lock/spin_unlocks in ehca_poll_eqs
Date: Sun, 29 Nov 2009 21:26:35 -0800
Message-ID: <adad430y450.fsf@roland-alpha.cisco.com>
References: <20091127031320.GV32182@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091127031320.GV32182@kryten> (Anton Blanchard's message of
	"Fri, 27 Nov 2009 14:13:20 +1100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Stefan Roscher <ossrosch-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > +
 >  			spin_lock_irqsave(&eq->spinlock, flags);
 > +
 >  			q_ofs = eq->ipz_queue.current_q_offset;
 > -			spin_unlock_irqrestore(&eq->spinlock, flags);
 >  			do {
 > -				spin_lock_irqsave(&eq->spinlock, flags);
 >  				q_ofs2 = eq->ipz_queue.current_q_offset;
 > -				spin_unlock_irqrestore(&eq->spinlock, flags);
 >  				max--;
 >  			} while (q_ofs == q_ofs2 && max > 0);
 > +
 > +			spin_unlock_irqrestore(&eq->spinlock, flags);
 > +

Does this loop have to drop the lock to give the EQ code a chance to
update the queue pointer?  If I understand this correctly, the EQ
polling code is just trying to have a fallback if interrupts don't
work...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
