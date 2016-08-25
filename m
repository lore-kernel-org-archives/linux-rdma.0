From: Moni Shoua <monis@mellanox.com>
Subject: Re: [PATCH v05 61/72] include/uapi/rdma/rdma_user_rxe.h: include in.h
 and in6.h
Date: Thu, 25 Aug 2016 17:00:49 +0300
Message-ID: <CAG9sBKOtYKov3S3N1WS+D_71mgPV0Rh+StMHOtwcwE-HteDp9A@mail.gmail.com>
References: <1471890809-4383-1-git-send-email-mikko.rapeli@iki.fi> <1471890809-4383-62-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471890809-4383-62-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Moni Shoua <monis@mellanox.com>

On Mon, Aug 22, 2016 at 9:33 PM, Mikko Rapeli <mikko.rapeli@iki.fi> wrote:
> Fixes these userspace compilation errors when rdma_user_rxe.h is compiled
> alone:
>
> rdma/rdma_user_rxe.h:59:20: error: field =E2=80=98_sockaddr=E2=80=99 has =
incomplete type
>    struct sockaddr  _sockaddr;
>                     ^~~~~~~~~
> rdma/rdma_user_rxe.h:60:22: error: field =E2=80=98_sockaddr_in=E2=80=99 h=
as incomplete type
>    struct sockaddr_in _sockaddr_in;
>                       ^~~~~~~~~~~~
> rdma/rdma_user_rxe.h:61:23: error: field =E2=80=98_sockaddr_in6=E2=80=99 =
has incomplete type
>    struct sockaddr_in6 _sockaddr_in6;
>                        ^~~~~~~~~~~~~
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> ---
>  include/uapi/rdma/rdma_user_rxe.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_u=
ser_rxe.h
> index 1de99cf..ce6c929 100644
> --- a/include/uapi/rdma/rdma_user_rxe.h
> +++ b/include/uapi/rdma/rdma_user_rxe.h
> @@ -34,6 +34,8 @@
>  #define RDMA_USER_RXE_H
>
>  #include <linux/types.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
>
>  union rxe_gid {
>         __u8    raw[16];
> --
> 2.8.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
