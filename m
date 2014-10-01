From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 5/9] IB/core: Invalidation support for peer
 memory
Date: Wed, 01 Oct 2014 18:25:04 +0200
Message-ID: <1412180704.4380.40.camel@localhost.localdomain>
References: <1412176717-11979-1-git-send-email-yishaih@mellanox.com>
	 <1412176717-11979-6-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412176717-11979-6-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le mercredi 01 octobre 2014 =C3=A0 18:18 +0300, Yishai Hadas a =C3=A9cr=
it :
> Adds the required functionality to invalidate a given peer
> memory represented by some core context.
>=20
> Each umem that was built over peer memory and supports invalidation h=
as
> some invalidation context assigned to it with the required data to
> manage, once peer will call the invalidation callback below actions a=
re
> taken:
>=20
> 1) Taking lock on peer client to sync with inflight dereg_mr on that
> memory.
> 2) Once lock is taken have a lookup for ticket id to find the matchin=
g
> core context.
> 3) In case found will call umem invalidation function, otherwise call=
 is
> returned.
>=20
> Some notes:
> 1) As peer invalidate callback defined to be blocking it must return
> just after that pages are not going to be accessed any more. For that
> reason ib_invalidate_peer_memory is waiting for a completion event in
> case there is other inflight call coming as part of dereg_mr.
>=20
> 2) The peer memory API assumes that a lock might be taken by a peer
> client to protect its memory operations. Specifically, its invalidate
> callback might be called under that lock which may lead to an AB/BA
> dead-lock in case IB core will call get/put pages APIs with the IB co=
re peer's lock taken,
> for that reason as part of  ib_umem_activate_invalidation_notifier lo=
ck is taken
> then checking for some inflight invalidation state before activating =
it.
>=20
> 3) Once a peer client admits as part of its registration that it may
> require invalidation support, it can't be an owner of a memory range
> which doesn't support it.
>=20
> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/peer_mem.c |   86 ++++++++++++++++++++++++++=
+++++++---
>  drivers/infiniband/core/umem.c     |   51 ++++++++++++++++++---
>  include/rdma/ib_peer_mem.h         |    4 +-
>  include/rdma/ib_umem.h             |   17 +++++++
>  4 files changed, 143 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/peer_mem.c b/drivers/infiniband/=
core/peer_mem.c
> index ad10672..d6bd192 100644
> --- a/drivers/infiniband/core/peer_mem.c
> +++ b/drivers/infiniband/core/peer_mem.c
> @@ -38,10 +38,57 @@ static DEFINE_MUTEX(peer_memory_mutex);
>  static LIST_HEAD(peer_memory_list);
>  static int num_registered_peers;
> =20
> -static int ib_invalidate_peer_memory(void *reg_handle, void *core_co=
ntext)
> +/* Caller should be holding the peer client lock, ib_peer_client->lo=
ck */
> +static struct core_ticket *ib_peer_search_context(struct ib_peer_mem=
ory_client *ib_peer_client,
> +						  unsigned long key)
> +{
> +	struct core_ticket *core_ticket;
> +
> +	list_for_each_entry(core_ticket, &ib_peer_client->core_ticket_list,
> +			    ticket_list) {
> +		if (core_ticket->key =3D=3D key)
> +			return core_ticket;
> +	}
> =20
> +	return NULL;
> +}
> +

You have now two functions to lookup key in ticket list:
see peer_ticket_exists().

