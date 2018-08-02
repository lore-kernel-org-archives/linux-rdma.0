From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [bug report] net/mlx5e: Gather all XDP pre-requisite checks in a
 single function
Date: Thu, 2 Aug 2018 15:31:58 +0300
Message-ID: <20180802123158.GM6123@mtr-leonro.mtl.com>
References: <20180802085449.hqlo6pqizuzbtliq@kili.mountain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AqCDj3hiknadvR6t"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180802085449.hqlo6pqizuzbtliq@kili.mountain>
Sender: netdev-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: tariqt@mellanox.com, linux-rdma@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--AqCDj3hiknadvR6t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

+netdev and Saeed

On Thu, Aug 02, 2018 at 11:54:49AM +0300, Dan Carpenter wrote:
> Hello Tariq Toukan,
>
> The patch 0ec13877ce95: "net/mlx5e: Gather all XDP pre-requisite
> checks in a single function" from Mar 12, 2018, leads to the
> following Smatch warning:
>
> 	drivers/net/ethernet/mellanox/mlx5/core/en_main.c:4284 mlx5e_xdp_set()
> 	error: uninitialized symbol 'err'.
>
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>   4214  static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
>   4215  {
>   4216          struct mlx5e_priv *priv = netdev_priv(netdev);
>   4217          struct bpf_prog *old_prog;
>   4218          bool reset, was_opened;
>   4219          int err;
>                 ^^^^^^^
> I always encourage people to remove unneeded initializers so that GCC
> can detect uninitialized variables, but it turns out that GCC misses a
> bunch of bugs?
>
>   4220          int i;
>   4221
>   4222          mutex_lock(&priv->state_lock);
>   4223
>   4224          if (prog) {
>   4225                  err = mlx5e_xdp_allowed(priv, prog);
>   4226                  if (err)
>   4227                          goto unlock;
>   4228          }
>   4229
>   4230          was_opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
>   4231          /* no need for full reset when exchanging programs */
>   4232          reset = (!priv->channels.params.xdp_prog || !prog);
>   4233
>   4234          if (was_opened && reset)
>   4235                  mlx5e_close_locked(netdev);
>   4236          if (was_opened && !reset) {
>   4237                  /* num_channels is invariant here, so we can take the
>   4238                   * batched reference right upfront.
>   4239                   */
>   4240                  prog = bpf_prog_add(prog, priv->channels.num);
>   4241                  if (IS_ERR(prog)) {
>   4242                          err = PTR_ERR(prog);
>   4243                          goto unlock;
>   4244                  }
>   4245          }
>   4246
>   4247          /* exchange programs, extra prog reference we got from caller
>   4248           * as long as we don't fail from this point onwards.
>   4249           */
>   4250          old_prog = xchg(&priv->channels.params.xdp_prog, prog);
>   4251          if (old_prog)
>   4252                  bpf_prog_put(old_prog);
>   4253
>   4254          if (reset) /* change RQ type according to priv->xdp_prog */
>   4255                  mlx5e_set_rq_type(priv->mdev, &priv->channels.params);
>   4256
>   4257          if (was_opened && reset)
>   4258                  mlx5e_open_locked(netdev);
>   4259
>   4260          if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
>   4261                  goto unlock;
>                         ^^^^^^^^^^^
> In the original code this was a success path.
>
>   4262
>   4263          /* exchanging programs w/o reset, we update ref counts on behalf
>   4264           * of the channels RQs here.
>   4265           */
>   4266          for (i = 0; i < priv->channels.num; i++) {
>   4267                  struct mlx5e_channel *c = priv->channels.c[i];
>   4268
>   4269                  clear_bit(MLX5E_RQ_STATE_ENABLED, &c->rq.state);
>   4270                  napi_synchronize(&c->napi);
>   4271                  /* prevent mlx5e_poll_rx_cq from accessing rq->xdp_prog */
>   4272
>   4273                  old_prog = xchg(&c->rq.xdp_prog, prog);
>   4274
>   4275                  set_bit(MLX5E_RQ_STATE_ENABLED, &c->rq.state);
>   4276                  /* napi_schedule in case we have missed anything */
>   4277                  napi_schedule(&c->napi);
>   4278
>   4279                  if (old_prog)
>   4280                          bpf_prog_put(old_prog);
>   4281          }
>   4282
>   4283  unlock:
>   4284          mutex_unlock(&priv->state_lock);
>   4285          return err;
>                 ^^^^^^^^^^
>   4286  }
>
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--AqCDj3hiknadvR6t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbYvm+AAoJEORje4g2clin9EIP/RjgFTPSEruQ15w0F68ta7nN
1LxD6Fc8rzZ4raPq/+jn5qVDzV33MV9doAeTEesxqYtB140k9zf+teSXADzW2eSV
gLaGqCdJnSE1qjMcAmNjyYDwvXJ3myIeN79qxLNXWXePJL7fEf+c8hdkB40MOYxC
nBxT+NIZQU+TlSATJvq9vV40XW0uRQBmkNV6S+DSpQRrd4AGKNctHUr2RApG04o3
Zo2x9V09p5MCvkL9Ykt3np2+7X9cb394uEd728ty8zzC3nlE0afJYKT+gaKk5641
uMD49o7C2KEcb1gBpuU0Te+qfS3Q/BlRIRl1nr3rnSMJzazzccNe+0QwD7/rIct1
hnNpIXEaUDz8+fKtP10f2seg3kJtYButvYgR0PSVFDMcQ6LP0NFVDgseh2qsaMy1
OAeD53/Savqgijm9kRLj7Qmtwaq8dJzk2gOoCyjLzLzNTwD4znVpz3itKWuaNfge
+NiEmE2FoU4+rpQ5QTcUQoTPP/X1p5ZnCMCKoVU6ranPVqY2CRuc1sxJdcpYj60b
xxmB+Kk8CwRjwTmMWSHKzUA7tVvBkMexdEAbtbcpHeq4fQHK8jGgkt8XH6HXB3ou
ngslF+2WYe48J1SD+cAX9aUeJ0JZcVh6eFZjZw8kGtoM2ETewMmvGRy9+97SyNF3
aqmi7ZtEYqaw6Z34aac3
=M76Z
-----END PGP SIGNATURE-----

--AqCDj3hiknadvR6t--
