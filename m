From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-core v2 0/9] Broadcom User Space RoCE Driver
Date: Wed, 22 Feb 2017 08:52:17 +0530
Message-ID: <CANjDDBi7bvYMvnjgsdSXzj6ot2wJS+w1nRCp-26TgEEpE38vfg@mail.gmail.com>
References: <1487432638-19607-1-git-send-email-devesh.sharma@broadcom.com> <20170221195053.GG13138@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170221195053.GG13138-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 22, 2017 at 1:20 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>
> On Sat, Feb 18, 2017 at 10:43:49AM -0500, Devesh Sharma wrote:
> > This series introduces the user space RoCE driver for the Broadcom
> > NetXtreme-E 10/25/40/50 RDMA Ethernet Controller. This driver
> > is dependent on the bnxt_re driver posted earlier to linux-rdma
> > community and is under reveiw.
> >
> > This patch series is based on the latest master of rdma-core
> > repository hosted at https://github.com/linux-rdma/rdma-core.git
> >
> > The GIT for this library is hosted at following URL on github
> > https://github.com/dsharma283/bnxtre-rdma-core.git
> > branch: bnxtre-v2
> >
> > Please review and give your valuable feedback for the betterment.
> >
> > v1->v2
>
> It still doesn't compile, please make sure everything is travis clean
> before submitting..

I could not find travis package, thus could not gave it try before
submitting v2. I will give it a shot again.

>
> $ buildlib/cbuild pkg travis
> [59/172] Building C object providers/hns/CMakeFiles/hns-rdmav2.dir/hns_ro=
ce_u_hw_v1.c.o
> FAILED: /usr/bin/gcc-6  -Dbnxt_re_rdmav2_EXPORTS -Werror -m32  -std=3Dgnu=
11 -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototyp=
es -Wmissing-declarations -Wwrite-strings -Wformat=3D2 -Wshadow -Wstrict-pr=
ototypes -Wold-style-definition -Wredundant-decls -O2 -g  -fPIC -Iinclude -=
MMD -MT providers/bnxt_re/CMakeFiles/bnxt_re-rdmav2.dir/verbs.c.o -MF "prov=
iders/bnxt_re/CMakeFiles/bnxt_re-rdmav2.dir/verbs.c.o.d" -o providers/bnxt_=
re/CMakeFiles/bnxt_re-rdmav2.dir/verbs.c.o   -c ../providers/bnxt_re/verbs.=
c
> ../providers/bnxt_re/verbs.c: In function 'bnxt_re_reg_mr':
> ../providers/bnxt_re/verbs.c:143:38: error: cast from pointer to integer =
of different size [-Werror=3Dpointer-to-int-cast]
>   if (ibv_cmd_reg_mr(ibvpd, sva, len, (uint64_t)sva, access, &mr->ibvmr,
>                                       ^
> ../providers/bnxt_re/verbs.c: In function 'bnxt_re_create_cq':
> ../providers/bnxt_re/verbs.c:191:14: error: cast from pointer to integer =
of different size [-Werror=3Dpointer-to-int-cast]
>   cmd.cq_va =3D (uint64_t)cq->cqq.va;
>               ^
> ../providers/bnxt_re/verbs.c:192:18: error: cast from pointer to integer =
of different size [-Werror=3Dpointer-to-int-cast]
>   cmd.cq_handle =3D (uint64_t)cq;
>                   ^
> ../providers/bnxt_re/verbs.c: In function 'bnxt_re_poll_one':
> ../providers/bnxt_re/verbs.c:512:9: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
>     qp =3D (struct bnxt_re_qp *)scqe->qp_handle;
>          ^
> ../providers/bnxt_re/verbs.c:521:9: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
>     qp =3D (struct bnxt_re_qp *)rcqe->qp_handle;
>          ^
> ../providers/bnxt_re/verbs.c:531:9: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
>     qp =3D (struct bnxt_re_qp *)scqe->qp_handle;
>          ^
> ../providers/bnxt_re/verbs.c: In function 'bnxt_re_cleanup_cq':
> ../providers/bnxt_re/verbs.c:689:27: error: cast from pointer to integer =
of different size [-Werror=3Dpointer-to-int-cast]
>     if (scqe->qp_handle =3D=3D (uint64_t)qp)
>                            ^
> ../providers/bnxt_re/verbs.c:693:27: error: cast from pointer to integer =
of different size [-Werror=3Dpointer-to-int-cast]
>     if (rcqe->qp_handle =3D=3D (uint64_t)qp)
>                            ^
> ../providers/bnxt_re/verbs.c: In function 'bnxt_re_create_qp':
> ../providers/bnxt_re/verbs.c:876:14: error: cast from pointer to integer =
of different size [-Werror=3Dpointer-to-int-cast]
>   req.qpsva =3D (uint64_t)qp->sqq->va;
>               ^
> ../providers/bnxt_re/verbs.c:877:24: error: cast from pointer to integer =
of different size [-Werror=3Dpointer-to-int-cast]
>   req.qprva =3D qp->rqq ? (uint64_t)qp->rqq->va : 0;
>                         ^
> ../providers/bnxt_re/verbs.c:878:18: error: cast from pointer to integer =
of different size [-Werror=3Dpointer-to-int-cast]
>   req.qp_handle =3D (uint64_t)qp;
>                   ^
> ../providers/bnxt_re/verbs.c: In function 'bnxt_re_build_sge':
> ../providers/bnxt_re/verbs.c:1014:16: error: cast to pointer from integer=
 of different size [-Werror=3Dint-to-pointer-cast]
>     memcpy(dst, (void *)sg_list[indx].addr,
>                 ^
> ../providers/bnxt_re/verbs.c: In function 'bnxt_re_create_srq':
> ../providers/bnxt_re/verbs.c:1412:14: error: cast from pointer to integer=
 of different size [-Werror=3Dpointer-to-int-cast]
>   cmd.srqva =3D (uint64_t)srq->srqq->va;
>               ^
> ../providers/bnxt_re/verbs.c:1413:19: error: cast from pointer to integer=
 of different size [-Werror=3Dpointer-to-int-cast]
>   cmd.srq_handle =3D (uint64_t)srq;
>                    ^
>
>
> Hum, you might want to put the wmb() ino bnxt_re_ring_db:
>
>                 bnxt_re_incr_tail(sq);
>                 wr =3D wr->next;
>                 wmb(); /* write barrier */

[DS]: That is correct, I was probably waiting for this comment before
I move it..will fold in v3

>
>                 bnxt_re_ring_sq_db(qp);
>
> More likely to be universally correct that way.
>
> There is only one rmb() in this driver and it seems in a wonky
> place. There is no reason to have a barrier after a kernel syscall, if
> a barrier is needed there it belongs in there kernel code.
>
[DS}: Will remove it.

> The rmb() is missing after calls to bnxt_re_is_cqe_valid() it looks
> like?

[DS]: true, its missing. I will correct it.

>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
