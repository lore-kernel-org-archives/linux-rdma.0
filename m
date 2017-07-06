From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/mlx5: Respect mlx5_core reserved GIDs
Date: Thu, 6 Jul 2017 12:39:24 +0300
Message-ID: <20170706093923.4azhres5ymy4vefp@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ilant-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Ilan Tayari,

This is a semi-automatic email about new static checker warnings.

The patch 095b0927f0ce: "IB/mlx5: Respect mlx5_core reserved GIDs"
from May 14, 2017, leads to the following Smatch complaint:

drivers/infiniband/hw/mlx5/main.c:327 set_roce_addr()
	 error: we previously assumed 'gid' could be null (see line 300)

drivers/infiniband/hw/mlx5/main.c
   299	
   300		if (gid) {
                    ^^^
Before we used to return early if gid was NULL.

   301			gid_type = attr->gid_type;
   302			ether_addr_copy(mac, attr->ndev->dev_addr);
   303	
   304			if (is_vlan_dev(attr->ndev)) {
   305				vlan = true;
   306				vlan_id = vlan_dev_vlan_id(attr->ndev);
   307			}
   308		}
   309	
   310		switch (gid_type) {
   311		case IB_GID_TYPE_IB:
   312			roce_version = MLX5_ROCE_VERSION_1;
   313			break;
   314		case IB_GID_TYPE_ROCE_UDP_ENCAP:
   315			roce_version = MLX5_ROCE_VERSION_2;
   316			if (ipv6_addr_v4mapped((void *)gid))
   317				roce_l3_type = MLX5_ROCE_L3_TYPE_IPV4;
   318			else
   319				roce_l3_type = MLX5_ROCE_L3_TYPE_IPV6;
   320			break;
   321	
   322		default:
   323			mlx5_ib_warn(dev, "Unexpected GID type %u\n", gid_type);
   324		}
   325	
   326		return mlx5_core_roce_gid_set(dev->mdev, index, roce_version,
   327					      roce_l3_type, gid->raw, mac, vlan,
                                                            ^^^^^^^^
Dereference.

   328					      vlan_id);
   329	}

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
