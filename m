From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] Policy changes and packaging support
Date: Wed, 28 Sep 2016 14:27:47 -0400
Message-ID: <57EC0BA3.6060506@redhat.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="jfpjRxfuMVLTkgbFR22K7Wi4daxur0NfT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Jolly <jjolly-IBi9RG/b67k@public.gmane.org>, Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jfpjRxfuMVLTkgbFR22K7Wi4daxur0NfT
Content-Type: multipart/mixed; boundary="JuXXGug5BgmL6rtm0nnNcAGlXg3OrlM07";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Jolly <jjolly-IBi9RG/b67k@public.gmane.org>,
 Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Message-ID: <57EC0BA3.6060506-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] Policy changes and packaging support
References: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--JuXXGug5BgmL6rtm0nnNcAGlXg3OrlM07
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/23/16 3:16 PM, Jason Gunthorpe wrote:
> This is the next batch of rdma-core updates, these 13 patches deal prim=
arily
> with how the package is built and the install paths afterwards. Most li=
kely
> these changes are mainly of interest to packagers.
>=20
> The discussion here is informative for some of the patches:
>  http://www.spinics.net/lists/linux-rdma/msg39578.html
>=20
> View the commits on github:
>=20
>  https://github.com/linux-rdma/rdma-core/pull/3
>=20
> Please forward Acks and I will update the commits.
>=20
> One important thing to note is that this series pretty much eliminates =
all
> hard coded paths from the tree. While this is a good thing, it means th=
e
> default behavior is to set SYSCONFDIR to /usr/local/etc/, which is prob=
ably
> not what people testing the daemons really want. Compile with:
>=20
>  cmake -GNinja .. -DCMAKE_INSTALL_SYSCONFDIR:PATH=3D/etc
>=20
> Which is similar to the configure --sysconfdir option

Series looks good modulo the few feedback items.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--JuXXGug5BgmL6rtm0nnNcAGlXg3OrlM07--

--jfpjRxfuMVLTkgbFR22K7Wi4daxur0NfT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX7AujAAoJELgmozMOVy/dzlQP/1WmM5CSMBMdazoCURyG5TQV
t6CLLILdS8wAnQazTwJkf0CLMnW6egGybMxnJPtMF3o+lxOJNYWxGcaROg8odrg+
eFqC+zkGZe59qiDTLlGND0NczdliBNXfqmjbtQyqGZaWNSG8oIm/xrKqZLmCfnVo
p7xSC3yZvRu3w2ZPoXRDsIY7Y5WwTp0hI+cxD1lTXOkvEUch/FiLcrlHaodC3Y3v
wUWdM1wIVfKlk4iOydzATMKMjeyWz8cyBFs8h//YBZe7f1zCKWwxeN2isPEctNp3
dMx2ZFlqc+SNrjhE9mV4pblSG95+mYQXgSVqjSDgyjqAjclCE4SrUcLPMbJOueTg
Xhs6Ar6BXynxSAjT8HI1CG7aG1/2CiWvyIotulWLexpIIWzxVOZQhpNBs5HfJJEC
X+vo3X1QdK5k3BLbqXAA6T0aGI8acz91tWsoxMVm88jznf4ceB07NpyEJgdAEO8O
sNe49iUg/A1hlVEH4/0hz9sF8kZ0mesi0tHRwWuPF0Dzxj153ZnMCzTGkyYEq4IJ
idFLEWc9mnPxjstMFmAQkurT96OBftKK6bIYM6SdzeSNuKN8r73MalArGCMZDZq8
IA6crX5FHXB/od4n2QNpEifD4bvcGNCpHos3C2AqQFcbAr8pe0Rqi2mk9INdilSv
WXnA3NPDmJsA+juBNt3f
=DEhZ
-----END PGP SIGNATURE-----

--jfpjRxfuMVLTkgbFR22K7Wi4daxur0NfT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
