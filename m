From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/rxe: Substitute ib to rdma in file names
Date: Thu, 14 Jul 2016 12:01:38 +0300
Message-ID: <CAG9sBKMQE=rEMBvNEf1PcAWtaTn-+RJWP8pzV45FTHwP5S2bXA@mail.gmail.com>
References: <1468486359-16035-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468486359-16035-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 14, 2016 at 11:52 AM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Change prefix of module name and public inclue file name from ib to
> rdma.
>
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  MAINTAINERS                           |   2 +-
>  drivers/infiniband/hw/Makefile        |   2 +-
>  drivers/infiniband/hw/rxe/Kconfig     |   2 +-
>  drivers/infiniband/hw/rxe/Makefile    |   4 +-
>  drivers/infiniband/hw/rxe/rxe_verbs.h |   4 +-
>  include/uapi/rdma/Kbuild              |   2 +-
>  include/uapi/rdma/ib_user_rxe.h       | 144 ----------------------------------
>  7 files changed, 8 insertions(+), 152 deletions(-)
>  delete mode 100644 include/uapi/rdma/ib_user_rxe.h

Doug,

Please ignore that. A new file (the one that replaces
include/uapi/rdma/ib_user_rxe.h is missing here.
I am sending another one right now

Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
