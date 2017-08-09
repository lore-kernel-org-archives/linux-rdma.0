From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 23/33] RDMA/netlink: Add nldev port dumpit
 implementation
Date: Wed, 9 Aug 2017 13:47:48 -0400
Message-ID: <de32381b-0c70-620c-463c-9e89f8ea0388@redhat.com>
References: <20170809160405.25142-1-leon@kernel.org>
 <20170809160405.25142-24-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ti7RAxotaoGcRVIDvS8LIsq3FIpEEtA6V"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809160405.25142-24-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ti7RAxotaoGcRVIDvS8LIsq3FIpEEtA6V
Content-Type: multipart/mixed; boundary="5LoleNJx5OTr9gdVVU3Jo73j7m7QDkv0V";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <de32381b-0c70-620c-463c-9e89f8ea0388-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 23/33] RDMA/netlink: Add nldev port dumpit
 implementation
References: <20170809160405.25142-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20170809160405.25142-24-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170809160405.25142-24-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--5LoleNJx5OTr9gdVVU3Jo73j7m7QDkv0V
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/9/2017 12:03 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> This patch implements the query interface to get all
> ports data for the specific device.
>=20
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/nldev.c | 61 +++++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 61 insertions(+)
>=20
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/=
nldev.c
> index 666940f2b49a..4413eda8c435 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -53,6 +53,18 @@ static int fill_dev_info(struct sk_buff *msg, struct=
 ib_device *device)
>  	return 0;
>  }
> =20
> +static int fill_port_info(struct sk_buff *msg,
> +			  struct ib_device *device, u32 port)
> +{
> +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_DEV_INDEX, device->index))
> +		return -EMSGSIZE;
> +	if (nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_NAME, device->name))
> +		return -EMSGSIZE;
> +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port))
> +		return -EMSGSIZE;
> +	return 0;
> +}
> +
>  static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			  struct netlink_ext_ack *extack)
>  {
> @@ -129,11 +141,60 @@ static int nldev_get_dumpit(struct sk_buff *skb, =
struct netlink_callback *cb)
>  	return ib_enum_all_devs(_nldev_get_dumpit, skb, cb);
>  }
> =20
> +static int nldev_port_get_dumpit(struct sk_buff *skb,
> +				 struct netlink_callback *cb)
> +{
> +	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
> +	struct ib_device *device;
> +	int start =3D cb->args[0];
> +	struct nlmsghdr *nlh;
> +	u32 idx =3D 0;
> +	u32 ifindex;
> +	int err;
> +	u32 p;
> +
> +	err =3D nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> +			  nldev_policy, NULL);
> +	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
> +		return -EINVAL;
> +
> +	ifindex =3D nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> +	device =3D __ib_device_get_by_index(ifindex);
> +	if (!device)
> +		return -EINVAL;
> +
> +	for (p =3D rdma_start_port(device); p <=3D rdma_end_port(device); ++p=
) {
> +		if (idx < start) {
> +			idx++;
> +			continue;
> +		}

So, to someone who has been studying netlink internals (aka, you), the
relationship between cb->args[0] to start to idx to p may make sense.
To those of us that aren't totally versed in what appears to be a
recursive callback, but which isn't clear on how cb->args[0] ever gets
initialized the first time, or how the idx in ib_enum_all_devs()
translates to the idx here, a few comments in the code might be helpful.

> +
> +		nlh =3D nlmsg_put(skb, NETLINK_CB(cb->skb).portid,
> +				cb->nlh->nlmsg_seq,
> +				RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
> +						 RDMA_NLDEV_CMD_PORT_GET),
> +				0, NLM_F_MULTI);
> +
> +		if (fill_port_info(skb, device, p)) {
> +			nlmsg_cancel(skb, nlh);
> +			goto out;
> +		}
> +		idx++;
> +		nlmsg_end(skb, nlh);
> +	}
> +
> +out:	cb->args[0] =3D idx;
> +	return skb->len;
> +}
> +
>  static const struct rdma_nl_cbs nldev_cb_table[] =3D {
>  	[RDMA_NLDEV_CMD_GET] =3D {
>  		.doit =3D nldev_get_doit,
>  		.dump =3D nldev_get_dumpit,
>  	},
> +	[RDMA_NLDEV_CMD_PORT_GET] =3D {
> +		.dump =3D nldev_port_get_dumpit,
> +	},
>  };
> =20
>  void __init nldev_init(void)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--5LoleNJx5OTr9gdVVU3Jo73j7m7QDkv0V--

--Ti7RAxotaoGcRVIDvS8LIsq3FIpEEtA6V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZi0rEAAoJELgmozMOVy/dvLIP/jGjXS4zH3Dmmt+IM6Zr8Eke
yu87s51nvUcqQxRwUcv1rnOsLZf6gVtkcA1WVeppjvhjHnyHtLw7ecUSEfkHN0PI
8xECa/Btrl5vijvNfxInNpsB11TdLB4/smUMGVJBZ/c7gREXNM8isYwoHdUOU2QY
E9N6uslyurfJthLjGVt5F4twSPiF9aUmROCdCI2gRbdwG2sLODPwKHoULDZhIYbU
qIK8faqkWlR/GeoZWCqrJXHWWFDD5k0YqGOxBJ8dKbw/nFVoCPcNwQvX+2Qy3LTj
zXncEMOh+nQDQhl/RnbTzRFnKhGJpnbKg+/1OMztwLlTvOUOEjBMYlVhBLo5drIe
Ro30IKyNnv2qwOeS1RvSLA0vRLn4Qcqw69io46k8QMkurgCcQdpe6GumUp3n8ZuM
g40gi7W/OgY5gWdBWf2rF0J8VrqPZVRETzXW7ViOisyNXCEw6psCRNqhZHaWC5ko
yuKudPzks0KRrJy0+oHv7dBF5Nbat+nQtYaLFhfcm5+gEDS7RZVnF5OYDvFYIn6I
pyhKwzqJo9z4p5XrdoFn8L1vB6S4OSahS4cgM54A9udCCWrEsVujTHipFk9+hQiy
8uc6EnvmXypw85s+QvkFYiRUYq2nBsK9r1/13yFC3YChpBdIvjjwhkoQc87aBCBZ
Xav30C8cHOziY/hGiLP5
=pxFT
-----END PGP SIGNATURE-----

--Ti7RAxotaoGcRVIDvS8LIsq3FIpEEtA6V--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
