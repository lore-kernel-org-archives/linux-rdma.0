From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 9/9] ib_srpt: Convert srpt_sq_size into per port configfs attribute
Date: Mon, 24 Oct 2011 20:32:37 +0200
Message-ID: <CAO+b5-qZHTEy25E0uR9yzAjAdvOH-k2_+ga4J_CUNTdUFyihZQ@mail.gmail.com>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org> <1319434422-15354-10-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319434422-15354-10-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> @@ -2144,11 +2140,11 @@ static int srpt_create_ch_ib(struct srpt_rdma=
_ch *ch)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> =A0 =A0 =A0 =A0ch->cq =3D ib_create_cq(sdev->device, srpt_completion,=
 NULL, ch,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ch->rq_size=
 + srpt_sq_size, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ch->rq_size=
 + sport->port_attrib.srp_sq_size, 0);
> =A0 =A0 =A0 =A0if (IS_ERR(ch->cq)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D PTR_ERR(ch->cq);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "failed to create CQ c=
qe=3D %d ret=3D %d\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ch->rq_size + srpt_sq_si=
ze, ret);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ch->rq_size + sport->por=
t_attrib.srp_sq_size, ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> @@ -2160,7 +2156,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_c=
h *ch)
> =A0 =A0 =A0 =A0qp_init->srq =3D sdev->srq;
> =A0 =A0 =A0 =A0qp_init->sq_sig_type =3D IB_SIGNAL_REQ_WR;
> =A0 =A0 =A0 =A0qp_init->qp_type =3D IB_QPT_RC;
> - =A0 =A0 =A0 qp_init->cap.max_send_wr =3D srpt_sq_size;
> + =A0 =A0 =A0 qp_init->cap.max_send_wr =3D sport->port_attrib.srp_sq_=
size;
> =A0 =A0 =A0 =A0qp_init->cap.max_send_sge =3D SRPT_DEF_SG_PER_WQE;

This patch introduces a race condition: if
sport->port_attrib.srp_sq_size is modified from user space while an
SRP login is ongoing then different values of that parameter can be
used in each of the above statements that read that parameter while
they all should use the same value.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
