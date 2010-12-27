From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [RFC 3/8] IB/srp: allow lockless work posting
Date: Mon, 27 Dec 2010 16:37:02 +0100
Message-ID: <AANLkTikWXFRuP1EjtchrVvMRTLWEmanUO2OFqC4meLEZ@mail.gmail.com>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov> <1293139893-11678-4-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-4-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 23, 2010 at 10:31 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrot=
e:
> [ ... ]
> @@ -876,7 +876,7 @@ static int __srp_post_send(struct srp_target_port=
 *target,
> =A0 =A0 =A0 =A0ret =3D ib_post_send(target->qp, &wr, &bad_wr);
>
> =A0 =A0 =A0 =A0if (!ret) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++target->tx_head;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&iu->list);

Why list_del_init() here instead of list_del() ?

> @@ -1212,6 +1196,9 @@ static int srp_alloc_iu_bufs(struct srp_target_=
port *target)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KERNEL, DMA_TO_DEVICE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!target->tx_ring[i])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(&target->tx_ring[i]->lis=
t);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add(&target->tx_ring[i]->list, &ta=
rget->free_tx);

Why is INIT_LIST_HEAD() invoked above ? list_add() overwrites the prev
and next pointers that have been cleared by INIT_LIST_HEAD().

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
