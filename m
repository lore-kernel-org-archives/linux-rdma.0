From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 3/7] Fix various missing swaps in
 debugging/logging macros
Date: Wed, 15 Mar 2017 07:24:06 +0000
Message-ID: <SN1PR07MB22075A6E4341F141A27692ECF8270@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1489508474-16664-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1489508474-16664-4-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489508474-16664-4-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Based on sparse output.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  ibacm/prov/acmp/src/acmp.c  | 13 +++++++------
>  ibacm/src/acm.c             |  4 ++--
>  providers/qedr/qelr_verbs.c |  4 ++--
>  3 files changed, 11 insertions(+), 10 deletions(-)
>=20
> diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
> index da4e69cd171f5b..fb8d30f3e6ac42 100644
> --- a/ibacm/prov/acmp/src/acmp.c
> +++ b/ibacm/prov/acmp/src/acmp.c
> @@ -2419,8 +2419,8 @@ static struct acmp_port *acmp_get_port(struct acm_e=
ndpoint *endpoint)
>  	struct acmp_device *dev;
>=20
>  	acm_log(1, "dev 0x%" PRIx64 " port %d pkey 0x%x\n",
> -		endpoint->port->dev->dev_guid, endpoint->port->port_num,
> -		endpoint->pkey);
> +		be64toh(endpoint->port->dev->dev_guid),
> +		endpoint->port->port_num, endpoint->pkey);
>=20
>  	list_for_each(&acmp_dev_list, dev, entry) {
>  		if (dev->guid =3D=3D endpoint->port->dev->dev_guid)
> @@ -2436,7 +2436,8 @@ acmp_get_ep(struct acmp_port *port, struct acm_endp=
oint *endpoint)
>  	struct acmp_ep *ep;
>=20
>  	acm_log(1, "dev 0x%" PRIx64 " port %d pkey 0x%x\n",
> -		endpoint->port->dev->dev_guid, endpoint->port->port_num, endpoint->pke=
y);
> +		be64toh(endpoint->port->dev->dev_guid),
> +		endpoint->port->port_num, endpoint->pkey);
>=20
>  	list_for_each(&port->ep_list, ep, entry) {
>  		if (ep->pkey =3D=3D endpoint->pkey)
> @@ -2736,13 +2737,13 @@ static int acmp_open_dev(const struct acm_device =
*device, void **dev_context)
>  	int i, ret;
>  	struct ibv_context *verbs;
>=20
> -	acm_log(1, "dev_guid 0x%" PRIx64 " %s\n", device->dev_guid,
> +	acm_log(1, "dev_guid 0x%" PRIx64 " %s\n", be64toh(device->dev_guid),
>  		device->verbs->device->name);
>=20
>  	list_for_each(&acmp_dev_list, dev, entry) {
>  		if (dev->guid =3D=3D device->dev_guid) {
>  			acm_log(2, "dev_guid 0x%" PRIx64 " already exits\n",
> -				device->dev_guid);
> +				be64toh(device->dev_guid));
>  			*dev_context =3D dev;
>  			dev->device =3D device;
>  			return 0;
> @@ -2823,7 +2824,7 @@ static void acmp_close_dev(void *dev_context)
>  {
>  	struct acmp_device *dev =3D dev_context;
>=20
> -	acm_log(1, "dev_guid 0x%" PRIx64 "\n", dev->device->dev_guid);
> +	acm_log(1, "dev_guid 0x%" PRIx64 "\n", be64toh(dev->device->dev_guid));
>  	dev->device =3D NULL;
>  }
>=20
> diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
> index 3550b11b324570..f3512dac106815 100644
> --- a/ibacm/src/acm.c
> +++ b/ibacm/src/acm.c
> @@ -2136,8 +2136,8 @@ static void acm_port_get_gid_tbl(struct acmc_port *=
port)
>  			if (ret || !port->gid_tbl[j].global.interface_id)
>  				break;
>  			acm_log(2, "guid %d: 0x%" PRIx64 " %" PRIx64 "\n", j,
> -				port->gid_tbl[j].global.subnet_prefix,
> -				port->gid_tbl[j].global.interface_id);
> +				be64toh(port->gid_tbl[j].global.subnet_prefix),
> +				be64toh(port->gid_tbl[j].global.interface_id));
>  		}
>  		port->gid_cnt =3D j;
>  	}
> diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
> index 4800a4b0f43e6f..8d94a122a2b871 100644
> --- a/providers/qedr/qelr_verbs.c
> +++ b/providers/qedr/qelr_verbs.c
> @@ -561,8 +561,8 @@ static void qelr_print_ah_attr(struct qelr_devctx *cx=
t, struct ibv_ah_attr *attr
>  {
>  	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP,
>  		   "grh.dgid=3D[%#" PRIx64 ":%#" PRIx64 "], grh.flow_label=3D%d, grh.s=
gid_index=3D%d, grh.hop_limit=3D%d,
> grh.traffic_class=3D%d, dlid=3D%d, sl=3D%d, src_path_bits=3D%d, static_ra=
te =3D %d, port_num=3D%d\n",
> -		   attr->grh.dgid.global.interface_id,
> -		   attr->grh.dgid.global.subnet_prefix,
> +		   be64toh(attr->grh.dgid.global.interface_id),
> +		   be64toh(attr->grh.dgid.global.subnet_prefix),
>  		   attr->grh.flow_label, attr->grh.hop_limit,
>  		   attr->grh.sgid_index, attr->grh.traffic_class, attr->dlid,
>  		   attr->sl, attr->src_path_bits,
> --
> 2.7.4

Thanks Jason.
How did sparse "know" what is little/big endian and where to use each?

Acked-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
