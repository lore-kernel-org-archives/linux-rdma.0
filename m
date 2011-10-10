From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] RDMA/nes: Support for Packed And Unaligned fpdus
Date: Mon, 10 Oct 2011 11:05:27 -0700
Message-ID: <CAL1RGDVMBCsWnUv3w0y4bETcng4Oud3t33TM=3SR13Ck06pzjg@mail.gmail.com>
References: <20110926013400.GA4132@FLATIF-MOBL4>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110926013400.GA4132@FLATIF-MOBL4>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Applied, but...


> --- /dev/null
> +++ b/drivers/infiniband/hw/nes/nes_mgt.c

> +void nes_replenish_mgt_rq(struct nes_vnic_mgt *mgtvnic)

Most of these functions are only used in nes_mgt.c and can be made
static.  I fixed that up.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 barrier();

barrier() is only a compiler optimization barrier.  Does this need to
be a full memory barrier to make sure that the CPU and NES see the
same thing?  (ie wmb() or something?)



> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32tmp =3D (fpdu_info->frags[1].frag_le=
n << 16) | fpdu_info->frags[0].frag_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_wqe_32bit_value(cqp_wqe->wqe_words,=
 NES_NIC_SQ_WQE_LENGTH_2_1_IDX,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 cpu_to_le32(u32tmp));

set_wqe_32bit_value does the cpu_to_le32() internally -- I assume this
will swap twice on big-endian (which I'm sure you never tested).  I
got rid of this superfluous call here.

Please retest my for-next tree and make sure I didn't break anything
in my cleanups.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
