From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 9/9] IB/core: extended command: move comp_mask to the
 extended header
Date: Mon, 14 Oct 2013 18:44:09 +0300
Message-ID: <525C1149.6000701@mellanox.com>
References: <cover.1381510045.git.ydroneaud@opteya.com> <40175eda10d670d098204da6aa4c327a0171ae5f.1381510045.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <40175eda10d670d098204da6aa4c327a0171ae5f.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/10/2013 8:57 PM, Yann Droneaud wrote:
> The unused field in the extended header is a perfect candidate
> to hold the command "comp_mask" (eg. bit field used to handle
> compatibility). This was suggested by Roland Dreier in a previous
> review[1].
>
> So this patch move comp_mask from create_flow/destroy_flow commands
> to the extended command header. Then comp_mask is passed as part
> of function parameters.
>
> [1]:
> http://marc.info/?i=CAL1RGDXJtrc849M6_XNZT5xO1+ybKtLWGq6yg6LhoSsKpsmk=
YA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
>
> Cc: Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
> Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Link: http://marc.info/?i=3Dver.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> Link: http://mid.gmane.org/cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> ---
>   drivers/infiniband/core/uverbs.h      |  3 ++-
>   drivers/infiniband/core/uverbs_cmd.c  | 15 ++++++++++-----
>   drivers/infiniband/core/uverbs_main.c |  6 ++++--
>   include/uapi/rdma/ib_user_verbs.h     |  6 +++---
>   4 files changed, 19 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/co=
re/uverbs.h
> index bdc842e..a12b516 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -245,7 +245,8 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
>   #define IB_UVERBS_DECLARE_EX_CMD(name)                         \
>          int ib_uverbs_ex_##name(struct ib_uverbs_file *file,    \
>                                  struct ib_udata *ucore,         \
> -                               struct ib_udata *uhw)
> +                               struct ib_udata *uhw,           \
> +                               __u32 comp_mask)
>
>   IB_UVERBS_DECLARE_EX_CMD(create_flow);
>   IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index e35877d..a8ecb3a 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2633,7 +2633,8 @@ static int kern_spec_to_ib_spec(struct ib_uverb=
s_flow_spec *kern_spec,
>
>   int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
>                               struct ib_udata *ucore,
> -                            struct ib_udata *uhw)
> +                            struct ib_udata *uhw,
> +                            __u32 comp_mask)
>   {
>          struct ib_uverbs_create_flow      cmd;
>          struct ib_uverbs_create_flow_resp resp;
> @@ -2647,6 +2648,9 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_f=
ile *file,
>          void *ib_spec;
>          int i;
>
> +       if (comp_mask)
> +               return -EINVAL;
> +
>          if (ucore->outlen < sizeof(resp))
>                  return -ENOSPC;
>
> @@ -2657,9 +2661,6 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_f=
ile *file,
>          ucore->inbuf +=3Dizeof(cmd);
>          ucore->inlen -=3Dizeof(cmd);
>
> -       if (cmd.comp_mask)
> -               return -EINVAL;
> -
>          if ((cmd.flow_attr.type =3DIB_FLOW_ATTR_SNIFFER &&
>               !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
>                  return -EPERM;
> @@ -2785,13 +2786,17 @@ err_free_attr:
>
>   int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
>                                struct ib_udata *ucore,
> -                             struct ib_udata *uhw)
> +                             struct ib_udata *uhw,
> +                             __u32 comp_mask)
>   {
>          struct ib_uverbs_destroy_flow   cmd;
>          struct ib_flow                  *flow_id;
>          struct ib_uobject               *uobj;
>          int                             ret;
>
> +       if (comp_mask)
> +               return -EINVAL;
> +
>          ret =3Db_copy_from_udata(&cmd, ucore, sizeof(cmd));
>          if (ret)
>                  return ret;
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniba=
nd/core/uverbs_main.c
> index 4f00654..a9687dd 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -119,7 +119,8 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uv=
erbs_file *file,
>
>   static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
>                                      struct ib_udata *ucore,
> -                                   struct ib_udata *uhw) =3D
> +                                   struct ib_udata *uhw,
> +                                   __u32 comp_mask) =3D
>          [IB_USER_VERBS_EX_CMD_CREATE_FLOW]      =3Db_uverbs_ex_creat=
e_flow,
>          [IB_USER_VERBS_EX_CMD_DESTROY_FLOW]     =3Db_uverbs_ex_destr=
oy_flow
>   };
> @@ -689,7 +690,8 @@ static ssize_t ib_uverbs_write(struct file *filp,=
 const char __user *buf,
>
>                  err =3Dverbs_ex_cmd_table[command](file,
>                                                     &ucore,
> -                                                  &uhw);
> +                                                  &uhw,
> +                                                  ex_hdr.comp_mask);
>
>                  if (err)
>                          return err;
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib=
_user_verbs.h
> index cbfdd4c..095a2bd 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -139,7 +139,7 @@ struct ib_uverbs_ex_cmd_hdr {
>          __u64 response;
>          __u16 provider_in_words;
>          __u16 provider_out_words;
> -       __u32 cmd_hdr_reserved;
> +       __u32 comp_mask;
>   };
>
>   struct ib_uverbs_get_context {
> @@ -783,8 +783,8 @@ struct ib_uverbs_flow_attr {
>   };
>
>   struct ib_uverbs_create_flow  {
> -       __u32 comp_mask;
>          __u32 qp_handle;
> +       __u32 reserved;
>          struct ib_uverbs_flow_attr flow_attr;
>   };
>
> @@ -794,8 +794,8 @@ struct ib_uverbs_create_flow_resp {
>   };
>
>   struct ib_uverbs_destroy_flow  {
> -       __u32 comp_mask;
>          __u32 flow_handle;
> +       __u32 reserved;
>   };
>
>   struct ib_uverbs_create_srq {
> --
> 1.8.3.1
>

I think that's a good idea to make the comp_mask field a part of our=20
infrastructure. But, I think we should consider making this symmetrical=
=2E

If we use the command's comp_mask as an input parameter, shouldn't we=20
use the response's comp_mask as an output parameter ?
What's about the provider's comp_mask ?

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
