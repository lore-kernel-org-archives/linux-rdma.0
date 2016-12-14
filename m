From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Add support for Vxlan protocol for the
 steering rules
Date: Wed, 14 Dec 2016 13:03:07 -0500
Message-ID: <920795b3-98ef-96f6-1dc4-1b5171ef49c7@redhat.com>
References: <1479143092-11723-1-git-send-email-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6EdH1Kt4rtSPOjJJqKFTOeRQJbgSbej5h"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479143092-11723-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6EdH1Kt4rtSPOjJJqKFTOeRQJbgSbej5h
Content-Type: multipart/mixed; boundary="jQoo2potqXWN5fLtsautExTmedh4354rA";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <920795b3-98ef-96f6-1dc4-1b5171ef49c7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Add support for Vxlan protocol for the
 steering rules
References: <1479143092-11723-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1479143092-11723-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--jQoo2potqXWN5fLtsautExTmedh4354rA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/14/2016 12:04 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>=20
> Virtual Extensible LAN - Vxlan is a proposed encapsulation protocol for=

> running an overlay network on existing Layer 3 infrastructure. An
> overlay network is a virtual network that is built on top of existing
> network Layer 2 and Layer 3 technologies to support elastic COMPUTE
> architectures. Vxlan will make it easier for network engineers to scale=

> out a cloud computing environment while logically isolating cloud apps
> and tenants.
>=20
> This patchset introduces support Vxlan steering rules to IB/core and
> mlx5 devices implementation. The application will be able to send
> packet with Vxlan tunneling, and configure a steering rule to receive
> the stream from the rule to the QP.
>=20
> The rule will contain inner and outer parts for the inner and outer
> protocol header respectively. The matching is based on the rule
> specification and it includes the Vxlan header itself, so application
> will be able to send several Vxlan streams with a new vni for each stre=
am.
>=20
> In order to steer traffic according to a Vxlan tunnel ID, there is a ne=
ed to
> use the ibv_cmd_create_flow call. At the end of the struct, the applica=
tion
> should append several specs for each feature.
>=20
> The number of specifications to add is 4. Use the first as the Vxlan
> spec (tunnel), which is described below. The following specifications t=
o
> add are the L2, L3, and L4 specs.
>=20
> There is an option to mask a range of tunnel IDs to be steered by using=

> the filler mask, This following example provides the ibv_flow_tunnel_fi=
lter
> struct definition:
>=20
> struct ibv_flow_tunnel_filter {
>         uint32_t tunnel_id;
> };
>=20
> This following example specifies the Vxlan tunnel definition:
>=20
> struct ibv_flow_spec_tunnel {
>         enum ibv_flow_spec_type  type;
>         uint16_t  size;
>         struct ibv_flow_tunnel_filter val;
>         struct ibv_flow_tunnel_filter mask;
> };
>=20
> Where:
>=20
>  * type - Specifies that there is a need to use IBV_FLOW_SPEC_VXLAN_TUN=
NEL
> 	to define the spec as an Vxlan spec.
>  * size - Identifies the size of the ibv_kern_spec_tunnel.
>  * tunnel_id: Indicates that the tunnel ID as in the Vxlan header.
>=20
>=20
> Thanks,
> 	Mosses and Leon.
>=20
> Available in the "topic/vxlan" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/vxlan
>=20
> CC: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Moses Reuben (6):
>   IB/core: Add flow spec tunneling support
>   IB/core: Align structure ib_flow_spec_type
>   IB/uverbs: Add support for Vxlan protocol
>   IB/mlx5: Support Vxlan tunneling specification
>   IB/core: Introduce inner flow steering
>   IB/mlx5: Add support to match inner packet fields
>=20
>  drivers/infiniband/core/uverbs_cmd.c |  19 ++++-
>  drivers/infiniband/hw/mlx5/main.c    | 142 ++++++++++++++++++++++-----=
--------
>  include/rdma/ib_verbs.h              |  44 +++++++----
>  include/uapi/rdma/ib_user_verbs.h    |  17 +++++
>  4 files changed, 155 insertions(+), 67 deletions(-)

Series applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--jQoo2potqXWN5fLtsautExTmedh4354rA--

--6EdH1Kt4rtSPOjJJqKFTOeRQJbgSbej5h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUYlbAAoJELgmozMOVy/dx7AQAL49QgI2cYZGw9hF46tA/M2H
BvTerWMzEfYiyVlVphu7U70KJqPV5cXmUYyR5273LCxDjacHtxT0hGzVGJHqBUW6
6/BSNXwsxPu0+aVsGUKqxxdBzEEI7goHP/2gt9ZOdltVZKNjXoUBXU3wdPvYxXpE
SvCrRLwmipz+ru+rrJUGKIIefE6jMB/TeUzt8eu5idvArpCjkbWZ5tBZ1c6VPpO5
tPGIpscq7QJe0tUOZPQR4hj7B5lcbGSWW35QZRjSOhQrxJS+Fuvm1lkhl9fUlBUx
7cc6FaujTA59lpUI1hUejrGkBPNb7vkvaXb6S9CJk2x4xjVy65516CSf6RAAw0uF
RubJCbi2L2eUVmHSlkzalazjAvXqW0p4WfRrV9PXZgUTvtUdnFyFWLhjXrLOBFoX
xtk+5KElir3DDQ5YHf/D/LSfBDmi8ho46e8R4jUlXlpq1b7dTwPPRCsCg5KHE2pi
ZZj8EvgPBTcIgy3e6PicwgyUWxVLzZjvwbNnnp828skGpx5aetgm0APmGE/Ake/N
FPMm+9ZsCr7zo6/dC3drWfy9kScpJhllbXjkmnCZcmlCVr/rNteC5q1HXP7gtsEy
FywDkDSMcR9pQnpRHGXFM6MtdoIOwpJZOb0QkGcxQuyOiPKyLXptjjHNoUnM+j2K
9d2HZU0LodbscKAh/rkt
=D9n1
-----END PGP SIGNATURE-----

--6EdH1Kt4rtSPOjJJqKFTOeRQJbgSbej5h--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
