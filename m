From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 3/8] IB/srp: allow lockless work posting
Date: Mon, 27 Dec 2010 12:39:20 -0500
Message-ID: <1293471560.2896.25.camel@obelisk.thedillows.org>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
	 <1293139893-11678-4-git-send-email-dillowda@ornl.gov>
	 <AANLkTikWXFRuP1EjtchrVvMRTLWEmanUO2OFqC4meLEZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikWXFRuP1EjtchrVvMRTLWEmanUO2OFqC4meLEZ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-12-27 at 16:37 +0100, Bart Van Assche wrote:
> On Thu, Dec 23, 2010 at 10:31 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > [ ... ]
> > @@ -876,7 +876,7 @@ static int __srp_post_send(struct srp_target_port *target,
> >        ret = ib_post_send(target->qp, &wr, &bad_wr);
> >
> >        if (!ret) {
> > -               ++target->tx_head;
> > +               list_del_init(&iu->list);
> 
> Why list_del_init() here instead of list_del() ?

I misread the list debugging code, and got the mistaken idea that it
also checked the list_head being added to the list.

> > +               INIT_LIST_HEAD(&target->tx_ring[i]->list);
> > +               list_add(&target->tx_ring[i]->list, &target->free_tx);
> 
> Why is INIT_LIST_HEAD() invoked above ? list_add() overwrites the prev
> and next pointers that have been cleared by INIT_LIST_HEAD().

Yeah, same deal. Will fix them both.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
