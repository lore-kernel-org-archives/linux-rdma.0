From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Wed, 25 May 2016 16:14:33 +0300
Message-ID: <20160525131433.GL25500@leon.nu>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05004F@ORSMSX109.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+svXpSx+RSEd8UhP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05004F-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+svXpSx+RSEd8UhP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 24, 2016 at 07:37:13PM +0000, Hefty, Sean wrote:
> > struct ib_uverbs_ioctl_hdr {
> > 	__u32 length;
>=20
> FWIW, I limited length to 16-bits, to prevent passing massive amounts of =
data between user space and the kernel as a single transfer.

We are preventing it in the code
 988 #define IB_UVERBS_MAX_CMD_SZ    4096
=2E...
1096 static long ib_uverbs_ioctl(struct file *filp, unsigned int cmd,
1097                             unsigned long arg)
1098 {
=2E..
1141         if (hdr.length > IB_UVERBS_MAX_CMD_SZ || hdr.length <=3D sizeo=
f(hdr)) {
1142                 pr_debug("invalid uverbs ioctl command length %d\n", h=
dr.length);
1143                 return -EINVAL;
1144         }

>=20
> > 	__u16 flags;
>=20
> 16-bit flags seems limiting.

These flags will be relevant to IOCTL header only, and if we consume them a=
ll, It will be sign
to move to new IOCTL number.

>=20
> > 	__u16 object_type;
> > 	__u16 reserved;
> > 	/* First 8 actions are common to all objects */
> > 	__u16 action;
> > 	__u32 user_handler;
> > 	/*
> > 	 * These fields represent core response only,
> > 	 * provider's response is given as a netlink attribute.
> > 	 */
> > 	struct ib_uverbs_uptr resp;
>=20
> This is associating the kernel ABI with a specific implementation of user=
 space components.

I don't see any specific in the proposed ABI.

>=20
> Ioctl implementations I looked at treated the ioctl buffer as input-outpu=
t (except for read only or write only ioctl's).  Maybe there's examples of =
redirecting the response to separate buffer(s)?
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--+svXpSx+RSEd8UhP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXRaU5AAoJEORje4g2clinrsIQAJp0Tk6SImBZuKerqFfXdfJg
rUTKFOXHuEWwk+18eWcpHfM5SXOZXjtP0/3e5XdG08Fb6Dht2Q6acaRl9YZ3fbmP
ubU5tqIY4sbiMhO2ZsADe1rVPIijrm/nUXsoUlgb3MT35or92sWijTU1Q3uZGxbq
mr0qWBCq1DiZocrm8THTclIYeSALjE+TUBsaIJH0AjgC3aiwz7Ywd1k1mGU5NBCO
2GoYc47+qGEvfEoVXbtm6kJ3YtlEFqvBxFo4KP7WujKRcuWIjz/LUFaXnFVNpzrd
K/1vHLP+iNu9EgPUUn4ZC0Pm5ouaI9wOaSGyYUYxosk2FGcm84DLjZzWl4v7TNLw
x3CwKZ6ek6QmdtKytrP9DPucR7Akk2CvMVC9SDhTtNTs7GoIMYDckRpiyaHm+I91
49hyOwmPuXV90xeH22iMgiYtW6z0a+YwcjREs3VXFA2jOLLx+bj6cIwDCRRwxX6m
04hOEQKQZj71sDLb/rvKxiD1okc5rGqdoWtu7p6IYWrx5SUyV6TQ0xw4d6WT3WZT
iejS8BwmUPt4TR4F2AOyrhF+a6kbRcGpPpTFq8XvcuS8y0FZJ7nNcdyS/sln8gzs
7YoI9NrecXRFjERgBR64Yh0A2FlNKTs9uK74YnD2aoA/KWRryCQk3F++ifvYZKON
MSj/19CsT/cB9Zd8zcNs
=1w/c
-----END PGP SIGNATURE-----

--+svXpSx+RSEd8UhP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
