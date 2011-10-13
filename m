From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: Unblock reads on comp_channel
Date: Thu, 13 Oct 2011 09:01:49 -0700
Message-ID: <CAL1RGDU9Ka7-sGVnCnobgQjoh7p2bsXbSLp-Fnn6aA1Q9of36w@mail.gmail.com>
References: <1318494090-9996-1-git-send-email-kumaras@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318494090-9996-1-git-send-email-kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Would this generate a completion event even if no completion entries ar=
e queued?

Maybe I'm misunderstanding, but this sounds like a bandaid for broken
applications,
and a bandaid that other hardware drivers won't implement.

On Thu, Oct 13, 2011 at 1:21 AM, Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wr=
ote:
> At the time when peer closes connection, iw_cxgb4 will not
> send a cq event if ibqp.uobject exists. In that case, its possible
> for user application to get blocked in ibv_get_cq_event.
>
> To resolve this, call the cq's comp_handler to unblock any read
> from ibv_get_cq_event.
>
> Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
> =A0drivers/infiniband/hw/cxgb4/qp.c | =A0 =A06 +++++-
> =A01 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw=
/cxgb4/qp.c
> index ec3ce67..b59b56c 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -970,8 +970,12 @@ static void flush_qp(struct c4iw_qp *qhp)
> =A0 =A0 =A0 =A0if (qhp->ibqp.uobject) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t4_set_wq_in_error(&qhp->wq);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t4_set_cq_in_error(&rchp->cq);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (schp !=3D rchp)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (*rchp->ibcq.comp_handler)(&rchp->ibcq,=
 rchp->ibcq.cq_context);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (schp !=3D rchp) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t4_set_cq_in_error(&sc=
hp->cq);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (*schp->ibcq.comp_handl=
er)(&schp->ibcq,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 schp->ibcq.cq_context);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0__flush_qp(qhp, rchp, schp);
> --
> 1.7.1
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
