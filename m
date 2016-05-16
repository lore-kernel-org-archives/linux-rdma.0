From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
 resolution module into core
Date: Mon, 16 May 2016 19:30:48 +0300
Message-ID: <20160516163048.GB4662@leon.nu>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <db369e8e-7993-dfb8-d459-2c4f3d6e5b14-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2016 at 11:09:44AM -0400, Doug Ledford wrote:
> On 05/15/2016 06:51 AM, Mark Bloch wrote:
>=20
> >> But, just as importantly, after reading addr.c to see how it uses the =
ibnl
> >> infrastructure, I don't even see what the original problem can be.
> > As it stands today:
> > - ibnl is part of ib_core.
> > - ib_core needs ib_addr.
> >=20
> > So if we add ibnl usage to ib_addr it means ib_addr will need ib_core,
> > which causes a dependency cycle.
>=20
> Right, but in that case, this patch needs to be part of the series that
> adds the ibnl support into the ib_addr functionality.  Because you split
> them into separate series, this was a patch looking for a problem to
> solve and it wasn't clear what it was.  If I had taken the other series
> and not this series, it would have broken things.  So please keep
> patches like this together with the other patches that depend on it.
>=20
> That said, I also don't want to redo modules if we don't have to.  As my
> previous email points out, changing modules breaks init scripts and
> systemd unit files.  It is to be avoided when possible.

Sorry,
I was in the mood of fixing things when I wrote and sent this patch.
The question is which version will you more likely to accept: this one
(remove ib_addr module) or previous one (add ib_netlink module)?

Thanks.
>=20
>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXOfW4AAoJEORje4g2clinxbkQAJ1CH0krOuUg3NBDKxFyiRGr
1aB1YBTYsDT6yLlTAckxyuXMz2eTCtK93jwvBX8CV5jXCIV1kW49OeHBarYAAB52
Mi/uVPncaGMYRI6nRjeVaV+zzXRDdt7K4bgR5xcRxacbHVuyoXjUdWoHeBRERnW0
Pr4r6epqnSThgYjKiukK99tCcFL/kCyfOhhVWLjIZvwEs+YBZoMwIaUfQy3UOnMI
YzZ0O5WqMDc3lMwy0XJOqJb2MVfCSt5B1vw2TyhgaQ5w9hqWe7vXf/gAxBCjXCV7
qgxq/mM4zHr4jSh5UxF1/YJkVJHSELztWZWIBiKTrMsXToXCvGiSWewagoBbS3ze
k4ZX+l9r2z7U3CdOadQK3Ji0Ar1QBoSGcabKQjyLf8WOyIocCGKOzZzXgLCDTshT
shqtpJXeKPmqhpDJWm7D+6LjKgq/leEog+EKQU9Ivh2o+4WbSPlDoE69Fc7IL2TA
96wJGBY8rpuF2GhpF4sIT4FjM1lx2JX5+yZNsJYZBkHKd1DI5wrwhx67Knz1IHn2
/k2/YVOsp57A6JB4XXRDWTVlRWIJXlMGyy9pECdjnBNvT2/3ijokL/MXF3PPf1ar
wRwxW1rPBhhYbwQCU+hPVOy2wWflCasmRt3XWTkuppcA5xgYvmxPSxrE8b18k+Gg
jAWWZV0SRMXudqmbS6m9
=DZXI
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
