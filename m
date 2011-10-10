From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/3] RDMA/nes: Support for Packed And Unaligned fpdus
Date: Mon, 10 Oct 2011 12:02:28 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904EC29E1D4@azsmsx506.amr.corp.intel.com>
References: <20110926013400.GA4132@FLATIF-MOBL4>
 <CAL1RGDVMBCsWnUv3w0y4bETcng4Oud3t33TM=3SR13Ck06pzjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVMBCsWnUv3w0y4bETcng4Oud3t33TM=3SR13Ck06pzjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks,

I will test it again to make sure.


=46aisal


> -----Original Message-----
> From: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org] On Behal=
f
> Of Roland Dreier
> Sent: Monday, October 10, 2011 1:05 PM
> To: Latif, Faisal
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 3/3] RDMA/nes: Support for Packed And Unaligned
> fpdus
>=20
> Applied, but...
>=20
>=20
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/nes/nes_mgt.c
>=20
> > +void nes_replenish_mgt_rq(struct nes_vnic_mgt *mgtvnic)
>=20
> Most of these functions are only used in nes_mgt.c and can be made
> static.  I fixed that up.
>=20
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 barrier();
>=20
> barrier() is only a compiler optimization barrier.  Does this need to
> be a full memory barrier to make sure that the CPU and NES see the
> same thing?  (ie wmb() or something?)
>=20
>=20
>=20
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32tmp =3D (fpdu_info->frags[1].frag_=
len << 16) |
> fpdu_info->frags[0].frag_len;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_wqe_32bit_value(cqp_wqe->wqe_word=
s,
> NES_NIC_SQ_WQE_LENGTH_2_1_IDX,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 cpu_to_le32(u32tmp));
>=20
> set_wqe_32bit_value does the cpu_to_le32() internally -- I assume thi=
s
> will swap twice on big-endian (which I'm sure you never tested).  I
> got rid of this superfluous call here.
>=20
> Please retest my for-next tree and make sure I didn't break anything
> in my cleanups.
>=20
>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
