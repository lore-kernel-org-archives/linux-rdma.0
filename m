From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH V2] IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock
 held
Date: Sun, 14 Aug 2016 11:55:11 +0300
Message-ID: <20160814085511.GB21270@leon.nu>
References: <1471015057-9886-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471015057-9886-1-git-send-email-ira.weiny@intel.com>
Sender: stable-owner@vger.kernel.org
To: ira.weiny@intel.com
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 12, 2016 at 11:17:37AM -0400, ira.weiny@intel.com wrote:
> From: Mike Marciniszyn <mike.marciniszyn@intel.com>
>=20
> The qp init function does a kzalloc() while holding the RCU
> lock that encounters the following warning with a debug kernel
> when a cat of the qp_stats is done:
>=20
> [  231.723948] rcu_scheduler_active =3D 1, debug_locks =3D 0
> [  231.731939] 3 locks held by cat/11355:
> [  231.736492]  #0:  (debugfs_srcu){......}, at: [<ffffffff813001a5>] deb=
ugfs_use_file_start+0x5/0x90
> [  231.746955]  #1:  (&p->lock){+.+.+.}, at: [<ffffffff81289a6c>] seq_rea=
d+0x4c/0x3c0
> [  231.755873]  #2:  (rcu_read_lock){......}, at: [<ffffffffa0a0c535>] _q=
p_stats_seq_start+0x5/0xd0 [hfi1]
> [  231.766862]
>=20
> The init functions do an implicit next which requires the rcu read lock
> before the kzalloc().
>=20
> Fix for both drivers is to change the scope of the init function to only
> do the allocation and the initialization of the just allocated iter.
>=20
> The implict next is moved back into the respective start functions to fix
> the issue.
>=20
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> CC: <stable@vger.kernel.org> # 4.6.x-
>=20
> ---
> Changes from V1:
> 	use do.. while loop to execute first iter call.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXsDHvAAoJEORje4g2clin+c0P/0pqfQaNygCQPADgNo4jfZiq
vWD9vcxu+qBNEpjpt7ZQzTRtgwp+7mOTYKedlMUoJo2eQkF2Cz/WdtgllPNCLUil
Ubb+cX9ywRftHHYOIAQyNxGTHIvcNagwT/QhP+pE/IPqpctk/CJxqEiaPpF/NLaS
CM83Rclfa8Jr08fYSmMi/0QMS2fTKGe1UD0L6/2PnjuHEPE8ONYn1LMn7Drvg4gz
gq4rTETdWzx3u7qd7E5VckOrXTUe8ulNaB7DhnmqPePIvFKTtYGnk1Ahy1NbfCnb
CTD+uI9TvZaatZNigpaP+6AVVzHlqZUaFxyftyNQdLmlTh1haDACCl97b5YoJhnp
sKD1JBbtfpKIa81J4OcgpGe2ccuBBdGSZIQn1q1H+ouThGaNrPMc8bsJG+prUPm5
eWYQ6lXf1ro7LzdVXnNGSbsTfJspPLIr3cN5ViwHksieyb6ErqRqMjm9ZSm4yRjj
Qju1xstM7bhMfewafJki3WVU2lVRmLSxVPQKqpqTObVZoVj4cS1vjtHUk4upplfq
uodPg8H1ixLYdVoy6n6GWNxSHLkvnqks4HqoV1BThWaIdcDRzLtwGm0SG+XX46cS
/OSIscuKLgCzm/BiXdPQ+6BaaDfIjyq9JGgwvPc+AJSamoNT12uAYGhubPD8A4df
Gi9a/7nrzY1eCr7XF6rs
=SBUl
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
