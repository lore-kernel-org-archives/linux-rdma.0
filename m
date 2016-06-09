From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Thu, 9 Jun 2016 22:16:08 +0300
Message-ID: <20160609191608.GA5408@leon.nu>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <021601d1bcf9$63dbe8d0$2b93ba70$@opengridcomputing.com>
 <CAG9sBKPa0qQ4uuhoWLfZaXP9E+DnLrkOcU-2yNXbdZFQKppN8w@mail.gmail.com>
 <20160609144554.GA14212@phlsvsds.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160609144554.GA14212-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 09, 2016 at 10:45:55AM -0400, Dennis Dalessandro wrote:
> On Thu, Jun 09, 2016 at 04:17:15PM +0300, Moni Shoua wrote:
> >2.  Trying to force SoftRoCE on this model will end up with rxe driver
> >registers to rvt with all ib_device hooks implemented. This makes the
> >reason to use rvt irrelevant in this case.
>=20
> Everything? What about AH, MR, PD? Aren't those pretty generic constructs.
> In fact you folks submitted the change for AH.
>=20

Despite the fact that I submitted change to hfi1, it doesn't make me
stake holder of that driver.

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXWcB4AAoJEORje4g2clinQuIQAJ4fye5fvZ3hM5pK8qfYtmso
FPEZ1CFos68yc2q06lXyeByVikD5D9vZqgcvB4Zxq2ecg4gv8Jjg5Ob7tvjRZyUp
ysSr7N4lQ3AR/E5LYxSsUOk3fodl0nKLwT4gMcHxAqBoxCv2o08WJhDwPOmhgDHS
00Yi/PEphdUAShBmzMWa6UHCceY6PJw7Ul/gINQHMWCdovr9VncvqCuKp8UcFu3A
+AeVS1rkHSjx6LmtdWGix9awvewio2vmmPuH5SCWqYQewdLuakiXIj7RX/HEsYrT
FD/fGP1chINU6lj6QV2QJgM1i/pRUlVjT2DPxWzMjwFT2ukPo35a9jXAfmpeYi/R
MZmyAW8vtLuXUJcWydzbCEYT0qTSSanQOHTnXwSFblj6Q8JbTwqcuLJ1vrjJp29L
SpqedDkr5Ti6rQqeiTe443wmkFRev4IZw+pbRzB29Ah7NXcI8WsQM014SL5RSqbr
sCtvYN1wjuSKOt/FB1aQpvgFKS2UaeeGkfHGn5LMkZWDj632JBl2fMswtYFdExHw
dVpEXGEtmqIUyvJbxvVW1xvaxoW8m23B79KTTlcqeos0ZfSnYvG4I9SrhadqJ3Xi
SKyE0vLfhegfwR8cogl15qsLhRL1FiGSbpdAc18CLB8FVqdA6WEgY/yTp1maK36T
vkKzj1GdAgbPl1Rovnsy
=v/qU
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
