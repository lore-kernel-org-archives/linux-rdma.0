From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Potential NULL pointer dereference in drivers/infiniband/core
Date: Tue, 21 Feb 2017 19:05:18 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0E99ED@ORSMSX109.amr.corp.intel.com>
References: <003d01d28c09$46d1e200$d475a600$@cs.utah.edu>
 <1828884A29C6694DAF28B7E6B8A82373AB0E99BB@ORSMSX109.amr.corp.intel.com>
 <037c01d28c74$81f7ee90$85e7cbb0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <037c01d28c74$81f7ee90$85e7cbb0$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Shaobo' <shaobo-sDh8Nw2yj/+Vc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/cma.c
> b/drivers/infiniband/core/cma.c
> index 3e70a9c..c377afc 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -3583,6 +3583,9 @@ static int cma_accept_iw(struct rdma_id_private
> *id_priv,
>         struct iw_cm_conn_param iw_param;
>         int ret;
> 
> +       if (!conn_param)
> +               return -EINVAL;
> +
>         ret = cma_modify_qp_rtr(id_priv, conn_param);
>         if (ret)
>                 return ret;

Can you re-submit as a formal patch?  Feel free to include Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This should go into stable.  Thanks!  And thanks Shaobo!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