> +static int ib_invalidate_peer_memory(void *reg_handle, void *core_co=
ntext)
>  {
> -	return -ENOSYS;
> +	struct ib_peer_memory_client *ib_peer_client =3D
> +		(struct ib_peer_memory_client *)reg_handle;
> +	struct invalidation_ctx *invalidation_ctx;
> +	struct core_ticket *core_ticket;
> +	int need_unlock =3D 1;
> +
> +	mutex_lock(&ib_peer_client->lock);
> +	core_ticket =3D ib_peer_search_context(ib_peer_client,
> +					     (unsigned long)core_context);
> +	if (!core_ticket)
> +		goto out;
> +
> +	invalidation_ctx =3D (struct invalidation_ctx *)core_ticket->contex=
t;
> +	/* If context is not ready yet, mark it to be invalidated */
> +	if (!invalidation_ctx->func) {
> +		invalidation_ctx->peer_invalidated =3D 1;
> +		goto out;
> +	}
> +	invalidation_ctx->func(invalidation_ctx->cookie,
> +					invalidation_ctx->umem, 0, 0);
> +	if (invalidation_ctx->inflight_invalidation) {
> +		/* init the completion to wait on before letting other thread to r=
un */
> +		init_completion(&invalidation_ctx->comp);
> +		mutex_unlock(&ib_peer_client->lock);
> +		need_unlock =3D 0;
> +		wait_for_completion(&invalidation_ctx->comp);
> +	}
> +
> +	kfree(invalidation_ctx);
> +out:
> +	if (need_unlock)
> +		mutex_unlock(&ib_peer_client->lock);
> +
> +	return 0;
>  }
> =20
>  static int peer_ticket_exists(struct ib_peer_memory_client *ib_peer_=
client,
> @@ -168,11 +215,30 @@ int ib_peer_create_invalidation_ctx(struct ib_p=
eer_memory_client *ib_peer_mem, s
>  void ib_peer_destroy_invalidation_ctx(struct ib_peer_memory_client *=
ib_peer_mem,
>  				      struct invalidation_ctx *invalidation_ctx)
>  {
> -	mutex_lock(&ib_peer_mem->lock);
> -	ib_peer_remove_context(ib_peer_mem, invalidation_ctx->context_ticke=
t);
> -	mutex_unlock(&ib_peer_mem->lock);
> +	int peer_callback;
> +	int inflight_invalidation;
> =20
> -	kfree(invalidation_ctx);
> +	/* If we are under peer callback lock was already taken.*/
> +	if (!invalidation_ctx->peer_callback)
> +		mutex_lock(&ib_peer_mem->lock);
> +	ib_peer_remove_context(ib_peer_mem, invalidation_ctx->context_ticke=
t);
> +	/* make sure to check inflight flag after took the lock and remove =
from tree.
> +	 * in addition, from that point using local variables for peer_call=
back and
> +	 * inflight_invalidation as after the complete invalidation_ctx can=
't be accessed
> +	 * any more as it may be freed by the callback.
> +	 */
> +	peer_callback =3D invalidation_ctx->peer_callback;
> +	inflight_invalidation =3D invalidation_ctx->inflight_invalidation;
> +	if (inflight_invalidation)
> +		complete(&invalidation_ctx->comp);
> +
> +	/* On peer callback lock is handled externally */
> +	if (!peer_callback)
> +		mutex_unlock(&ib_peer_mem->lock);
> +
> +	/* in case under callback context or callback is pending let it fre=
e the invalidation context */
> +	if (!peer_callback && !inflight_invalidation)
> +		kfree(invalidation_ctx);
>  }
>  static int ib_memory_peer_check_mandatory(const struct peer_memory_c=
lient
>  						     *peer_client)
> @@ -261,13 +327,19 @@ void ib_unregister_peer_memory_client(void *reg=
_handle)
>  EXPORT_SYMBOL(ib_unregister_peer_memory_client);
> =20
>  struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext =
*context, unsigned long addr,
> -						 size_t size, void **peer_client_context)
> +						 size_t size, unsigned long peer_mem_flags,
> +						 void **peer_client_context)
>  {
>  	struct ib_peer_memory_client *ib_peer_client;
>  	int ret;
> =20
>  	mutex_lock(&peer_memory_mutex);
>  	list_for_each_entry(ib_peer_client, &peer_memory_list, core_peer_li=
st) {
> +		/* In case peer requires invalidation it can't own memory which do=
esn't support it */
> +		if (ib_peer_client->invalidation_required &&
> +		    (!(peer_mem_flags & IB_PEER_MEM_INVAL_SUPP)))
> +			continue;
> +
>  		ret =3D ib_peer_client->peer_mem->acquire(addr, size,
>  						   context->peer_mem_private_data,
>  						   context->peer_mem_name,
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core=
/umem.c
> index 0de9916..51f32a1 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -44,12 +44,19 @@
> =20
>  static struct ib_umem *peer_umem_get(struct ib_peer_memory_client *i=
b_peer_mem,
>  				     struct ib_umem *umem, unsigned long addr,
> -				     int dmasync)
> +				     int dmasync, unsigned long peer_mem_flags)
>  {
>  	int ret;
>  	const struct peer_memory_client *peer_mem =3D ib_peer_mem->peer_mem=
;
> +	struct invalidation_ctx *invalidation_ctx =3D NULL;
> =20
>  	umem->ib_peer_mem =3D ib_peer_mem;
> +	if (peer_mem_flags & IB_PEER_MEM_INVAL_SUPP) {
> +		ret =3D ib_peer_create_invalidation_ctx(ib_peer_mem, umem, &invali=
dation_ctx);
> +		if (ret)
> +			goto end;
> +	}
> +
>  	/*
>  	 * We always request write permissions to the pages, to force break=
ing of any CoW
>  	 * during the registration of the MR. For read-only MRs we use the =
"force" flag to
> @@ -60,7 +67,9 @@ static struct ib_umem *peer_umem_get(struct ib_peer=
_memory_client *ib_peer_mem,
>  				  1, !umem->writable,
>  				  &umem->sg_head,
>  				  umem->peer_mem_client_context,
> -				  NULL);
> +				  invalidation_ctx ?
> +				  (void *)invalidation_ctx->context_ticket : NULL);
> +

NULL may be a valid "ticket" once converted to unsigned long and looked
up in the ticket list.

>  	if (ret)
>  		goto out;
> =20
> @@ -84,6 +93,9 @@ put_pages:
>  	peer_mem->put_pages(umem->peer_mem_client_context,
>  					&umem->sg_head);
>  out:
> +	if (invalidation_ctx)
> +		ib_peer_destroy_invalidation_ctx(ib_peer_mem, invalidation_ctx);
> +end:
>  	ib_put_peer_client(ib_peer_mem, umem->peer_mem_client_context);
>  	kfree(umem);
>  	return ERR_PTR(ret);
> @@ -91,15 +103,19 @@ out:
> =20
>  static void peer_umem_release(struct ib_umem *umem)
>  {
> -	const struct peer_memory_client *peer_mem =3D
> -				umem->ib_peer_mem->peer_mem;
> +	struct ib_peer_memory_client *ib_peer_mem =3D umem->ib_peer_mem;
> +	const struct peer_memory_client *peer_mem =3D ib_peer_mem->peer_mem=
;
> +	struct invalidation_ctx *invalidation_ctx =3D umem->invalidation_ct=
x;
> +
> +	if (invalidation_ctx)
> +		ib_peer_destroy_invalidation_ctx(ib_peer_mem, invalidation_ctx);
> =20
>  	peer_mem->dma_unmap(&umem->sg_head,
>  			    umem->peer_mem_client_context,
>  			    umem->context->device->dma_device);
>  	peer_mem->put_pages(&umem->sg_head,
>  			    umem->peer_mem_client_context);
> -	ib_put_peer_client(umem->ib_peer_mem, umem->peer_mem_client_context=
);
> +	ib_put_peer_client(ib_peer_mem, umem->peer_mem_client_context);
>  	kfree(umem);
>  }
> =20
> @@ -127,6 +143,27 @@ static void __ib_umem_release(struct ib_device *=
dev, struct ib_umem *umem, int d
> =20
>  }
> =20
> +int ib_umem_activate_invalidation_notifier(struct ib_umem *umem,
> +					   umem_invalidate_func_t func,
> +					   void *cookie)
> +{
> +	struct invalidation_ctx *invalidation_ctx =3D umem->invalidation_ct=
x;
> +	int ret =3D 0;
> +
> +	mutex_lock(&umem->ib_peer_mem->lock);
> +	if (invalidation_ctx->peer_invalidated) {
> +		pr_err("ib_umem_activate_invalidation_notifier: pages were invalid=
ated by peer\n");
> +		ret =3D -EINVAL;
> +		goto end;
> +	}
> +	invalidation_ctx->func =3D func;
> +	invalidation_ctx->cookie =3D cookie;
> +	/* from that point any pending invalidations can be called */
> +end:
> +	mutex_unlock(&umem->ib_peer_mem->lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(ib_umem_activate_invalidation_notifier);
>  /**
>   * ib_umem_get - Pin and DMA map userspace memory.
>   * @context: userspace context to pin memory for
> @@ -179,11 +216,11 @@ struct ib_umem *ib_umem_get(struct ib_ucontext =
*context, unsigned long addr,
>  	if (peer_mem_flags & IB_PEER_MEM_ALLOW) {
>  		struct ib_peer_memory_client *peer_mem_client;
> =20
> -		peer_mem_client =3D  ib_get_peer_client(context, addr, size,
> +		peer_mem_client =3D  ib_get_peer_client(context, addr, size, peer_=
mem_flags,
>  						      &umem->peer_mem_client_context);
>  		if (peer_mem_client)
>  			return peer_umem_get(peer_mem_client, umem, addr,
> -					dmasync);
> +					dmasync, peer_mem_flags);
>  	}
> =20
>  	/* We assume the memory is from hugetlb until proved otherwise */
> diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
> index d3fbb50..8f67aaf 100644
> --- a/include/rdma/ib_peer_mem.h
> +++ b/include/rdma/ib_peer_mem.h
> @@ -22,6 +22,7 @@ struct ib_peer_memory_client {
> =20
>  enum ib_peer_mem_flags {
>  	IB_PEER_MEM_ALLOW	=3D 1,
> +	IB_PEER_MEM_INVAL_SUPP =3D (1<<1),
>  };
> =20
>  struct core_ticket {
> @@ -31,7 +32,8 @@ struct core_ticket {
>  };
> =20
>  struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext =
*context, unsigned long addr,
> -						 size_t size, void **peer_client_context);
> +						 size_t size, unsigned long peer_mem_flags,
> +						 void **peer_client_context);
> =20
>  void ib_put_peer_client(struct ib_peer_memory_client *ib_peer_client=
,
>  			void *peer_client_context);
> diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
> index 4b8a042..83d6059 100644
> --- a/include/rdma/ib_umem.h
> +++ b/include/rdma/ib_umem.h
> @@ -39,10 +39,21 @@
>  #include <rdma/ib_peer_mem.h>
> =20
>  struct ib_ucontext;
> +struct ib_umem;
> +
> +typedef void (*umem_invalidate_func_t)(void *invalidation_cookie,
> +					    struct ib_umem *umem,
> +					    unsigned long addr, size_t size);
> =20
>  struct invalidation_ctx {
>  	struct ib_umem *umem;
>  	unsigned long context_ticket;
> +	umem_invalidate_func_t func;
> +	void *cookie;
> +	int peer_callback;
> +	int inflight_invalidation;
> +	int peer_invalidated;
> +	struct completion comp;
>  };
> =20
>  struct ib_umem {
> @@ -73,6 +84,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *con=
text, unsigned long addr,
>  			       unsigned long peer_mem_flags);
>  void ib_umem_release(struct ib_umem *umem);
>  int ib_umem_page_count(struct ib_umem *umem);
> +int  ib_umem_activate_invalidation_notifier(struct ib_umem *umem,
> +					    umem_invalidate_func_t func,
> +					    void *cookie);
> =20
>  #else /* CONFIG_INFINIBAND_USER_MEM */
> =20
> @@ -87,6 +101,9 @@ static inline struct ib_umem *ib_umem_get(struct i=
b_ucontext *context,
>  static inline void ib_umem_release(struct ib_umem *umem) { }
>  static inline int ib_umem_page_count(struct ib_umem *umem) { return =
0; }
> =20
> +static inline int ib_umem_activate_invalidation_notifier(struct ib_u=
mem *umem,
> +							 umem_invalidate_func_t func,
> +							 void *cookie) {return 0; }
>  #endif /* CONFIG_INFINIBAND_USER_MEM */
> =20
>  #endif /* IB_UMEM_H */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
