From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/2] Add support for reporting LSO
 capabilities
Date: Wed, 27 Apr 2016 20:09:03 +0300
Message-ID: <20160427170903.GA11554@leon.nu>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <20160427164230.GB11617@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160427164230.GB11617-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 27, 2016 at 10:42:30AM -0600, Jason Gunthorpe wrote:
> On Wed, Apr 27, 2016 at 05:04:50PM +0300, Matan Barak wrote:
>=20
> > This patch series enables hardware to report Large Segment Offload(LSO)
> > capabilities from kernel to user space. LSO enabled NIC will accept big=
 chuck of
> > data with size greater than MTU. The LSO engine will split them into
> > separate packets and insert the headers automatically. With LSO, CPU is
> > offloaded from dealing with much less throughput of data.
>=20
> I also feel like we should stop changing the current uAPI until we get
> the new one in place.

This functionality doesn't relate to ABI change and don't change
current/future interfaces.

There is no need to stop changes like this.

>=20
> Eg, the gross thing Christoph points out about the QP type bitmap can
> probably go away in the new uAPI.

We are taking part in this new ABI effort and have full responsibility to
adapt our drivers (mlx4/mlx5) to new ABI whenever it comes.

>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIPIvAAoJEORje4g2clinzGMP/3+Qy/xRtjCv6HlXKkZxaXUj
G6VYb0jihDuZRgmCeqWIoIk1YHbWJwpMpD84mBu5mz6YuEuewl3X5xU39hsCLmOe
8MZnmlvQtkUGJR43mZMAalOOuCzPj4ymMmYWg1v2ViIib3ADyibbBnh4gpYPhMVB
EplhIqpofm7OkV6yi8pbRowJ/e0eL3eHx20Ru3pQiHNzW8CEa2RK7W9N1P6wIvbl
5xekfAbjmh7vL+XpO7ChASSWnjHZdia7nPYvhD9fWamAt1ErrXFd/reRiwtD+crI
JpD4DLQBZ3eyza6MfDAf03wXr7SGVi8qKDnTqXPOYH+azF2Z8gTyX+49GcWDY5xW
YZ/1oSkCNFHqPwohoevJJoKetEHBQXrGpE4vMbWFXHungmaqse4QT+yi1upYMUDA
qo8oKQy/GUs4Pa1VsfY7LNJTfYw3AHUYC7BySezm/T4FLsBoeXr92IEQ4xPPZDUs
Ru3scFmQl56MNfTH6huRcRy8NpWlTWxH3ZXnGipIIofU75ozpf1nYk87h0uBCvEh
MvdNoKEYMyyGhMm2eOgPo3SWrkhrm2Wuiq8Kdcn/+W0IWgYrIy7zqMvicXScw0oB
1WNUpVa51hKBF2vYL+hqyWwdEfdNNmmpUfSOSJGD57jaPjz+lKGT+WcU+hT32ZGx
o2JRW4fkk/BLHdlgc9Mj
=v7ZD
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
