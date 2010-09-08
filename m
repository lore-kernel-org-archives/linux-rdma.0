From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibmad/fields.c: Change all PortCounter names to match
 the Specification
Date: Wed, 8 Sep 2010 07:24:28 -0400
Message-ID: <AANLkTinc5MGM6YEkeLrWT_m81LFm-JCtef_M5sw7sBw=@mail.gmail.com>
References: <20100907193727.83c64672.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100907193727.83c64672.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 7, 2010 at 10:37 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Tue, 3 Aug 2010 10:40:56 -0700
> Subject: [PATCH] libibmad/fields.c: Change all PortCounter names to m=
atch the Specification
>
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
> =C2=A0libibmad/src/fields.c | =C2=A0 32 ++++++++++++++++-------------=
---
> =C2=A01 files changed, 16 insertions(+), 16 deletions(-)

A number of diag scripts need changing to go along with these field
name changes.

-- Hal

> diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
> index a5a510a..d992065 100644
> --- a/libibmad/src/fields.c
> +++ b/libibmad/src/fields.c
> @@ -246,24 +246,24 @@ static const ib_field_t ib_mad_f[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{BITSOFFS(8, 8), "PortSelect", mad_dump_ui=
nt},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{BITSOFFS(16, 16), "CounterSelect", mad_du=
mp_hex},
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(32, 16), "SymbolErrors", mad_dump_ui=
nt},
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(48, 8), "LinkRecovers", mad_dump_uin=
t},
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(56, 8), "LinkDowned", mad_dump_uint}=
,
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(64, 16), "RcvErrors", mad_dump_uint}=
,
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(80, 16), "RcvRemotePhysErrors", mad_=
dump_uint},
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(96, 16), "RcvSwRelayErrors", mad_dum=
p_uint},
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(112, 16), "XmtDiscards", mad_dump_ui=
nt},
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(128, 8), "XmtConstraintErrors", mad_=
dump_uint},
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(136, 8), "RcvConstraintErrors", mad_=
dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(32, 16), "SymbolErrorCounter", mad_d=
ump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(48, 8), "LinkErrorRecoveryCounter", =
mad_dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(56, 8), "LinkDownedCounter", mad_dum=
p_uint},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(64, 16), "PortRcvErrors", mad_dump_u=
int},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(80, 16), "PortRcvRemotePhysicalError=
s", mad_dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(96, 16), "PortRcvSwitchRelayErrors",=
 mad_dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(112, 16), "PortXmitDiscards", mad_du=
mp_uint},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(128, 8), "PortXmitConstraintErrors",=
 mad_dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(136, 8), "PortRcvConstraintErrors", =
mad_dump_uint},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{BITSOFFS(144, 8), "CounterSelect2", mad_d=
ump_hex},
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(152, 4), "LinkIntegrityErrors", mad_=
dump_uint},
> - =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(156, 4), "ExcBufOverrunErrors", mad_=
dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(152, 4), "LocalLinkIntegrityErrors",=
 mad_dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(156, 4), "ExcessiveBufferOverrunErro=
rs", mad_dump_uint},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{BITSOFFS(176, 16), "VL15Dropped", mad_dum=
p_uint},
> - =C2=A0 =C2=A0 =C2=A0 {192, 32, "XmtData", mad_dump_uint},
> - =C2=A0 =C2=A0 =C2=A0 {224, 32, "RcvData", mad_dump_uint},
> - =C2=A0 =C2=A0 =C2=A0 {256, 32, "XmtPkts", mad_dump_uint},
> - =C2=A0 =C2=A0 =C2=A0 {288, 32, "RcvPkts", mad_dump_uint},
> - =C2=A0 =C2=A0 =C2=A0 {320, 32, "XmtWait", mad_dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {192, 32, "PortXmitData", mad_dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {224, 32, "PortRcvData", mad_dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {256, 32, "PortXmitPkts", mad_dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {288, 32, "PortRcvPkts", mad_dump_uint},
> + =C2=A0 =C2=A0 =C2=A0 {320, 32, "PortXmitWait", mad_dump_uint},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{0, 0}, =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 /* IB_PC_LAST_F */
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> --
> 1.5.4.5
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
