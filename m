From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH v3 37/37] IB/rxe, IB/rdmavt: Use dma_virt_ops instead of
 duplicating it
Date: Thu, 26 Jan 2017 21:00:53 +0000
Message-ID: <D4AFCD7C.A02D%Andrew.Boyer@emc.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
 <20170120210437.26389-38-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-38-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <8814F991E9E29046A6C12C7275973F4F-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 1/20/17, 4:04 PM, "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

>Make the rxe and rdmavt drivers use dma_virt_ops. Update the
>comments that refer to the source files removed by this patch.
>Remove struct ib_dma_mapping_ops. Remove ib_device.dma_ops.
>
>Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>Cc: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>---
> drivers/infiniband/sw/rdmavt/Kconfig  |   1 +
> drivers/infiniband/sw/rdmavt/Makefile |   2 +-
> drivers/infiniband/sw/rdmavt/dma.c    | 198
>----------------------------------
> drivers/infiniband/sw/rdmavt/dma.h    |  53 ---------
> drivers/infiniband/sw/rdmavt/mr.c     |   8 +-
> drivers/infiniband/sw/rdmavt/vt.c     |   4 +-
> drivers/infiniband/sw/rdmavt/vt.h     |   1 -
> drivers/infiniband/sw/rxe/Kconfig     |   1 +
> drivers/infiniband/sw/rxe/Makefile    |   1 -
> drivers/infiniband/sw/rxe/rxe_dma.c   | 183
>-------------------------------
> drivers/infiniband/sw/rxe/rxe_loc.h   |   2 -
> drivers/infiniband/sw/rxe/rxe_verbs.c |   3 +-
> include/rdma/ib_verbs.h               | 103 ++----------------
> 13 files changed, 18 insertions(+), 542 deletions(-)
> delete mode 100644 drivers/infiniband/sw/rdmavt/dma.c
> delete mode 100644 drivers/infiniband/sw/rdmavt/dma.h
> delete mode 100644 drivers/infiniband/sw/rxe/rxe_dma.c

For the RXE/ib_verbs portions -
Reviewed-By: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
