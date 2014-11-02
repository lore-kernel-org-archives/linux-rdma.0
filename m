From: Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Mon, 3 Nov 2014 06:06:45 +1000
Message-ID: <CAPM=9tx+Zau+2EhVouEAM0XKxKhgOpEHSUgWhBuWDC8vA7wvig@mail.gmail.com>
References: <1413499938-2378-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413499938-2378-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17 October 2014 08:52, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hi Linus,
>
> Please pull from
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.g=
it tags/rdma-for-linus
>
> ----------------------------------------------------------------
> Main set of InfiniBand/RDMA updates for 3.18 merge window:
>
>  - Large set of iSER initiator improvements
>  - Hardware driver fixes for cxgb4, mlx5 and ocrdma
>  - Small fixes to core midlayer
>

building on 32-bit x86.

 CC [M]  drivers/infiniband/ulp/iser/iser_verbs.o
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_v=
erbs.c:
In function =E2=80=98iser_handle_comp_error=E2=80=99:
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_v=
erbs.c:1171:33:
warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]
  if (is_iser_tx_desc(iser_conn, (void *)wc->wr_id)) {
                                 ^
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_v=
erbs.c:1172:31:
warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]
   struct iser_tx_desc *desc =3D (struct iser_tx_desc *)wc->wr_id;
                               ^
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_v=
erbs.c:
In function =E2=80=98iser_handle_wc=E2=80=99:
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_v=
erbs.c:1198:14:
warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]
    rx_desc =3D (struct iser_rx_desc *)wc->wr_id;
              ^
/home/airlied/devel/kernel/linux-2.6/drivers/infiniband/ulp/iser/iser_v=
erbs.c:1203:14:
warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]
    tx_desc =3D (struct iser_tx_desc *)wc->wr_id;
              ^

Not sure anyone would ever want to run this code on 32-bit boxes, but
I'm a bit worried if wr_id is a 64-bit value, and we encode it into a
32-bit pointer, you'd always lose the top 32-bits.

Dave.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
