From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: iser-target: Add iSCSI Extensions for RDMA (iSER) target driver
Date: Thu, 7 Jan 2016 17:22:28 +0200
Message-ID: <568E82B4.4030909@dev.mellanox.co.il>
References: <20160104210732.GA8675@mwanda>
 <1452104665.26125.22.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452104665.26125.22.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.
> index 91eb22c..8954e12 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -356,7 +356,7 @@ isert_create_device_ib_res(struct isert_device *device)
>          dev_attr = &device->dev_attr;
>          ret = isert_query_device(device->ib_device, dev_attr);
>          if (ret)
> -               return ret;
> +               goto out;
>
>          /* asign function handlers */
>          if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
> @@ -372,7 +372,7 @@ isert_create_device_ib_res(struct isert_device *device)
>
>          ret = isert_alloc_comps(device, dev_attr);
>          if (ret)
> -               return ret;
> +               goto out;
>
>          device->pd = ib_alloc_pd(device->ib_device);
>          if (IS_ERR(device->pd)) {
> @@ -390,6 +390,9 @@ isert_create_device_ib_res(struct isert_device *device)
>
>   out_cq:
>          isert_free_comps(device);
> +out:
> +       if (ret > 0)
> +               ret = -EINVAL;
>          return ret;
>   }
>
> --

Looks fine,

Acked-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks Nic, and thanks Dan for reporting!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
