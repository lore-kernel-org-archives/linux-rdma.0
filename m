From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next v1 05/19] rdma: Move resource PD logic to
 separate file
Date: Sat, 23 Feb 2019 11:05:28 +0200
Message-ID: <20190223090528.GL23561@mtr-leonro.mtl.com>
References: <20190220072136.3840-1-leon@kernel.org>
 <20190220072136.3840-6-leon@kernel.org>
 <01d601d4ca22$28f83140$7ae893c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GBuTPvBEOL0MYPgd"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01d601d4ca22$28f83140$7ae893c0$@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'David Ahern' <dsahern@gmail.com>, 'netdev' <netdev@vger.kernel.org>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Stephen Hemminger' <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--GBuTPvBEOL0MYPgd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2019 at 02:15:16PM -0600, Steve Wise wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> > Sent: Wednesday, February 20, 2019 1:21 AM
> > To: David Ahern <dsahern@gmail.com>
> > Cc: Leon Romanovsky <leonro@mellanox.com>; netdev
> > <netdev@vger.kernel.org>; RDMA mailing list <linux-
> > rdma@vger.kernel.org>; Stephen Hemminger
> > <stephen@networkplumber.org>
> > Subject: [PATCH iproute2-next v1 05/19] rdma: Move resource PD logic to
> > separate file
> >
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Logically separate resource PD logic to separate file,
> > in order to make PD specific logic self-contained.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
>
> Why does it need to be self contained?

The main res.c file was so large that at least for me wasn't clear
how and what to refactor. Such separation allowed me to start code
cleanup by identification of duplicate places.

>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
>
>

--GBuTPvBEOL0MYPgd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJccQzYAAoJEORje4g2clinAcIP/087lmIZvJ/7k8/scaFiiiMg
s/eTp0Qsqfz7FE4OXArdSc9EyHCO+2KNq4tii2fz52hGckloZGWOE7Th6nGBZisD
e2+ArQe0jyPHPIw1moLpRL2k+9EXaB7cxLU9O7SeTrhoHufzWB4d7sFBH3OoJfxp
CKdXV9YOA/84DGsJz1EaXMSPpqHjCTjaKWOVQrzas5OdDEWk/vxRJ3PzPuzPtq/g
oNg+U/ZlulD9+ZXp72SI1q22T0acsxWvW8PdXIIi8C4aeFS5DssHGZrQ0vshBi1C
9iovaHet6aCj2ALCr63QbQ+oa9BDeIOTyadzqeicfhAyDjqSQ32NtNqpfOdXeSbV
0o834K5WwXvlVmdlRdomeICGKrUjFCwTYfeZ14tbtlCAVDvNOrbZIc5muKXoehI5
eiYxNHMcGKzhxZUsq/Vi2rdF72o+3g/dm3iO089TtvR6jRke/3JK+V2wIXzPHYKO
MypCMhOv7SeshoR8NhFanWP8eq7luBCvLvlZXWNwq9cnkiF0tZfgD7ACZQ5zbCu9
hj8US0vn5WX4lo+BUD87WC4eXVxYHvCtDLL5AX5SuhB/B4E2whOYmmidjHTNqm8R
NpjSCUJtqe88xT9GojF/EszFUfcyd0DYqGQSKFoFUf1kii9XHtqyOo07dEpukxu8
A8KSq8E8rhDbULebniuU
=g5dw
-----END PGP SIGNATURE-----

--GBuTPvBEOL0MYPgd--
