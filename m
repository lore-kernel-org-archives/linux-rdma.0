Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092689;
	b=u5L2nwqeNdwkO2NK2rRp2TvfqejF2LMXIge0/Po+kNvzq3HBbkl8g7c8gXG4FWuZYY9X
	 vclgIGiUUwfVEvFFDJCbZybogAmuugDM/lscApEf0+0gP7TT/mwLTisH6WusagESLjR7u
	 1ydTQoIN0FzXi/hUsQhkkXsmoFcptRT8a6uNxsfCFRqLSv36quddZADAVLpi42RmOBi6B
	 8avaaPeyCbcPoeNobmdfrjaF74cmicWBSTTVURQpYiZ9KB1dB0pzqxdM8C7ejzmH4T45P
	 w2ygYFONRnwK0ZP9BrSZfJlGh/MV/Z+jTyPDQXV1lnoHk0aCBqE7MMIdTpfEjQiUjCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092689;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SMJmzpviZEb8pg+LrIMwOJGZ3K89NteKxek4sU6BHs0=;
	b=RWqLTO8xXMuUZ5lqOemYp5wqjrPLJpAtxvQcykCgaIeEJEjfiTrnP8I8tOxq04KOIBkE
	 OQD+SBD7F2d+unPNQsvvJbKkgyF7XR8Fbb50NhGv0fKgo6OaP3pYRenopVkFwKBQARURz
	 cZ8R0Y/XoQxKwRS5wJrXQ/lr7WbWeA5T/mINXD2mfToa82HwhaIsfuVzVINRSqK/kifGw
	 jn8ud50gpwcDec84TsjtVecAbQ8BfO1ovhP8D2n6FKCfha6L1bxFJI5/pYmFBlEYfGy0A
	 Xyfs7YhROLVTY2YGH8BAx6jjvIK64u9SdITyL64/r8wh08kriJKK+mdLwNT68Cd9gRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FVRg0qF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F32B606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 12:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FVRg0qF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B63D1F000C5;
	Thu, 19 Nov 2026 12:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795092689;
	bh=SMJmzpviZEb8pg+LrIMwOJGZ3K89NteKxek4sU6BHs0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FVRg0qF3+U1dCjFxvQQgj/NzlQ0dB6BXElqixfN3YRiZhbDY0zMMizoxtYZsM1681
	 LWv0Hn3qAJrOKCgxIuYBgl2jBuHLGR0XSvD5iG7v5lN0CqfUK8yhAJty/J9dPbyeHn
	 iSrhflJAIVbtKUlSMEU1pgpJCKbR/g6zrSG4ifpipCOJn2hVcPAvs1YoTUWEQp89/8
	 xpNBTwkk8gHnPcmDbdl8MME1yXSDDOG589KMbobItbILkl5K83rHbhUrA3hjauHTyx
	 Q7l76quQa+8mGpfCqvWQBz+U85B7/dcIknwKWjsJKuV1OSVnx0IZmPtK9txgPboGLJ
	 M6j9hhJSpC+JQ==
Message-ID: <sashiko-outbox-223119@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/ucma: reject a second join of the same multicast
 address
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Misiurov" <amisiurov@cloudlinux.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119124153.1745521-1-amisiurov@cloudlinux.com>
References: <20261119124153.1745521-1-amisiurov@cloudlinux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 12:51:28 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Critical] RDMA/ucma: UAF race between ucma_leave_multicast() and
  ucma_process_join()
- [High] RDMA/ucma: TOCTOU race in ucma_process_join() across
  __xa_alloc() lock drop
--

commit 92134efcefe26ef534f470da9d6476bb2827da65
Author: Andrey Misiurov <amisiurov@cloudlinux.com>

RDMA/ucma: reject a second join of the same multicast address

This commit rejects duplicate multicast joins for the same address on a
ucma_context by checking ctx->mc_list under multicast_table's XArray lock
before allocating an ID.

> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucm=
a.c
> index a15182f7a7c5b..3f39de52bc9a6 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -1509,7 +1509,7 @@ static ssize_t ucma_process_join(struct ucma_file *=
file,
>  {
>  	struct rdma_ucm_create_id_resp resp;
>  	struct ucma_context *ctx;
> -	struct ucma_multicast *mc;
> +	struct ucma_multicast *mc, *tmp;
>  	struct sockaddr *addr;
>  	int ret;
>  	u8 join_state;
> @@ -1544,6 +1544,13 @@ static ssize_t ucma_process_join(struct ucma_file =
*file,
>  	memcpy(&mc->addr, addr, cmd->addr_size);
> =20
>  	xa_lock(&multicast_table);
> +	/* leave matches by address only; refuse a duplicate */
> +	list_for_each_entry(tmp, &ctx->mc_list, list)
> +		if (!memcmp(&tmp->addr, addr, cmd->addr_size)) {
> +			ret =3D -EADDRINUSE;
> +			goto err_free_mc;
> +		}

[Severity: Critical]
Can a concurrent ucma_leave_multicast() and ucma_process_join() for the
same address bypass this check and cause a use-after-free of the leaving
ucma_multicast?

ucma_leave_multicast() removes the old entry from ctx->mc_list and drops
multicast_table's xa_lock before acquiring ctx->mutex to call
rdma_leave_multicast().  A join entering in that window will not see the
address on ctx->mc_list and can take ctx->mutex first:

CPU0 (leave mc_A)                 CPU1 (re-join same addr, mc_B)
ucma_leave_multicast()
  xa_lock(&multicast_table)
  list_del(&mc_A->list)
  xa_unlock(&multicast_table)
                                  ucma_process_join()
                                    xa_lock(&multicast_table)
                                    /* mc_A already unlinked */
                                    list_add_tail(&mc_B->list,
                                                  &ctx->mc_list)
                                    xa_unlock(&multicast_table)
                                    mutex_lock(&ctx->mutex)
                                    rdma_join_multicast(..., mc_B)
                                      /* prepends cma_mc_B to
                                         id_priv->mc_list */
                                    mutex_unlock(&ctx->mutex)
  mutex_lock(&ctx->mutex)
  rdma_leave_multicast()
    /* matches by addr from head,
       destroys cma_mc_B instead
       of cma_mc_A */
  mutex_unlock(&ctx->mutex)
  kfree(mc_A)
                                  cma_iboe_join_work_handler()
                                    ...
                                      ucma_create_uevent()
                                        /* dereferences mc_A */
                                        <-- use-after-free

Because rdma_join_multicast() inserts at the head of id_priv->mc_list with
list_add(), CPU0's rdma_leave_multicast() destroys CPU1's newly joined
cma_multicast entry while leaving cma_mc_A active and pointing to freed
mc_A.  Checking and updating ctx->mc_list (or serializing the join and
leave operations) under ctx->mutex would close this window.

> +
>  	if (__xa_alloc(&multicast_table, &mc->id, NULL, xa_limit_32b,
>  		     GFP_KERNEL)) {
>  		ret =3D -ENOMEM;

[Severity: High]
Can two concurrent joins of the same address both pass the duplicate check
when __xa_alloc() drops multicast_table's xa_lock to allocate an XArray
node?

Because __xa_alloc() is called with GFP_KERNEL before mc is added to
ctx->mc_list, __xas_nomem() will drop and reacquire multicast_table's
xa_lock if it needs to allocate a radix_tree_node:

CPU0                              CPU1
ucma_process_join()
  xa_lock(&multicast_table)
  /* checks ctx->mc_list: empty */
  __xa_alloc(..., GFP_KERNEL)
    __xas_nomem()
      xas_unlock_type()
                                  ucma_process_join()
                                    xa_lock(&multicast_table)
                                    /* checks ctx->mc_list: still empty */
                                    __xa_alloc(...)
                                    list_add_tail(&mc1->list,
                                                  &ctx->mc_list)
                                    xa_unlock(&multicast_table)
      xas_lock_type()
  list_add_tail(&mc0->list,
                &ctx->mc_list)
  xa_unlock(&multicast_table)

Both joins then succeed for the same address on the same cm_id, recreating
the duplicate cma_multicast state and subsequent use-after-free on leave.
Inserting mc into ctx->mc_list before __xa_alloc() (and unlinking it if
__xa_alloc() fails), or serializing under ctx->mutex, avoids this race.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119124153.1745=
521-1-amisiurov@cloudlinux.com?part=3D1
