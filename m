From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Configure VF trust mode in 4.9
Date: Tue, 18 Apr 2017 11:56:54 -0600
Message-ID: <CAANLjFoty0qrywFVSWC-LEbJw5LVvM8iN16t9nZaG+eDefA21A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We have run across how to set the VFs on a ConnectX-4 adapter with
OFED 3.3 [0]. We are trying to do this without OFED in the 4.9.21
kernel. From what I can tell, the ability to add the appropriate rules
into the on-card switch were added into 4.9-rc1
(drivers/net/ethernet/mellanox/mlx5/core/eswitch.c). I just can't
figure out how to enable the settings as the /sys paths don't exist
and the `ip` command doesn't take the trust mode. Can someone give us
a push in the right direction?

[0] https://community.mellanox.com/docs/DOC-2473

Thanks,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
