From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Mon, 20 Oct 2014 11:01:14 +0300
Message-ID: <CAJ3xEMjbYL9M12UagW52ELdLkHZFnWbKDk0CXZfo_Sf82tjugA@mail.gmail.com>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
	<543CD5D6.1020506@mellanox.com>
	<44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>
	<5443DBCA.4000002@dev.mellanox.co.il>
	<ecfd3441-253c-47bf-b2cb-030b2a00f689@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ecfd3441-253c-47bf-b2cb-030b2a00f689-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minh Duc Tran <MinhDuc.Tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 20, 2014 at 8:36 AM, Minh Duc Tran
<MinhDuc.Tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> > ---
a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -114,6 +114,9 @@ static int iser_create_device_ib_res(struct iser_device *device)
>         if (IS_ERR(device->pd))
>                 goto pd_err;
>
> +       max_cqe = (dev_attr->max_cqe < ISER_MAX_CQ_LEN) ?
> +                  dev_attr->max_cqe : ISER_MAX_CQ_LEN;
> +

If I was the ocrdma maintainer I would say load and clear: NO, please.

Your current offering supports 32 CQs per device, and this means that
on 32 core node you will be able to run only iSER, no other ULP.

Generally, this approach is wrong, causing bad user experience and we
will not do that.




>         for (i = 0; i < device->comps_used; i++) {
>                 struct iser_comp *comp = &device->comps[i];
>
> @@ -122,7 +125,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
>                                         iser_cq_callback,
>                                         iser_cq_event_callback,
>                                         (void *)comp,
> -                                       ISER_MAX_CQ_LEN, i);
> +                                       max_cqe, i);
>                 if (IS_ERR(comp->cq)) {
>                         comp->cq = NULL;
>                         goto cq_err;
> @@ -426,6 +429,7 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
>  static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
>  {
>         struct iser_device      *device;
> +       struct ib_device_attr *dev_attr;
>         struct ib_qp_init_attr  init_attr;
>         int                     ret = -ENOMEM;
>         int index, min_index = 0;
> @@ -433,6 +437,7 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
>         BUG_ON(ib_conn->device == NULL);
>
>         device = ib_conn->device;
> +       dev_attr = &device->dev_attr;
>
>         memset(&init_attr, 0, sizeof init_attr);
>
> @@ -461,7 +466,9 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
>                 init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS + 1;
>                 init_attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
>         } else {
> -               init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS + 1;
> +               init_attr.cap.max_send_wr  =
> +                       (dev_attr->max_qp_wr < ISER_QP_MAX_REQ_DTOS) ?
> +                        dev_attr->max_qp_wr : ISER_QP_MAX_REQ_DTOS;
>         }
>
>         ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
