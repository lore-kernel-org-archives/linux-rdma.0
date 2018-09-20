From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 02/25] net/mlx5: Set uid as part of QP commands
Date: Thu, 20 Sep 2018 07:51:27 +0300
Message-ID: <20180920045127.GC3519@mtr-leonro.mtl.com>
References: <20180917110418.18937-1-leon@kernel.org>
 <20180917110418.18937-3-leon@kernel.org>
 <20180919172731.GM11367@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180919172731.GM11367@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 19, 2018 at 11:27:31AM -0600, Jason Gunthorpe wrote:
> On Mon, Sep 17, 2018 at 02:03:55PM +0300, Leon Romanovsky wrote:
> > From: Yishai Hadas <yishaih@mellanox.com>
> >
> > Set uid as part of QP commands so that the firmware can manage the
> > QP object in a secured way.
> >
> > That will enable using a QP that was created by verbs application to
> > be used by the DEVX flow in case the uid is equal.
> >
> > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/net/ethernet/mellanox/mlx5/core/qp.c | 45 +++++++++++++++++-----------
> >  include/linux/mlx5/mlx5_ifc.h                | 22 +++++++-------
> >  include/linux/mlx5/qp.h                      |  1 +
> >  3 files changed, 39 insertions(+), 29 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
> > index 4ca07bfb6b14..04f72a1cdbcc 100644
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
> > @@ -240,6 +240,7 @@ int mlx5_core_create_qp(struct mlx5_core_dev *dev,
> >  	if (err)
> >  		return err;
> >
> > +	qp->uid = MLX5_GET(create_qp_in, in, uid);
> >  	qp->qpn = MLX5_GET(create_qp_out, out, qpn);
> >  	mlx5_core_dbg(dev, "qpn = 0x%x\n", qp->qpn);
> >
> > @@ -261,6 +262,7 @@ int mlx5_core_create_qp(struct mlx5_core_dev *dev,
> >  	memset(dout, 0, sizeof(dout));
> >  	MLX5_SET(destroy_qp_in, din, opcode, MLX5_CMD_OP_DESTROY_QP);
> >  	MLX5_SET(destroy_qp_in, din, qpn, qp->qpn);
> > +	MLX5_SET(destroy_qp_in, din, uid, qp->uid);
> >  	mlx5_cmd_exec(dev, din, sizeof(din), dout, sizeof(dout));
> >  	return err;
> >  }
> > @@ -320,6 +322,7 @@ int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
> >
> >  	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
> >  	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
> > +	MLX5_SET(destroy_qp_in, in, uid, qp->uid);
> >  	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
> >  	if (err)
> >  		return err;
> > @@ -373,7 +376,7 @@ static void mbox_free(struct mbox_info *mbox)
> >
> >  static int modify_qp_mbox_alloc(struct mlx5_core_dev *dev, u16 opcode, int qpn,
> >  				u32 opt_param_mask, void *qpc,
> > -				struct mbox_info *mbox)
> > +				struct mbox_info *mbox, u16 uid)
> >  {
> >  	mbox->out = NULL;
> >  	mbox->in = NULL;
> > @@ -381,26 +384,32 @@ static int modify_qp_mbox_alloc(struct mlx5_core_dev *dev, u16 opcode, int qpn,
> >  #define MBOX_ALLOC(mbox, typ)  \
> >  	mbox_alloc(mbox, MLX5_ST_SZ_BYTES(typ##_in), MLX5_ST_SZ_BYTES(typ##_out))
> >
> > -#define MOD_QP_IN_SET(typ, in, _opcode, _qpn) \
> > -	MLX5_SET(typ##_in, in, opcode, _opcode); \
> > -	MLX5_SET(typ##_in, in, qpn, _qpn)
> > -
> > -#define MOD_QP_IN_SET_QPC(typ, in, _opcode, _qpn, _opt_p, _qpc) \
> > -	MOD_QP_IN_SET(typ, in, _opcode, _qpn); \
> > -	MLX5_SET(typ##_in, in, opt_param_mask, _opt_p); \
> > -	memcpy(MLX5_ADDR_OF(typ##_in, in, qpc), _qpc, MLX5_ST_SZ_BYTES(qpc))
> > +#define MOD_QP_IN_SET(typ, in, _opcode, _qpn, _uid) \
> > +	do { \
> > +		MLX5_SET(typ##_in, in, opcode, _opcode); \
> > +		MLX5_SET(typ##_in, in, qpn, _qpn); \
> > +		MLX5_SET(typ##_in, in, uid, _uid); \
> > +	} while (0)
> > +
> > +#define MOD_QP_IN_SET_QPC(typ, in, _opcode, _qpn, _opt_p, _qpc, _uid) \
> > +	do { \
> > +		MOD_QP_IN_SET(typ, in, _opcode, _qpn, _uid); \
> > +		MLX5_SET(typ##_in, in, opt_param_mask, _opt_p); \
> > +		memcpy(MLX5_ADDR_OF(typ##_in, in, qpc), \
> > +		       _qpc, MLX5_ST_SZ_BYTES(qpc)); \
> > +	} while (0)
>
> These should get touched by clang-format to follow the usual
> formatting for macros..

Thanks, we will do.

>
> Jason

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJboydPAAoJEORje4g2clincdIP/2NawU9Ni/xgmSLmSmuGMD9D
gvFpLXHqZfWkg7B7H3dLhA0HzQYhawklSM0n7PpALg97tJuPjvSzOePgtea2lQSp
uRJGJLMInY+/QWhqlopNxKHBfKIFu6n3/KkYBzEuV7rqfF1/1MZIsO8dg2tOh8vz
46Ok1bRzBD/LIlbQcITmfc2j2b3q00g7U9db1uAou8ZLu62Z1DSaCPv4JpRKgZFn
54pohFFBfuVk05cTsau6kX/6I0yC0CVrK7cMPkyD5EC0Twaqv3aptOWoML7y3xhD
CNi0rnzNW+trs7PN2gIHV5xciIe3A9BxGhzxaxm2gyv3FR63PvG9M8APhG0tOV/6
WnTg0vzllPImE6kYW7bMI8OAE5thmL+FgqFsdVExp09BNI5u2kr/rdDBcwpzto6Z
oKQ7txtGshG+OZbOKX9QEUEG7QWWUCdyRcBrNpMJGtvHxfmj9BsCRPpZH1ZgqgHa
i5jIdvs4EI2yPGR96mQEb+0k/7iZkZsLaO/15d8N8VOLY0dNCx/aUP4xHxwivqRl
q8WQWNBWHRmD+rFD/xLC4xWkRIKMF1/Uj1av8LrW1nvcMAAIkUpEG4djH/Bart9t
MbZRTVHNeGXwYsCQWDAvQCwOVOsmJYI+WLFGUREadY9u2K5HZ1pNY7IoynSuo6CV
X0ZTjwaEWCPgM9tiigyF
=WpQp
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
