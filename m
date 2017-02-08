From: Sl Sh <valyushash-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc] RDMA: Remove kernel private defines and reference
 to header from UAPI
Date: Wed, 8 Feb 2017 10:26:16 +0200
Message-ID: <CAA_ACVOr+z+qPh7HS4WZSUxp4xxf0HxsDHt+N7pcekOEZ15ZXA@mail.gmail.com>
References: <20170207174600.27218-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170207174600.27218-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Works for me.

Tested-by: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On Tue, Feb 7, 2017 at 7:46 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Remove references to private kernel header and defines from exported
> ib_user_verb.h file.
>
> The code snippet below is used to reproduce the issue:
>
>  #include <stdio.h>
>  #include <rdma/ib_user_verb.h>
>
>  int main(void)
>  {
>         printf("IB_USER_VERBS_ABI_VERSION =3D %d\n", IB_USER_VERBS_ABI_VE=
RSION);
>         return 0;
>  }
>
> It fails during compilation phase with an error:
> =E2=9E=9C  /tmp gcc main.c
> main.c:2:31: fatal error: rdma/ib_user_verb.h: No such file or directory
>  #include <rdma/ib_user_verb.h>
>                                ^
> compilation terminated.
>
> Fixes: 189aba99e700 ("IB/uverbs: Extend modify_qp and support packet paci=
ng")
> CC: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> CC: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reported-by: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  include/uapi/rdma/ib_user_verbs.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_use=
r_verbs.h
> index dfdfe4e92d31..c56f525b041d 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -37,7 +37,6 @@
>  #define IB_USER_VERBS_H
>
>  #include <linux/types.h>
> -#include <rdma/ib_verbs.h>
>
>  /*
>   * Increment this value if any changes that break userspace ABI
> @@ -548,11 +547,11 @@ enum {
>  };
>
>  enum {
> -       IB_USER_LEGACY_LAST_QP_ATTR_MASK =3D IB_QP_DEST_QPN
> +       IB_USER_LEGACY_LAST_QP_ATTR_MASK =3D 1ULL << 20,
>  };
>
>  enum {
> -       IB_USER_LAST_QP_ATTR_MASK =3D IB_QP_RATE_LIMIT
> +       IB_USER_LAST_QP_ATTR_MASK =3D 1ULL << 25,
>  };
>
>  struct ib_uverbs_ex_create_qp {
> --
> 2.11.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thank you in advance,

Slava Shwartsman
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
