From: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [pull request][for-next 00/11] Mellanox, mlx5 E-Switch updates
 2017-12-19
Date: Tue, 19 Dec 2017 20:46:00 -0200
Message-ID: <20171219224600.GJ6122@localhost.localdomain>
References: <20171219203340.2600-1-saeedm@mellanox.com>
 <20171219215414.GH6122@localhost.localdomain>
 <CALzJLG9i4g7c8vKbw7k+o=Pv5GcqWi6AATpOQXj09_KwqvWkmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALzJLG9i4g7c8vKbw7k+o=Pv5GcqWi6AATpOQXj09_KwqvWkmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Netdev List <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 19, 2017 at 02:39:38PM -0800, Saeed Mahameed wrote:
> On Tue, Dec 19, 2017 at 1:54 PM, Marcelo Ricardo Leitner
> <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Tue, Dec 19, 2017 at 12:33:29PM -0800, Saeed Mahameed wrote:
> >> Hi Dave and Doug,
> >>
> >> ==============
> >> This series includes updates for mlx5 E-Switch infrastructures,
> >> to be merged into net-next and rdma-next trees.
> >>
> >> Mark's patches provide E-Switch refactoring that generalize the mlx5
> >> E-Switch vf representors interfaces and data structures. The serious is
> >> mainly focused on moving ethernet (netdev) specific representors logic out
> >> of E-Switch (eswitch.c) into mlx5e representor module (en_rep.c), which
> >> provides better separation and allows future support for other types of vf
> >> representors (e.g. RDMA).
> >>
> >> Gal's patches at the end of this serious, provide a simple syntax fix and
> >> two other patches that handles vport ingress/egress ACL steering name
> >> spaces to be aligned with the Firmware/Hardware specs.
> >
> > Patch 10 actually looks quite worrysome if a card would support only
> > one ingress or egress, but if all of them support both, then it should
> > be fine yes. Is that possible, to support only one direction?
> >
> 
> Hi Marcelo,
> 
> Patch 10 is a function renaming patch that fixes a function name to
> correspond with its behavior!
> 
> Are you asking about all mlx5 cards or all cards in general ?
> All patches in this series, and specifically patches 10,11 only
> concern mlx5 eswitch specific implementation and mlx5 hardware spec,
> they have nothing to do with other vendors cards.

I was asking only bout Mellanox cards.

> 
> All mlx5 cards do support both ingress and egress ACLs per vport (VF),
> each has its own namespaces (separate pipeline), hence patch #11.

Alright then.

> 
> So i don't see why you worry so much :).

Oh but because currently they are called like:

                if (MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support)) {
                        err = init_egress_acl_root_ns(steering);
....

                if (MLX5_CAP_ESW_INGRESS_ACL(dev, ft_support)) {
                        err = init_ingress_acl_root_ns(steering);
....

and it could cause bigger problems if only one kind were supported,
like trying to setup egress while it's not supported by the card.
But again, as it seems both are always supported, that's no issue.

Thanks,
Marcelo

> 
> >   Marcelo
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
