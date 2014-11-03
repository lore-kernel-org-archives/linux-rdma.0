From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Mon, 3 Nov 2014 09:15:39 +0200
Message-ID: <20141103071539.GD742@mtldesk30>
References: <1413499938-2378-1-git-send-email-roland@kernel.org>
 <CAPM=9tx+Zau+2EhVouEAM0XKxKhgOpEHSUgWhBuWDC8vA7wvig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPM=9tx+Zau+2EhVouEAM0XKxKhgOpEHSUgWhBuWDC8vA7wvig@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Airlie <airlied@gmail.com>
Cc: Roland Dreier <roland@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 03, 2014 at 06:06:45AM +1000, Dave Airlie wrote:
> On 17 October 2014 08:52, Roland Dreier <roland@kernel.org> wrote:
> > Hi Linus,
> >
> > Please pull from
> >
> >     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband=
=2Egit tags/rdma-for-linus
> >
> > ----------------------------------------------------------------
> > Main set of InfiniBand/RDMA updates for 3.18 merge window:
> >
> >  - Large set of iSER initiator improvements
> >  - Hardware driver fixes for cxgb4, mlx5 and ocrdma
> >  - Small fixes to core midlayer
> >
>=20
> building on 32-bit x86.
>=20
>  CC [M]  drivers/infiniband/ulp/iser/iser_verbs.o
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser=
_verbs.c:
> In function =E2=80=98iser_handle_comp_error=E2=80=99:
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser=
_verbs.c:1171:33:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>   if (is_iser_tx_desc(iser_conn, (void *)wc->wr_id)) {
>                                  ^
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser=
_verbs.c:1172:31:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>    struct iser_tx_desc *desc =3D (struct iser_tx_desc *)wc->wr_id;
>                                ^
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser=
_verbs.c:
> In function =E2=80=98iser_handle_wc=E2=80=99:
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser=
_verbs.c:1198:14:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>     rx_desc =3D (struct iser_rx_desc *)wc->wr_id;
>               ^
> /home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser=
_verbs.c:1203:14:
> warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
>     tx_desc =3D (struct iser_tx_desc *)wc->wr_id;
>               ^
>=20
> Not sure anyone would ever want to run this code on 32-bit boxes, but
> I'm a bit worried if wr_id is a 64-bit value, and we encode it into a
> 32-bit pointer, you'd always lose the top 32-bits.
>=20
On 32 bit systems your pointer is 32 bits as well so assigning to u64
and casting back to a pointer you don't loose anything. Maybe casting
from u64 to a pointer should go through casting to uintptr_t to avoid
warnings.
