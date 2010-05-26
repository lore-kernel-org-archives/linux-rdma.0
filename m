From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ofa_kernel/util madeye.c
Date: Wed, 26 May 2010 10:46:35 -0400
Message-ID: <AANLkTikKroE3HGXAZtWgEEy6YojcKNtP6oWKbZEyt6iJ@mail.gmail.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D454@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D454-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 26, 2010 at 8:42 AM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> =
wrote:
> I'm resending this - I sent it yesterday, but it doesn't seem to have=
 appeared in the list.
>
> ----------
>
> This is a simple fix. Several of the attribute filters in ./drivers/i=
nfiniband/util/madeye.c don't switch the attribute id to host byte orde=
r before checking it.

AFAIR there was discussion on this but the work to push madeye
upstream was never done so it is just an EWG patch right now. If there
are no objections (there weren't when the discussion last occurred),
it could also be pushed upstream.

-- Hal

>
> Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/drivers/infiniband/util/madeye.c b/drivers/infiniband/ut=
il/madeye.c
> index 0cda06c..2c650a3 100644
> --- a/drivers/infiniband/util/madeye.c
> +++ b/drivers/infiniband/util/madeye.c
> @@ -401,7 +401,7 @@ static void snoop_smi_handler(struct ib_mad_agent=
 *mad_agent,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!smp && hdr->mgmt_class !=3D mgmt_clas=
s)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> - =C2=A0 =C2=A0 =C2=A0 if (attr_id && hdr->attr_id !=3D attr_id)
> + =C2=A0 =C2=A0 =C2=A0 if (attr_id && be16_to_cpu(hdr->attr_id) !=3D =
attr_id)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printk("Madeye:sent SMP\n");
> @@ -413,7 +413,7 @@ static void recv_smi_handler(struct ib_mad_agent =
*mad_agent, =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!smp && mad_recv_wc->recv_buf.mad->mad=
_hdr.mgmt_class !=3D mgmt_class)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> - =C2=A0 =C2=A0 =C2=A0 if (attr_id && mad_recv_wc->recv_buf.mad->mad_=
hdr.attr_id !=3D attr_id)
> + =C2=A0 =C2=A0 =C2=A0 if (attr_id && be16_to_cpu(mad_recv_wc->recv_b=
uf.mad->mad_hdr.attr_id)
> +!=3D attr_id)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printk("Madeye:recv SMP\n");
> @@ -446,7 +446,7 @@ static void snoop_gsi_handler(struct ib_mad_agent=
 *mad_agent,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!gmp && hdr->mgmt_class !=3D mgmt_clas=
s)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> - =C2=A0 =C2=A0 =C2=A0 if (attr_id && hdr->attr_id !=3D attr_id)
> + =C2=A0 =C2=A0 =C2=A0 if (attr_id && be16_to_cpu(hdr->attr_id) !=3D =
attr_id)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printk("Madeye:sent GMP\n");
> @@ -468,7 +468,7 @@ static void recv_gsi_handler(struct ib_mad_agent =
*mad_agent,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!gmp && hdr->mgmt_class !=3D mgmt_clas=
s)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> - =C2=A0 =C2=A0 =C2=A0 if (attr_id && mad_recv_wc->recv_buf.mad->mad_=
hdr.attr_id !=3D attr_id)
> + =C2=A0 =C2=A0 =C2=A0 if (attr_id && be16_to_cpu(mad_recv_wc->recv_b=
uf.mad->mad_hdr.attr_id)
> +!=3D attr_id)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printk("Madeye:recv GMP\n");
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
