From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [pull request][for-next V2 00/11] Mellanox, mlx5 E-Switch
 updates 2017-12-19
Date: Wed, 27 Dec 2017 17:01:22 -0500 (EST)
Message-ID: <20171227.170122.256080933244367774.davem@davemloft.net>
References: <20171224134547.600-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224134547.600-1-saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 24 Dec 2017 15:45:36 +0200

> Hi Dave and Doug,
> 
> ==============
> This series includes updates for mlx5 E-Switch infrastructures,
> to be merged into net-next and rdma-next trees.
> 
> Mark's patches provide E-Switch refactoring that generalize the mlx5
> E-Switch vf representors interfaces and data structures. The serious is
> mainly focused on moving ethernet (netdev) specific representors logic out
> of E-Switch (eswitch.c) into mlx5e representor module (en_rep.c), which
> provides better separation and allows future support for other types of vf
> representors (e.g. RDMA).
> 
> Gal's patches at the end of this serious, provide a simple syntax fix and
> two other patches that handles vport ingress/egress ACL steering name
> spaces to be aligned with the Firmware/Hardware specs.
> ===============
> 
> V1->V2:
>  - Addressed coding style comments in patches #1 and #7
>  - The series is still based on rc4, as now I see net-next is also @rc4.
> 
> Please pull and let me know if there's any problem.

Pulled, thank you.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
