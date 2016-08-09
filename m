From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock
 held
Date: Tue, 9 Aug 2016 21:11:46 +0300
Message-ID: <20160809181146.GE23921@leon.nu>
References: <1470755786-14054-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470755786-14054-1-git-send-email-ira.weiny@intel.com>
Sender: stable-owner@vger.kernel.org
To: ira.weiny@intel.com
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 09, 2016 at 11:16:26AM -0400, ira.weiny@intel.com wrote:
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
>=20
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> CC: <stable@vger.kernel.org> # 4.6.x-
> ---
>  drivers/infiniband/hw/hfi1/debugfs.c    | 17 ++++++++++++-----
>  drivers/infiniband/hw/hfi1/qp.c         |  4 ----
>  drivers/infiniband/hw/qib/qib_debugfs.c | 16 ++++++++++++----
>  drivers/infiniband/hw/qib/qib_qp.c      |  4 ----
>  4 files changed, 24 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw=
/hfi1/debugfs.c
> index dbab9d9cc288..c35bef8dd5aa 100644
> --- a/drivers/infiniband/hw/hfi1/debugfs.c
> +++ b/drivers/infiniband/hw/hfi1/debugfs.c
> @@ -223,28 +223,35 @@ DEBUGFS_SEQ_FILE_OPEN(ctx_stats)
>  DEBUGFS_FILE_OPS(ctx_stats);
> =20
>  static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
> -__acquires(RCU)
> +	__acquires(RCU)
>  {
>  	struct qp_iter *iter;
>  	loff_t n =3D *pos;
> =20
> -	rcu_read_lock();
>  	iter =3D qp_iter_init(s->private);
> +
> +	/* stop calls rcu_read_unlock */
> +	rcu_read_lock();

IMHO, it should be placed after your if(!iter) check below.

> +
>  	if (!iter)
>  		return NULL;
> =20
> -	while (n--) {
> +	if (qp_iter_next(iter)) {
> +		kfree(iter);
> +		return NULL;
> +	}
> +	while (n--)
>  		if (qp_iter_next(iter)) {
>  			kfree(iter);
>  			return NULL;
>  		}

It looks like you forgot to remove the lines above.

> -	}
> =20
>  	return iter;
>  }
> =20
>  static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
>  				loff_t *pos)
> +	__must_hold(RCU)
>  {
>  	struct qp_iter *iter =3D iter_ptr;
> =20
> @@ -259,7 +266,7 @@ static void *_qp_stats_seq_next(struct seq_file *s, v=
oid *iter_ptr,
>  }
> =20
>  static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
> -__releases(RCU)
> +	__releases(RCU)
>  {
>  	rcu_read_unlock();
>  }
> diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1=
/qp.c
> index a5aa3517e7d5..4e4d8317c281 100644
> --- a/drivers/infiniband/hw/hfi1/qp.c
> +++ b/drivers/infiniband/hw/hfi1/qp.c
> @@ -656,10 +656,6 @@ struct qp_iter *qp_iter_init(struct hfi1_ibdev *dev)
> =20
>  	iter->dev =3D dev;
>  	iter->specials =3D dev->rdi.ibdev.phys_port_cnt * 2;
> -	if (qp_iter_next(iter)) {
> -		kfree(iter);
> -		return NULL;
> -	}
> =20
>  	return iter;
>  }
> diff --git a/drivers/infiniband/hw/qib/qib_debugfs.c b/drivers/infiniband=
/hw/qib/qib_debugfs.c
> index 5e75b43c596b..07059c08c170 100644
> --- a/drivers/infiniband/hw/qib/qib_debugfs.c
> +++ b/drivers/infiniband/hw/qib/qib_debugfs.c
> @@ -189,27 +189,34 @@ static int _ctx_stats_seq_show(struct seq_file *s, =
void *v)
>  DEBUGFS_FILE(ctx_stats)
> =20
>  static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
> +	__acquires(RCU)
>  {
>  	struct qib_qp_iter *iter;
>  	loff_t n =3D *pos;
> =20
> -	rcu_read_lock();
>  	iter =3D qib_qp_iter_init(s->private);
> +
> +	/* stop calls rcu_read_unlock */
> +	rcu_read_lock();
> +

The same

>  	if (!iter)
>  		return NULL;
> =20
> -	while (n--) {
> +	if (qib_qp_iter_next(iter)) {
> +		kfree(iter);
> +		return NULL;
> +	}
> +	while (n--)
>  		if (qib_qp_iter_next(iter)) {
>  			kfree(iter);
>  			return NULL;
>  		}
> -	}
> -

The same

>  	return iter;
>  }
> =20
>  static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
>  				   loff_t *pos)
> +	__must_hold(RCU)
>  {
>  	struct qib_qp_iter *iter =3D iter_ptr;
> =20
> @@ -224,6 +231,7 @@ static void *_qp_stats_seq_next(struct seq_file *s, v=
oid *iter_ptr,
>  }
> =20
>  static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
> +	__releases(RCU)
>  {
>  	rcu_read_unlock();
>  }
> diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/q=
ib/qib_qp.c
> index 9cc0aae1d781..f9b8cd2354d1 100644
> --- a/drivers/infiniband/hw/qib/qib_qp.c
> +++ b/drivers/infiniband/hw/qib/qib_qp.c
> @@ -573,10 +573,6 @@ struct qib_qp_iter *qib_qp_iter_init(struct qib_ibde=
v *dev)
>  		return NULL;
> =20
>  	iter->dev =3D dev;
> -	if (qib_qp_iter_next(iter)) {
> -		kfree(iter);
> -		return NULL;
> -	}
> =20
>  	return iter;
>  }
> --=20
> 1.8.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqhziAAoJEORje4g2clinV3wP+QERhoFmWiR50VKhALlIaCOS
sgya2+IEHEevMk56iADl19PwbKUlFthHmJCJo4zdMwj+zzX1hjYV2On+aUboYVTc
EylMVNaL0zT7FR9FGG2UAnXznE6yBxvf36w0bKTXpaj4WXOym8WQjXKAq/0kNDKX
jMm67ebYNWkxOeFVAMyn6KlVuv2apTwQKGP31nnwqlN6afWP43FonhGDmF22Yih2
kf8WUgcrwzFEX2rXv13SP55zsRPe+IKIcURGFsUtOt8ecEPaYRoS4TtNw/gmqukd
bnKkDNdDwllumn6QSEm6nnNHJylH6P4mqzKY3OemCtpr/2ZjNEPjcYynpEtFJGEs
Xs8NHO4rJmvRBbqbHJhOK7R3P1AdZzSlXxGY+lPLBq8USJWrkHcUXAeLK3JMASQw
qHOgaMZZzJU69Iti5MlBhFdDZ8des5LrdfQKFBf1trmn4jiqJj5vUTMhOl7Ixlxf
/PZpzkIq7191oHOOVcR2a+44/VWD3zqNPTMhJUN91cSBVE2mqJsgapHrOtPOFQqK
WsPziY5EsojGiKv7hyDy0587DfD67GGtLUEue+O/sLHqyiPakvGqwz/LMCrMCyW3
b/N2Qwmo0NrL23dif+h/zhJXhPpqFnKpTAY8g++inN6CL2p1SRFRwOU7SNHOOzMi
IzOdqZW1M7epPAQN5zTp
=5JQn
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
