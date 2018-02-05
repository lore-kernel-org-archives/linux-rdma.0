From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] RDMA: Use standard way to check return value
Date: Mon, 05 Feb 2018 12:38:24 -0500
Message-ID: <1517852304.3936.75.camel@redhat.com>
References: <20180124124301.10884-1-yuval.shaia@oracle.com>
         <1516806357.3324.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-yAHQ7wCQ+Wpg07BrUiBJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516806357.3324.1.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "hare-IBi9RG/b67k@public.gmane.org" <hare-IBi9RG/b67k@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-yAHQ7wCQ+Wpg07BrUiBJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-24 at 15:06 +0000, Bart Van Assche wrote:
> On Wed, 2018-01-24 at 14:43 +0200, Yuval Shaia wrote:
> > To be compatible with other modules/drivers, change return code checks
> > from "if (rc !=3D 0)" to "if (rc)".
>=20
> Sorry but I think this is a completely pointless change. All the code tha=
t is
> touched by this patch works fine, conforms to all appropriate coding styl=
e
> guides and is easy to read. So why change it?
>=20
> Bart.

Hi Yuval,

Since about 1/3 of the LOC in this is in srp/srpt, and the maintainer
objects and thinks the patch is unnecessary, I'm inclined to drop this
unless you want to make an argument for why it should go on in.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-yAHQ7wCQ+Wpg07BrUiBJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlp4lpAACgkQuCajMw5X
L90mthAAj79LpEcjaRrf01EvVVveeryviDhFy1f8N4tpFZid2qH9AhXipuTLfRgd
rup39qopriACMBzc0UulA8132AYA2s9//heHpdysp52pm9hOYOlDNLkGe1XX8MYf
xE/Fxdva8MjFkJU7c5JciI65kwNbunF0blIhofOc6rgxWXEAEPUOXqeyYFpvi5wU
/p9WNm6TUON55QJLigGBxnte9xVAivwrCf1IfACzBh864xZf/23PDPpv/Kvs2kUa
fdTvRHpHDWcJc5V84zOnItV3ARI/fayM74b3KZgTpE8+6q1ZoH4RJnvBPGyR3slZ
Wjg081GNk7BL2/TbYAl4Ujs5JoPuRko9YUBVpgYfkl9w/pXtvG39kjhU9IbHw+AG
BMnTf1XuQs1qqniV9wacrNhTTCF6FhMtambf7LgvpGIUPrRc0PmhXy65gMQ9re4S
WSr6a60lBsI1vSu6yRvushYVl64S3hjHI41ZseCOFd2OcN/ctIs5SvYke7ak4kS6
A4NDcqs+oQy7TyoEoL1Uk8YetPnia17uyGCNa1ZiZ0nQ4lBW2oUO1pxNctzrK6Zo
CBNhHDLKfUxsPtwHOpH70Wd5EHr7bD8gozpTxLCjbAUcIVRL4rlALPWlXJH2VGwJ
ff9JTCF+vA9HCxQTmLvVSaWdGawOhWHNPea20Jrn1YhHX23b4QY=
=BJ4R
-----END PGP SIGNATURE-----

--=-yAHQ7wCQ+Wpg07BrUiBJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
