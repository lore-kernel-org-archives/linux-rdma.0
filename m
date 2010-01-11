From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv7 4/9] ib_core: RoCEE CMA device binding
Date: Mon, 11 Jan 2010 09:04:13 -0500
Message-ID: <f0e08f231001110604w69481083s45b2dfb8a84117ba@mail.gmail.com>
References: <20100105103257.GF31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100105103257.GF31480@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 5, 2010 at 5:32 AM, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> wrote:
> Add support for RoCEE device binding and IP --> GID resolution. Path =
resolving
> and multicast joining are implemented within cma.c by filling the res=
ponses and
> pushing the callbacks to the cma work queue. IP->GID resolution alway=
s yields
> IPv6 link local addresses - remote GIDs are derived from the destinat=
ion MAC
> address of the remote port. Multicast GIDs are always mapped to multi=
cast MACs
> as is done in IPv6. Some helper functions are added to ib_addr.h. =C2=
=A0IPv4
> multicast is enabled by translating IPv4 multicast addresses to IPv6 =
multicast
> as described in
> http://www.mail-archive.com/ipng-Va8kgSFw1KyzQ7sTrsxvMkEOCMrvLtNR@public.gmane.org/msg02134.html.
>
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/core/cma.c =C2=A0| =C2=A0261 +++++++++++++++=
+++++++++++++++++++++++--
> =C2=A0drivers/infiniband/core/ucma.c | =C2=A0 45 ++++++-
> =C2=A0include/rdma/ib_addr.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 98 =
+++++++++++++++-
> =C2=A03 files changed, 385 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/=
cma.c
> index fbdd731..e8e28ae 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c

[snip...]

> @@ -1707,6 +1740,78 @@ static int cma_resolve_iw_route(struct rdma_id=
_private *id_priv, int timeout_ms)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
>
> +static int cma_resolve_rocee_route(struct rdma_id_private *id_priv)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct rdma_route *route =3D &id_priv->id.rout=
e;
> + =C2=A0 =C2=A0 =C2=A0 struct rdma_addr *addr =3D &route->addr;
> + =C2=A0 =C2=A0 =C2=A0 struct cma_work *work;
> + =C2=A0 =C2=A0 =C2=A0 int ret;
> + =C2=A0 =C2=A0 =C2=A0 struct sockaddr_in *src_addr =3D (struct socka=
ddr_in *)&route->addr.src_addr;
> + =C2=A0 =C2=A0 =C2=A0 struct sockaddr_in *dst_addr =3D (struct socka=
ddr_in *)&route->addr.dst_addr;
> + =C2=A0 =C2=A0 =C2=A0 struct net_device *ndev =3D NULL;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (src_addr->sin_family !=3D dst_addr->sin_fa=
mily)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> +
> + =C2=A0 =C2=A0 =C2=A0 work =3D kzalloc(sizeof *work, GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 if (!work)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> +
> + =C2=A0 =C2=A0 =C2=A0 work->id =3D id_priv;
> + =C2=A0 =C2=A0 =C2=A0 INIT_WORK(&work->work, cma_work_handler);
> +
> + =C2=A0 =C2=A0 =C2=A0 route->path_rec =3D kzalloc(sizeof *route->pat=
h_rec, GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 if (!route->path_rec) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -ENOMEM;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err1;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 route->num_paths =3D 1;
> +
> + =C2=A0 =C2=A0 =C2=A0 rocee_mac_to_ll(&route->path_rec->sgid, addr->=
dev_addr.src_dev_addr);
> + =C2=A0 =C2=A0 =C2=A0 rocee_mac_to_ll(&route->path_rec->dgid, addr->=
dev_addr.dst_dev_addr);
> +
> + =C2=A0 =C2=A0 =C2=A0 route->path_rec->hop_limit =3D 2;
> + =C2=A0 =C2=A0 =C2=A0 route->path_rec->reversible =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 route->path_rec->pkey =3D cpu_to_be16(0xffff);
> + =C2=A0 =C2=A0 =C2=A0 route->path_rec->mtu_selector =3D 2;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (addr->dev_addr.bound_dev_if) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ndev =3D dev_get_b=
y_index(&init_net, addr->dev_addr.bound_dev_if);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ndev)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -ENODEV;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ndev)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 route->path_rec->m=
tu =3D rocee_get_mtu(ndev->mtu);
> + =C2=A0 =C2=A0 =C2=A0 route->path_rec->rate_selector =3D 2;
> + =C2=A0 =C2=A0 =C2=A0 if (ndev)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 route->path_rec->r=
ate =3D rocee_get_rate(ndev);

The rocee_get_rate routine seems to merely get the (local) device
rate. So this seems to me to only work in a homogeneous (single speed
subnet) but what about a heterogeneous one (either different speed
links or links negotiated down) ? What happens if a link internal to
the subnet is slower ? Isn't this important for setting a proper
static rate control ?

Similar thing may also be true for other path related parameters if
they can vary along the path.

-- Hal

[snip...]
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
