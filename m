From: Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Subject: Re: [PATCH 17/19 V4] mlx4: Using mcg tables for Ethernet Unicast steering.
Date: Mon, 13 Dec 2010 18:33:59 +0200
Message-ID: <AANLkTimqi1LUGbcYPWJK133cG_M7u-fA=v4jLLhQHUib@mail.gmail.com>
References: <4C11381B.90101@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C11381B.90101-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

    +       if (dev->caps.vep_uc_steering) {

    +               err = mlx4_uc_steer_add(dev, port, mac, qpn, 1);
    +               if (!err) {
    +                       entry = kmalloc(sizeof *entry, GFP_KERNEL);
    +                       if (!entry) {
    +                               mlx4_uc_steer_release(dev, port,
mac, *qpn, 1);
    +                               return -ENOMEM;
    +                       }
    +                       entry->mac = mac;
    +                       err = radix_tree_insert(&info->mac_tree,
*qpn, entry);
    +                       if (err)

    +                               mlx4_uc_steer_release(dev, port,
mac, *qpn, 1);


Don't you need to free  prevously allocated entry here if insert fail?

    +               }
    +               return err;
    +       }
    +
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
