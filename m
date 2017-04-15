From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 04/20] IB/core: For multicast functions, verify that LIDs
 are multicast LIDs
Date: Sat, 15 Apr 2017 18:01:46 +0300
Message-ID: <20170415150146.GN1343@mtr-leonro.local>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
 <20170409171549.10579.98819.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mI5TpPl/qDRoXxBg"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170409171549.10579.98819.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
List-Id: linux-rdma@vger.kernel.org


--mI5TpPl/qDRoXxBg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 09, 2017 at 10:15:51AM -0700, Dennis Dalessandro wrote:
> From: Michael J. Ruhl <michael.j.ruhl@intel.com>
>
> The Infiniband spec defines "A multicast address is defined by a
> MGID and a MLID" (section 10.5).  Currently the MLID value is not
> validated.
>
> Add check to verify that the MLID value is in the correct address
> range.
>
> Fixes: 0c33aeedb2cf ("[IB] Add checks to multicast attach and detach")
> Cc: stable@vger.kernel.org
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
> Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> ---
>  drivers/infiniband/core/verbs.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--mI5TpPl/qDRoXxBg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljyNdoACgkQ5GN7iDZy
WKcTtA//ZlJ+g+YVhB0UaZj4RCE/Hm3YePLZE2066cQvYdLQ3QWIYSA+s1M+cvwv
Gi1EJcXO61VEId3Qdp9NcTLsVdmoWiik/3Nh4ijrWa+dWpeTEYljWFMLK5hd+zdw
2vCwB/sqH4eDdr8o2DeiuwJCtfzpKSuHbx+jp9LzTv6HjpNgcDgyJJVbrrzQ5Cfu
4emeFGcN49ivkBMgBRMvDDwtUZzu+AIknUO6KqR5NTEWVWyVENqk+YVjN8klYPUW
ut+w2DZr1PsrJDbaMPpWZO3HnGCmSP4cb7YmqArBBQZhU7wTu1FG0n/otDyUuaVO
NRmRLiX8d421TvTx9wlen8thxKdpC2lx0O06vzy2B4IliMHr938iKDUJ+j8vE2NO
iX+l8LtPhb52irSwKiNujtfru4WZsNmLXFq4PwXtwaiu4sAEaRzJjt+0XUNbMqZx
LZpmjYXxzDLzj9Pi1A0zhLYDblh7eGxjQN60E6FZGprpHaxF/dNCwPUxQFl/ABH4
3rVEHAlhN0q88oH3+Rg+lVK8mnwJ8fQGlQM8OgRehOEMbB73STiyaVASIvNcUC0M
5ijeStBKDDi02e7Zx+dqcLmUnZvkZjmo79V2LtCJYNzlBVAcu8tsu0xh+uR/k4k5
QvsOUsc5DwBFiaQa/FSvXdllrkb9wInQAiXhjK2+Nv8/91h3gRA=
=sFI7
-----END PGP SIGNATURE-----

--mI5TpPl/qDRoXxBg--
