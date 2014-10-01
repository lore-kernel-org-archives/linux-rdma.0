From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 4/9] IB/core: Infrastructure to manage peer
 core context
Date: Thu, 02 Oct 2014 00:24:21 +0200
Message-ID: <1412202261.28184.0.camel@localhost.localdomain>
References: <1412176717-11979-1-git-send-email-yishaih@mellanox.com>
	 <1412176717-11979-5-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412176717-11979-5-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Le mercredi 01 octobre 2014 =C3=A0 18:18 +0300, Yishai Hadas a =C3=A9cr=
it :
> Adds an infrastructure to manage core context for a given umem,
> it's needed for the invalidation flow.
>=20
> Core context is supplied to peer clients as some opaque data for a gi=
ven
> memory pages represented by a umem.
>=20
> If the peer client needs to invalidate memory it provided through the=
 peer memory callbacks,
> it should call the invalidation callback, supplying the relevant core=
 context.
> IB core will use this context to invalidate the relevant memory.
>=20
> To prevent cases when there are inflight invalidation calls in parall=
el
> to releasing this memory (e.g. by dereg_mr) we must ensure that conte=
xt
> is valid before accessing it, that's why couldn't use the core contex=
t
> pointer directly. For that reason we added a lookup table to map betw=
een
> a ticket id to a core context.

You could have use the context pointer as the key, instead of creating
the "ticket" abstraction. The context pointer can be looked up in a dat=
a
structure which track the current contexts.

But I'm not sure to understand the purpose of the indirection:
if dereg_mr() can release the context in parallel,
is the context pointer stored in the "ticket" going to point to
something no more valid ?

>  Peer client will get/supply the ticket
> id, core will check whether exists before accessing its corresponding
> context.
>=20

Could you explain the expected lifetime of the ticket id and whether it
will be exchanged with "remote" parties (remote node, hardware,
userspace, etc.)

> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/peer_mem.c |  132 ++++++++++++++++++++++++++=
++++++++++
>  include/rdma/ib_peer_mem.h         |   19 +++++
>  include/rdma/ib_umem.h             |    6 ++
>  3 files changed, 157 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/peer_mem.c b/drivers/infiniband/=
core/peer_mem.c
> index 3936e13..ad10672 100644
> --- a/drivers/infiniband/core/peer_mem.c
> +++ b/drivers/infiniband/core/peer_mem.c
> @@ -44,6 +44,136 @@ static int ib_invalidate_peer_memory(void *reg_ha=
ndle, void *core_context)
>  	return -ENOSYS;
>  }
> =20
> +static int peer_ticket_exists(struct ib_peer_memory_client *ib_peer_=
client,
> +			      unsigned long ticket)
> +{
> +	struct core_ticket *core_ticket;
> +
> +	list_for_each_entry(core_ticket, &ib_peer_client->core_ticket_list,
> +			    ticket_list) {
> +		if (core_ticket->key =3D=3D ticket)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int peer_get_free_ticket(struct ib_peer_memory_client *ib_pee=
r_client,
> +				unsigned long *new_ticket)
> +{
> +	unsigned long candidate_ticket =3D ib_peer_client->last_ticket + 1;

Overflow ?

> +	static int max_retries =3D 1000;

It's no static, and why 1000 ?

> +	int i;
> +
> +	for (i =3D 0; i < max_retries; i++) {
> +		if (peer_ticket_exists(ib_peer_client, candidate_ticket)) {
> +			candidate_ticket++;

Overflow ?

> +			continue;
> +		}
> +		*new_ticket =3D candidate_ticket;
> +		return 0;
> +	}
> +

Counting the number of allocated ticket number could prevent looping in
the case every numbers are used (unlikely).

> +	return -EINVAL;
> +}
> +

> +static int ib_peer_insert_context(struct ib_peer_memory_client *ib_p=
eer_client,
> +				  void *context,
> +				  unsigned long *context_ticket)
> +{
> +	struct core_ticket *core_ticket =3D kzalloc(sizeof(*core_ticket), G=
=46P_KERNEL);
> +	int ret;
> +
> +	if (!core_ticket)
> +		return -ENOMEM;
> +
> +	mutex_lock(&ib_peer_client->lock);
> +	if (ib_peer_client->last_ticket < ib_peer_client->last_ticket + 1 &=
&
> +	    !ib_peer_client->ticket_wrapped) {
> +		core_ticket->key =3D ib_peer_client->last_ticket++;
> +	} else {
> +		/* special/rare case when wrap around occurred, not expected on 64=
 bit machines */

Some still have 32bits system ...

> +		unsigned long new_ticket;
> +
> +		ib_peer_client->ticket_wrapped =3D 1;

The whole mechanism to handle wrapping seems fragile, at best.
Wrapping could happen multiple times by the way.

Additionally, it would make more sense to have ticket number handling i=
n
peer_get_free_ticket().

> +		ret =3D peer_get_free_ticket(ib_peer_client, &new_ticket);
> +		if (ret) {
> +			mutex_unlock(&ib_peer_client->lock);
> +			kfree(core_ticket);
> +			return ret;
> +		}
> +		ib_peer_client->last_ticket =3D new_ticket;
> +		core_ticket->key =3D ib_peer_client->last_ticket;
> +	}
> +	core_ticket->context =3D context;
> +	list_add_tail(&core_ticket->ticket_list,
> +		      &ib_peer_client->core_ticket_list);
> +	*context_ticket =3D core_ticket->key;
> +	mutex_unlock(&ib_peer_client->lock);
> +	return 0;
> +}
> +

Perhaps idr could be used to track the "ticket" number ?

> +/* Caller should be holding the peer client lock, specifically, the =
caller should hold ib_peer_client->lock */
> +static int ib_peer_remove_context(struct ib_peer_memory_client *ib_p=
eer_client,
> +				  unsigned long key)
> +{
> +	struct core_ticket *core_ticket;
> +
> +	list_for_each_entry(core_ticket, &ib_peer_client->core_ticket_list,
> +			    ticket_list) {
> +		if (core_ticket->key =3D=3D key) {
> +			list_del(&core_ticket->ticket_list);
> +			kfree(core_ticket);
> +			return 0;
> +		}
> +	}
> +
> +	return 1;
> +}
> +
> +/**
> +** ib_peer_create_invalidation_ctx - creates invalidation context fo=
r a given umem
> +** @ib_peer_mem: peer client to be used
> +** @umem: umem struct belongs to that context
> +** @invalidation_ctx: output context
> +**/
> +int ib_peer_create_invalidation_ctx(struct ib_peer_memory_client *ib=
_peer_mem, struct ib_umem *umem,
> +				    struct invalidation_ctx **invalidation_ctx)
> +{
> +	int ret;
> +	struct invalidation_ctx *ctx;
> +
> +	ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	ret =3D ib_peer_insert_context(ib_peer_mem, ctx,
> +				     &ctx->context_ticket);
> +	if (ret) {
> +		kfree(ctx);
> +		return ret;
> +	}
> +
> +	ctx->umem =3D umem;
> +	umem->invalidation_ctx =3D ctx;
> +	*invalidation_ctx =3D ctx;
> +	return 0;
> +}
> +
> +/**
> + * ** ib_peer_destroy_invalidation_ctx - destroy a given invalidatio=
n context
> + * ** @ib_peer_mem: peer client to be used
> + * ** @invalidation_ctx: context to be invalidated
> + * **/
> +void ib_peer_destroy_invalidation_ctx(struct ib_peer_memory_client *=
ib_peer_mem,
> +				      struct invalidation_ctx *invalidation_ctx)
> +{
> +	mutex_lock(&ib_peer_mem->lock);
> +	ib_peer_remove_context(ib_peer_mem, invalidation_ctx->context_ticke=
t);
> +	mutex_unlock(&ib_peer_mem->lock);
> +
> +	kfree(invalidation_ctx);
> +}
>  static int ib_memory_peer_check_mandatory(const struct peer_memory_c=
lient
>  						     *peer_client)
>  {
> @@ -94,6 +224,8 @@ void *ib_register_peer_memory_client(const struct =
peer_memory_client *peer_clien
>  	if (!ib_peer_client)
>  		return NULL;
> =20
> +	INIT_LIST_HEAD(&ib_peer_client->core_ticket_list);
> +	mutex_init(&ib_peer_client->lock);
>  	init_completion(&ib_peer_client->unload_comp);
>  	kref_init(&ib_peer_client->ref);
>  	ib_peer_client->peer_mem =3D peer_client;
> diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
> index 98056c5..d3fbb50 100644
> --- a/include/rdma/ib_peer_mem.h
> +++ b/include/rdma/ib_peer_mem.h
> @@ -4,6 +4,8 @@
>  #include <rdma/peer_mem.h>
> =20
>  struct ib_ucontext;
> +struct ib_umem;
> +struct invalidation_ctx;
> =20
>  struct ib_peer_memory_client {
>  	const struct peer_memory_client *peer_mem;
> @@ -11,16 +13,33 @@ struct ib_peer_memory_client {
>  	int invalidation_required;
>  	struct kref ref;
>  	struct completion unload_comp;
> +	/* lock is used via the invalidation flow */
> +	struct mutex lock;
> +	struct list_head   core_ticket_list;
> +	unsigned long       last_ticket;
> +	int ticket_wrapped;
>  };
> =20
>  enum ib_peer_mem_flags {
>  	IB_PEER_MEM_ALLOW	=3D 1,
>  };
> =20
> +struct core_ticket {
> +	unsigned long key;
> +	void *context;
> +	struct list_head   ticket_list;
> +};
> +
>  struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext =
*context, unsigned long addr,
>  						 size_t size, void **peer_client_context);
> =20
>  void ib_put_peer_client(struct ib_peer_memory_client *ib_peer_client=
,
>  			void *peer_client_context);
> =20
> +int ib_peer_create_invalidation_ctx(struct ib_peer_memory_client *ib=
_peer_mem, struct ib_umem *umem,
> +				    struct invalidation_ctx **invalidation_ctx);
> +
> +void ib_peer_destroy_invalidation_ctx(struct ib_peer_memory_client *=
ib_peer_mem,
> +				      struct invalidation_ctx *invalidation_ctx);
> +
>  #endif
> diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
> index a22dde0..4b8a042 100644
> --- a/include/rdma/ib_umem.h
> +++ b/include/rdma/ib_umem.h
> @@ -40,6 +40,11 @@
> =20
>  struct ib_ucontext;
> =20
> +struct invalidation_ctx {
> +	struct ib_umem *umem;
> +	unsigned long context_ticket;
> +};
> +
>  struct ib_umem {
>  	struct ib_ucontext     *context;
>  	size_t			length;
> @@ -56,6 +61,7 @@ struct ib_umem {
>  	int             npages;
>  	/* peer memory that manages this umem */
>  	struct ib_peer_memory_client *ib_peer_mem;
> +	struct invalidation_ctx *invalidation_ctx;
>  	/* peer memory private context */
>  	void *peer_mem_client_context;
>  };



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
