From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] rdma_cm: avoid assigning an IS_ERR value to cm id pointer
 in CMA id object
Date: Mon, 18 Jul 2011 09:39:44 -0700
Message-ID: <CAL1RGDWn_wqK3-0NM4NG1=wHw9_Q-2TT2goB_H_3RtyPEdS7aQ@mail.gmail.com>
References: <201107141058.29879.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237302E14C@ORSMSX101.amr.corp.intel.com>
 <201107171346.48065.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237302E6B9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302E6B9-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 18, 2011 at 9:35 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> - =A0 =A0 if (ret && !IS_ERR(id_priv->cm_id.ib)) {
>> + =A0 =A0 if (ret && !IS_ERR(id)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ib_destroy_cm_id(id_priv->cm_id.ib);
>
> I would change the above line to ib_destroy_cm_id(id) to align the de=
stroy call with the if statement.

OK, I'll grab this and make that suggested change as I merge it... no
need to resend.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
