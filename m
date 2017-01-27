From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] IB/cma: Fix reversed test
Date: Fri, 27 Jan 2017 21:31:55 +0000
Message-ID: <1485552696.13218.0.camel@sandisk.com>
References: <20170127131535.19918-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170127131535.19918-1-christophe.jaillet@wanadoo.fr>
Content-Language: en-US
Content-ID: <465F2579B5B9E74495C91E6DD310C9C8@sandisk.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-01-27 at 14:15 +0100, Christophe JAILLET wrote:
> This test looks reverted.
> We should log an error message only if 'ib_attach_mcast()' fails.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/infiniband/core/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.=
c
> index cfefb941d729..175f62e5841e 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -3838,7 +3838,7 @@ static int cma_ib_mc_handler(int status, struct ib_=
sa_multicast *multicast)
>  	if (!status && id_priv->id.qp) {
>  		status =3D ib_attach_mcast(id_priv->id.qp, &multicast->rec.mgid,
>  					 be16_to_cpu(multicast->rec.mlid));
> -		if (!status)
> +		if (status)
>  			pr_debug_ratelimited("RDMA CM: MULTICAST_ERROR: failed to attach QP. =
status %d\n",
>  					     status);
>  	}

Hello Christophe,

Do you think this patch needs "Fixes:" and "Cc: stable" tags?

Thanks,

Bart.=
