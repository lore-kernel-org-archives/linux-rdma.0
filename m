From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] infiniband: core: fix information leak to userland
Date: Fri, 12 Nov 2010 10:28:55 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B85224A6@orsmsx501.amr.corp.intel.com>
References: <1289054481-18145-1-git-send-email-segooon@gmail.com>
 <ada39r8ohiz.fsf@cisco.com> <20101112180844.GA11533@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101112180844.GA11533@albatros>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Kulikov <segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/ucm.c
> b/drivers/infiniband/core/ucm.c
> index 08f948d..f7256f3 100644
> --- a/drivers/infiniband/core/ucm.c
> +++ b/drivers/infiniband/core/ucm.c
> @@ -629,6 +629,7 @@ static ssize_t ib_ucm_init_qp_attr(struct ib_ucm_file
> *file,
>         if (result)
>                 goto out;
> 
> +       resp.qp_state = 0;
>         ib_copy_qp_attr_to_user(&resp, &qp_attr);

I believe we want ib_copy_qp_attr_to_user() to assign	resp->qp_state = qp_attr->qp_state

> diff --git a/drivers/infiniband/core/ucma.c
> b/drivers/infiniband/core/ucma.c
> index ca12acf..07fd247 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -842,6 +842,7 @@ static ssize_t ucma_init_qp_attr(struct ucma_file
> *file,
>         if (ret)
>                 goto out;
> 
> +       resp.qp_state = 0;
>         ib_copy_qp_attr_to_user(&resp, &qp_attr);
>         if (copy_to_user((void __user *)(unsigned long)cmd.response,
>                          &resp, sizeof(resp)))
> diff --git a/drivers/infiniband/core/uverbs_marshall.c
> b/drivers/infiniband/core/uverbs_marshall.c
> index 5440da0..cceaf33 100644
> --- a/drivers/infiniband/core/uverbs_marshall.c
> +++ b/drivers/infiniband/core/uverbs_marshall.c
> @@ -35,6 +35,7 @@
>  void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst, struct
> ib_ah_attr *src)
>  {
> +       memset(&dst->grh, 0, sizeof(dst->grh));

We only need to set dst->grh.reserved = 0.  The other fields are assigned. 

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
