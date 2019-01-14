From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH v2] RDMA/cma: Rollback source IP address if failing to
 acquire device
Date: Mon, 14 Jan 2019 22:20:38 +0000
Message-ID: <VI1PR0501MB2271F66D02209FA0327904A1D1800@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190110062727.GA25844@myunghoj-Precision-5530>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190110062727.GA25844@myunghoj-Precision-5530>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Myungho Jung <mhjungk@gmail.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Myungho Jung <mhjungk@gmail.com>
> Sent: Thursday, January 10, 2019 12:28 AM
> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe <jgg@ziepe.ca>;
> Parav Pandit <parav@mellanox.com>
> Cc: linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH v2] RDMA/cma: Rollback source IP address if failing to
> acquire device
>=20
> If cma_acquire_dev_by_src_ip() returns error in addr_handler(), the devic=
e
> state changes back to RDMA_CM_ADDR_BOUND but the resolved source IP
> address is still left. After that, if rdma_destroy_id() is called after
> rdma_listen(), the device is freed without removed from listen_any_list i=
n
> cma_cancel_operation(). Revert to the previous IP address if acquiring de=
vice
> fails.
>=20
> Reported-by: syzbot+f3ce716af730c8f96637@syzkaller.appspotmail.com
> Signed-off-by: Myungho Jung <mhjungk@gmail.com>
> ---
>  drivers/infiniband/core/cma.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.=
c
> index 63a7cc00bae0..8cd113b0ddfb 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -2963,13 +2963,22 @@ static void addr_handler(int status, struct
> sockaddr *src_addr,  {
>  	struct rdma_id_private *id_priv =3D context;
>  	struct rdma_cm_event event =3D {};
> +	struct sockaddr *addr;
> +	struct sockaddr_storage old_addr;
>=20
>  	mutex_lock(&id_priv->handler_mutex);
>  	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_QUERY,
>  			   RDMA_CM_ADDR_RESOLVED))
>  		goto out;
>=20
> -	memcpy(cma_src_addr(id_priv), src_addr,
> rdma_addr_size(src_addr));
> +	/*
> +	 * Store the previous src address, so that if we fail to acquire
> +	 * matching rdma device, old address can be restored back, which
> helps
> +	 * to cancel the cma listen operation correctly.
> +	 */
> +	addr =3D cma_src_addr(id_priv);
> +	memcpy(&old_addr, addr, rdma_addr_size(addr));
> +	memcpy(addr, src_addr, rdma_addr_size(src_addr));
>  	if (!status && !id_priv->cma_dev) {
>  		status =3D cma_acquire_dev_by_src_ip(id_priv);
>  		if (status)
> @@ -2980,6 +2989,8 @@ static void addr_handler(int status, struct sockadd=
r
> *src_addr,
>  	}
>=20
>  	if (status) {
> +		memcpy(addr, &old_addr,
> +		       rdma_addr_size((struct sockaddr *)&old_addr));
>  		if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED,
>  				   RDMA_CM_ADDR_BOUND))
>  			goto out;
> --
> 2.17.1
Reviewed-by: Parav Pandit <parav@mellanox.com>
