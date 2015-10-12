From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Mon, 12 Oct 2015 12:26:06 +0300
Message-ID: <561B7CAE.3040505@dev.mellanox.co.il>
References: <1444633078-27166-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444633078-27166-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/12/2015 9:57 AM, Christoph Hellwig wrote:
> This patch gets rid of struct ib_device_attr and cleans up drivers nicely.
>
> It goes on top of my send_wr cleanups and the memory registration udpates
> from Sagi.
>
> Changes since V1:
>   - rebased on top of the Sagi's latest reg_api.6 branch
>

Christoph,

First go with this looks OK for mlx4. mlx5 needs the below incremental
patch to be folded in.

we need dev->ib_dev.max_pkeys set when get_port_caps() is called.

--
diff --git a/drivers/infiniband/hw/mlx5/main.c 
b/drivers/infiniband/hw/mlx5/main.c
index 67b979f..5b73322 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1321,6 +1321,10 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)

         dev->mdev = mdev;

+       err = mlx5_ib_init_device_flags(&dev->ib_dev);
+       if (err)
+               goto err_dealloc;
+
         err = get_port_caps(dev);
         if (err)
                 goto err_dealloc;
@@ -1433,10 +1437,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
         if (err)
                 goto err_rsrc;

-       err = mlx5_ib_init_device_flags(&dev->ib_dev);
-       if (err)
-               goto err_rsrc;
-
         err = ib_register_device(&dev->ib_dev, NULL);
         if (err)
                 goto err_odp;
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
