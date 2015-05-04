From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 04 May 2015 10:41:32 -0400
Message-ID: <1430750492.2407.9.camel@redhat.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
	 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-EtA7AvZWMyOmJOMi6I6z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430720099-32512-2-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-EtA7AvZWMyOmJOMi6I6z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-04 at 02:14 -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Add Core capability flags to each port attribute and read those into ib_d=
evice
> upon registration for each port.
>=20
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/device.c |   41 ++++++++++++++++++++++++++++++++=
++++++
>  include/rdma/ib_verbs.h          |   22 ++++++++++++++++++++
>  2 files changed, 63 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/d=
evice.c
> index b360350..6a37255 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -262,6 +262,37 @@ out:
>  	return ret;
>  }
> =20
> +static int read_core_cap_flags(struct ib_device *device)
> +{
> +	struct ib_port_attr tprops;
> +	int num_ports, ret =3D -ENOMEM;
> +	u8 port_index;
> +
> +	num_ports =3D device->phys_port_cnt;
> +
> +	device->core_cap_flags =3D kzalloc(sizeof(*device->core_cap_flags)
> +						* (num_ports+1),
> +					 GFP_KERNEL);
> +	if (!device->core_cap_flags)
> +		return -ENOMEM;
> +
> +	for (port_index =3D 0; port_index <=3D num_ports; ++port_index) {
> +		if ((port_index =3D=3D 0 && device->node_type !=3D RDMA_NODE_IB_SWITCH=
))
> +			continue;
> +
> +		ret =3D ib_query_port(device, port_index, &tprops);
> +		if (ret)
> +			goto err;
> +
> +		device->core_cap_flags[port_index] =3D tprops.core_cap_flags;
> +	}
> +
> +	return 0;
> +err:
> +	kfree(device->core_cap_flags);
> +	return ret;
> +}
> +
>  /**
>   * ib_register_device - Register an IB device with IB core
>   * @device:Device to register
> @@ -302,12 +333,21 @@ int ib_register_device(struct ib_device *device,
>  		goto out;
>  	}
> =20
> +	ret =3D read_core_cap_flags(device);
> +	if (ret) {
> +		dev_err(&device->dev, "Couldn't create Core Capability flags\n");
> +		kfree(device->gid_tbl_len);
> +		kfree(device->pkey_tbl_len);
> +		goto out;
> +	}
> +
>  	ret =3D ib_device_register_sysfs(device, port_callback);
>  	if (ret) {
>  		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
>  		       device->name);
>  		kfree(device->gid_tbl_len);
>  		kfree(device->pkey_tbl_len);
> +		kfree(device->core_cap_flags);
>  		goto out;
>  	}
> =20
> @@ -351,6 +391,7 @@ void ib_unregister_device(struct ib_device *device)
> =20
>  	kfree(device->gid_tbl_len);
>  	kfree(device->pkey_tbl_len);
> +	kfree(device->core_cap_flags);
> =20
>  	mutex_unlock(&device_mutex);
> =20
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index c724114..4de2758 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -353,11 +353,32 @@ union rdma_protocol_stats {
>  	struct iw_protocol_stats	iw;
>  };
> =20
> +/* Define bits for the various functionality this port needs to be suppo=
rted by
> + * the core.
> + */
> +/* Management                           0x00000000FFFFFFFF */
> +#define RDMA_CORE_CAP_IB_MAD		0x0000000000000001ULL
> +#define RDMA_CORE_CAP_IB_SMI		0x0000000000000002ULL
> +#define RDMA_CORE_CAP_IB_CM		0x0000000000000004ULL
> +#define RDMA_CORE_CAP_IW_CM		0x0000000000000008ULL
> +#define RDMA_CORE_CAP_IB_SA		0x0000000000000010ULL
> +
> +/* Address format                       0x0000FFFF00000000 */
> +#define RDMA_CORE_CAP_AF_IB		0x0000000100000000ULL
> +#define RDMA_CORE_CAP_ETH_AH		0x0000000200000000ULL
> +
> +/* Protocol                             0xFFFF000000000000 */
> +#define RDMA_CORE_CAP_PROT_IB		0x0001000000000000ULL
> +#define RDMA_CORE_CAP_PROT_IBOE		0x0002000000000000ULL
> +#define RDMA_CORE_CAP_PROT_IWARP	0x0004000000000000ULL
> +#define RDMA_CORE_CAP_PROT_USNIC_UDP	0x0008000000000000ULL

In accordance with what we've been talking about, drop IBOE for ROCE.

Drop the UDP off of USNIC, then define a bit for CAP_PROT_UDP_ENCAP.
USNIC will be just USNIC, USNIC_UDP will be USNIC | UDP_ENCAP, ROCE v1
will be ROCE, and ROCEv2 will be ROCE | UDP_ENCAP.

> +
>  struct ib_port_attr {
>  	enum ib_port_state	state;
>  	enum ib_mtu		max_mtu;
>  	enum ib_mtu		active_mtu;
>  	int			gid_tbl_len;
> +	u64                     core_cap_flags;

I think u32 should be enough here, and will help keep our footprint
smaller.

>  	u32			port_cap_flags;
>  	u32			max_msg_sz;
>  	u32			bad_pkey_cntr;
> @@ -1684,6 +1705,7 @@ struct ib_device {
>  	u32			     local_dma_lkey;
>  	u8                           node_type;
>  	u8                           phys_port_cnt;
> +	u64                         *core_cap_flags; /* Per port core capabilit=
y flags */

Ditto.

>  };
> =20
>  struct ib_client {


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-EtA7AvZWMyOmJOMi6I6z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVR4UcAAoJELgmozMOVy/df0kP/3T32oBikdRXNzahXBgPA+DJ
O/98W2bkFOhyP6bMo+xC7GzDwpQXQou9UevmDd3N2sE8SrNHnrUbq1mpaW9/svhQ
+Tg9wtkJT+iD7LkJTyG3fUmiBjodNdk4oaCK3Jz1d8TxBw4Aqf2lRObhy+4ZkJVR
CYBt670sUzofhLEm2I0VZW7P3Jxe7IFEHsbPb9qm34KYtYloLjkCRGAPRtQGABUz
+Z7yNC1UADPRnjCUDD0NxKvDz1SgSSEfaMoMqMeOjNU2XcgkB8nGlQdOVZWj+ceC
fqv7RQ+xgM7S7OA778txu5AqJ+1inmPer7eE1ZbTYyxInrXQ7RhCVTCjWe6INoO+
aK/BNVVG29CC0DgJ8edepZwmz3VAEMhC0G2ZTP/FNaWx6z+T/uhEeAIFSnPcIC+k
23sAVsAV5LDpt01DVu2YeiS7VAFhzWkAc+fIWotv76uMWwyoALJ+E7HciuH2mCnL
S0/Vw6bunYmmks5XaPVzyWv0GiooL4lEWDAG4+oIFkvmQ22F5+mAUrkVy80BEW4y
3sJEyRG+dfhdFYl4+obcdcg2zchErAoNlURuT0AOQkWYhi6ogt/mMwN+l89B7/hG
JqQ7q7eW7yuDbCs/svKSUbhNOT6ulfENR0ivuCyG6C2P2VUfbvg8m6UtZzP9Ax2X
3tN3U5uUYKJVb+R/8e9O
=ENX0
-----END PGP SIGNATURE-----

--=-EtA7AvZWMyOmJOMi6I6z--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
