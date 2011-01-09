From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 3/8] IB/srp: allow lockless work posting
Date: Sun, 9 Jan 2011 16:59:00 +0100
Message-ID: <AANLkTinExFSLHAo97S0Q8tbfUb5Lc5h06kHXyyzj-2Cj@mail.gmail.com>
References: <1294259716-30706-1-git-send-email-dillowda@ornl.gov> <1294259716-30706-4-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294259716-30706-4-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 5, 2011 at 9:35 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
>
> Only one CPU at a time will own an RX IU, so using the address of the=
 IU
> as the work request cookie allows us to avoid taking a lock. We can
> similarly prepare the TX path for lockless posting by moving the free=
 TX
> IUs to a list. This also removes the requirement that the queue sizes=
 be
> a power of 2.
>
> [ ... ]
> @@ -601,9 +601,9 @@ static int srp_reconnect_target(struct srp_target=
_port *target)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0srp_reset_req(target, req);
> =A0 =A0 =A0 =A0spin_unlock_irq(target->scsi_host->host_lock);
>
> - =A0 =A0 =A0 target->rx_head =A0=3D 0;
> - =A0 =A0 =A0 target->tx_head =A0=3D 0;
> - =A0 =A0 =A0 target->tx_tail =A0=3D 0;
> + =A0 =A0 =A0 list_del_init(&target->free_tx);
> + =A0 =A0 =A0 for (i =3D 0; i < SRP_SQ_SIZE; ++i)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move(&target->tx_ring[i]->list, &t=
arget->free_tx);
>
> =A0 =A0 =A0 =A0target->qp_in_error =3D 0;
> =A0 =A0 =A0 =A0ret =3D srp_connect_target(target);

Hello Dave,

Sorry that I hadn't noticed this before: invoking list_del_init() on
&target->free_tx seems strange to me since &target->free_tx is a list
head and not a list element. While list_del_init() will probably work
fine here, using INIT_LIST_HEAD() here seems more appropriate to me.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
