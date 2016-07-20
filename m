From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V2 1/8] RDMA/core: Export RDMA IOCTL declarations
Date: Wed, 20 Jul 2016 06:15:13 +0300
Message-ID: <20160720031513.GQ20674@leon.nu>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-2-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1607192004510.5828@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="25rOlkxR6a4U87uN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1607192004510.5828-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--25rOlkxR6a4U87uN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 19, 2016 at 08:06:35PM -0500, Christoph Lameter wrote:
> On Tue, 19 Jul 2016, Matan Barak wrote:
>=20
> > Place all external RDMA IOCTL declarations into one UAPI exported
> > header file and move all legacy MAD commands to that file.
>=20
> Reviewed-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>=20
> Isnt this actually a proper cleanup because the legacy ioctl
> definitions for MAD commands should have been a part of the uapi?
> Thus this patch could be merged immediately?

Yes, it will.
We will respin this patch along with IDR refactoring patch as a separate
patchset to RFC ABI patches.

Thanks.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--25rOlkxR6a4U87uN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXjuzBAAoJEORje4g2clinApEP/ApcndN6ExO90AbaL00I+2Of
x/0ou54GE54fcOLDI9hMQhWazJSRXnx0oXQFOLRpcD2g0ob2jm4t1uWK9rs+tMnM
YAm1Sz+TM/u2eBvCgfcyR6lS9NhhTjGGvDjvjFQyerue0ksD9nFO5VaGCsqh7Prv
N1+KB/2zANg6z+TRsq48SRh9QdVCALXDZh3cAUYoiZXRssBIAcL5bYpy80XwzkhC
4Jwiktc0Bd9v/9V9ixgb78nVZPypi/QRi/GFFRlEaGXdD7+SNArQ7/O4ml1TY6nn
aI6o3XdfRIYkfHIU0hg3c5nCvzyJExPOfxNnAMR1STgOqlDVtYJSdA9oeNl26znH
TTq5mUAmeUhilTzwZv0uGXWPOmCsA1Oc10sGaaHIxpS+IGhp3IPB5SkEmkZBmHIW
xacB8E0pCH+dWElaV38RLW+guqf6j6gAggINh51lGApDSFsFwzNyXA5MUKR26zCo
F/EQ2MuJ2l+E7Pu570bab5NBpQ1rJxdr/gdy/ZyXC2IjaMgLz3E021hGEkY9P8se
X2NMDQKtRYqmggO9SBwTmpnHAMGQNHqRQd7FsHv6p4+Kyoz7Ym+8Hx9n92XTSeDQ
249RoST6Ajyc4pVHMRn0UPEeziEadNwdVwDyQnOXv8AaY0YFDKncBh8WrZH8ph56
12xnZb0cNTkRJ48h9Zy8
=jksw
-----END PGP SIGNATURE-----

--25rOlkxR6a4U87uN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
