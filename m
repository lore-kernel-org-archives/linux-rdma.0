From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/2] mlx5_core: mlx5_ifc updates
Date: Mon, 18 Apr 2016 18:12:05 +0300
Message-ID: <20160418151205.GO6349@leon.nu>
References: <1460563864-22931-1-git-send-email-saeedm@mellanox.com>
 <CALzJLG__o56edSf__To-BM6jakuwP7zAAEEQH8LQNTKp-2LRDQ@mail.gmail.com>
 <20160415.172254.1148340547086083909.davem@davemloft.net>
Reply-To: <leon-2ukJVAZIZ/Y@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7gLe/sNPhR777EPF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160415.172254.1148340547086083909.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--7gLe/sNPhR777EPF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2016 at 05:22:54PM -0400, David Miller wrote:
> From: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Date: Fri, 15 Apr 2016 20:10:07 +0300
>=20
> > On Wed, Apr 13, 2016 at 7:11 PM, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> w=
rote:
> >> Hi Dave and Doug
> >>
> >> Changes form V0:
> >>         - 2nd patch commit message fixes.
> >>
> >> This series include mlx5_core updates for both net-next and rdma
> >> trees for 4.7 kernel cycle. This is the only shared code planned
> >> for 4.7 between rdma and net trees. Hopefully, this will prevent
> >> future conflicts when merging between ib-next and net-next once
> >> 4.7 cycle is over and merge window is opened.
> >>
> >> Both Mellanox rdma and net submissions will proceed once this series
> >> is applied into both trees.
> >>
> >> Future shared code will be sent to both maintainers as pull requests
> >> from Mellanox's kernel.org tree.
> >>
> >> We have included all the maintainers of respective drivers.
> >> Kindly review the change and let us know in case of any review comment=
s.
> >>
> >> Saeed Mahameed (1):
> >>   net/mlx5: Update mlx5_ifc hardware features
> >>
> >> Tariq Toukan (1):
> >>   net/mlx5: Fix mlx5 ifc cmd_hca_cap bad offsets
> >>
> >>  include/linux/mlx5/mlx5_ifc.h |  253 +++++++++++++++++++++++++++++---=
---------
> >>  1 files changed, 179 insertions(+), 74 deletions(-)
> >>
> >> --
> >=20
> > Hi Dave,
> >=20
> > This series is still in "Changes Requested" state in patchwork, but
> > there is nothing to change here.
> > I will be glad if you give it a shot, it is blocking all of our mlx5
> > activities for both net and rdma trees.
>=20
> Series applied, thanks.

Hi Doug,
Can you please take this patchset in addition to Dave? It will save
our list from many kbuild errors.

Thanks.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7gLe/sNPhR777EPF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXFPlFAAoJEORje4g2clinuHQP/ApFxgyfgYl0kLlShY1pQ5aM
ClOSXIQshzPdO/5cTed5ht2P+sbYPQXHxVaPu9UtUMThrGE5MOgMcV2utAnNfX0u
yUwmWGcYuCaoNsH8AO1O9rflHRM+dWRonQ0JdJ92Clhtc8ruznUS3AWoqs14XcIl
HFYe+2vT1IO2qte5ZKPZ37rYoDf8HJAOi83Aw9KllwA1pEJrXf9vYJn9lSMCFGUb
PK0FrJEHJ0B2AmY/OpjT0TpIBo9A3EQkgM7YV3FrpivhwU+9F0moIcSSAJsS7CnB
WqLiQyLzrgdar6d0BfydD8sFEEtFxrKxHJ1xfD+QLF9nNpvJ/24isWZ4CaI7IRQr
oAKXfLn70MLISNulXQhV/zRyFpu7xkhWs7/QeXX2x6+DxOyPD6B3dx/IB3Io3yDi
VNERIimCUdtsnjLJchRWeT5PFV5n9UMlZd3xdjPwoASfCQRCq2JkhniHgTJMpcLh
7zTzSFvOo+z6Xmev78yGXz0EpBwu5khoBpcQMgOqnDEE3c5yhxSzkol0nrR8zBE5
aPeTW65DP14Y6Hd2sotm2qY0HAQBJZMPRCiWjQ7JVan2SBCJVlEQOOTXPZonJLjn
qOqkl7AOMPM52DJztuZtaJMSq28VsuSucXqKa2Xe1hRYqKD3VXZO11pWJBbldSX7
9VCoDNZQungvCzgU0y5H
=xdOj
-----END PGP SIGNATURE-----

--7gLe/sNPhR777EPF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
