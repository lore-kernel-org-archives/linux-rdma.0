From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 06/17] IB/core: Add support for extended query device caps
Date: Tue, 9 Dec 2014 13:43:30 -0800
Message-ID: <CAL1RGDXsYmWD2_ncMmRrMgAGn1bBaL9tNQ2mAYDG-kySF4037A@mail.gmail.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com> <1415723783-2138-7-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415723783-2138-7-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I was getting ready to apply the ODP series, but then I noticed:

On Tue, Nov 11, 2014 at 8:36 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index 71ab83fde472..974025028790 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -122,7 +122,8 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
>                                     struct ib_udata *ucore,
>                                     struct ib_udata *uhw) = {
>         [IB_USER_VERBS_EX_CMD_CREATE_FLOW]      = ib_uverbs_ex_create_flow,
> -       [IB_USER_VERBS_EX_CMD_DESTROY_FLOW]     = ib_uverbs_ex_destroy_flow
> +       [IB_USER_VERBS_EX_CMD_DESTROY_FLOW]     = ib_uverbs_ex_destroy_flow,
> +       [IB_USER_VERBS_EX_CMD_QUERY_DEVICE]     = ib_uverbs_ex_query_device
>  };
>
>  static void ib_uverbs_add_one(struct ib_device *device);

> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> index 26daf55ff76e..ed8c3d9da42c 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -90,8 +90,9 @@ enum {
>  };
>
>  enum {
> +       IB_USER_VERBS_EX_CMD_QUERY_DEVICE = IB_USER_VERBS_CMD_QUERY_DEVICE,
>         IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
> -       IB_USER_VERBS_EX_CMD_DESTROY_FLOW
> +       IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
>  };

And this makes no sense to me.  I thought the whole point of "EX"
commands was to add then after IB_USER_VERBS_CMD_THRESHOLD.

In this case, if you make IB_USER_VERBS_EX_CMD_QUERY_DEVICE =
IB_USER_VERBS_CMD_QUERY_DEVICE then doesn't the entry in
uverbs_cmd_table[] for normal query device get overwritten with
ib_uverbs_ex_query_device()??

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
