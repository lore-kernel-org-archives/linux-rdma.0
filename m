From: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [pull request][for-next 00/11] Mellanox, mlx5 E-Switch updates
 2017-12-19
Date: Tue, 19 Dec 2017 19:54:14 -0200
Message-ID: <20171219215414.GH6122@localhost.localdomain>
References: <20171219203340.2600-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171219203340.2600-1-saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 19, 2017 at 12:33:29PM -0800, Saeed Mahameed wrote:
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

Patch 10 actually looks quite worrysome if a card would support only
one ingress or egress, but if all of them support both, then it should
be fine yes. Is that possible, to support only one direction?

  Marcelo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
