From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-rc v1] IB/core, opa_vnic, hfi1, mlx5: Properly free
 rdma_netdev
Date: Wed, 5 Jul 2017 14:52:02 -0700
Message-ID: <20170705215200.GA85407@knc-06.sc.intel.com>
References: <8e959601996dc645f4ed7004482a1667c27deb39.1499289360.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8e959601996dc645f4ed7004482a1667c27deb39.1499289360.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Doug for updating the patch with the fix.

>@@ -3550,16 +3555,19 @@ mlx5_ib_alloc_rdma_netdev(struct ib_device *hca,
> 			  unsigned char name_assign_type,
> 			  void (*setup)(struct net_device *))
> {
>+	struct net_device *netdev;
>+	struct rdma_netdev *rn;
>+
> 	if (type != RDMA_NETDEV_IPOIB)
> 		return ERR_PTR(-EOPNOTSUPP);
>
>-	return mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
>-				      name, setup);
>-}
>-
>-static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
>-{
>-	return mlx5_rdma_netdev_free(netdev);
>+	netdev = mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
>+					name, setup);
>+	if (likely(!IS_ERR_OR_NULL(netdev))) {
>+		rn = netdev_priv(netdev);
>+		rn->free_rdma_netdev = mlx5_ib_free_rdma_netdev;
>+	}

Looks like mlx5_rdma_netdev_alloc() always return NULL in case of error, hence 
null check should have been suffecient. But the above check will also do, I am 
fine with this change.

Niranjana
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
