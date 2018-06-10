From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Sun, 10 Jun 2018 09:30:28 +0300
Message-ID: <20180610063028.GH12407@mtr-leonro.mtl.com>
References: <20180608174218.32455-1-willy@infradead.org>
 <20180608174218.32455-3-willy@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YToU2i3Vx8H2dn7O"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180608174218.32455-3-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--YToU2i3Vx8H2dn7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 08, 2018 at 10:42:18AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
>
> Allocate agent IDs from a global IDR instead of an atomic variable.
> This eliminates the possibility of reusing an ID which is already in
> use after 4 billion registrations, and we can also limit the assigned
> ID to be less than 2^24, which fixes a bug in the mlx4 device.
>
> We look up the agent under protection of the RCU lock, which means we
> have to free the agent using kfree_rcu, and only increment the reference
> counter if it is not 0.
>
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---
>  drivers/infiniband/core/mad.c      | 78 ++++++++++++++++++------------
>  drivers/infiniband/core/mad_priv.h |  7 +--
>  include/linux/idr.h                |  9 ++++
>  3 files changed, 59 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 68f4dda916c8..62384a3dd3ec 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -38,6 +38,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>  #include <linux/dma-mapping.h>
> +#include <linux/idr.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/security.h>
> @@ -58,8 +59,8 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests
>  module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
>  MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
>
> +static DEFINE_IDR(ib_mad_clients);
>  static struct list_head ib_mad_port_list;
> -static atomic_t ib_mad_client_id = ATOMIC_INIT(0);
>
>  /* Port list lock */
>  static DEFINE_SPINLOCK(ib_mad_port_list_lock);
> @@ -377,13 +378,24 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
>  		goto error4;
>  	}
>
> -	spin_lock_irq(&port_priv->reg_lock);
> -	mad_agent_priv->agent.hi_tid = atomic_inc_return(&ib_mad_client_id);
> +	idr_preload(GFP_KERNEL);
> +	idr_lock(&ib_mad_clients);
> +	ret2 = idr_alloc_cyclic(&ib_mad_clients, mad_agent_priv, 0,
> +			(1 << 24), GFP_ATOMIC);

Hi Matthew,

Thank you for looking on that, I have a couple of comments to the proposed patch.

1. IBTA spec doesn't talk at all about the size of TransactionID, more
on that in section "13.4.6.4 TRANSACTION ID USAGE", the specification
says: "The contents of the TransactionID (TID) field are implementation-
dependent. So let's don't call it mlx4 bug.

2. The current implementation means that in mlx5-only network we will
still have upto (1 << 24) TIDs. I don't know if it is really important,
but worth to mention.

Thanks

--YToU2i3Vx8H2dn7O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbHMWEAAoJEORje4g2clinUWoP/3apYwBEyq7kmWfLOrzmL/T3
2iaHTOY5KC3TsbVLQAUoE7UDqzvxJU3a1DBhPqHbTw8AuF7/kFEZZNmiDV3Onjeo
ru1lxCjFpClpI681OqZYEFv4eWM0JS5K2uXxb3Rr5xiE4X4iJuCJj1DonuWG0/EZ
JMrqkdsBieYaNmodabGkSoBa3mbSUhjb4JMQKwq0HcLcWmaKdxRY8j3i0wfQoVZj
p69dCCMYfCoXUuEjuWq4+JYMXCMqxiLtShsnEqonqKod6yJ9yGt6oen9c/ETd8Jo
ReQ16nZ+D2ZyJMjOWW17cwyQP2K5v0O8hGPiVHTkjtDtBcgjJf1pKl5pDU/g7g8T
9st7GEqPekkujWeed+59AIR5rSi7lsFS74yhmeScYraa0rtXLb+Gm/aBFEbJyxpG
BEwCaALp4N/UQ+PuHmix7PB4FqxFKcvb4UIBOOcDbK9bzy0ga55tJidbVuOi6b3T
GThL5mXM/gtbmj5qBT8JEE9xz4hRpD8x2uZGfRfIHIx7bqKk4U7ykqCl9hdm+EF3
hKrZSuDzfopljThxx4c4c4Ez7sE9VBvAJ9MdiEnUFp4m10MEsoP4xgkFzVK7JNuj
jUz5jyxFp1oPjHMgHqO9p1QCBTMclekggDloskdWzwZNFLm0DY2IGMUP7Ze14Ihs
5rO09A/00Oq6esO10qDk
=RXCl
-----END PGP SIGNATURE-----

--YToU2i3Vx8H2dn7O--
