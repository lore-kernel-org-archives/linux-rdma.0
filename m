Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793929760;
	b=raonA4e9UOuf24EBoUxSWuDmntbnGZorvfFBHOp5SmpdrP9a7Sg3YDIEaQBGQ/fQj5ix
	 f4UTDho5nevSV+k9RhZI1bENd11dPeZCYaGHQGSeQBaYWqg7c88ouFrZF/Xss7qwosI/o
	 8l/djN6295ZuUnwSWy5UaCZ/CbtRVihat4+reuOl5Kgj0ll6VmPONfvsob9MgMOuRCt7N
	 pFBvFxWUCSjmWGYrNLFthC12MNZcmJERhmgF6HDmes6ICrtTkZp3ZUa1gWQ8rrFxA1DqT
	 tVcfNKGTXgwS2SFxU2j96yV4mYVcGQYkbcKLrrJdBb1+FaOz0JeDMHDS66LMVXPqERA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793929760;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tEM8tnuE/5gJ8QhMp3tDq0gzoSSwOhcBjwKtUw/VYJg=;
	b=kiXO6kYGwL27Svl1gxhUrt8q8Rv3M0EssyiyEAWavWc4E2qmruxRz1FdRelI/XNMAyOA
	 7f/7HGRudxcAqAyDm9So2F55MEPUqZX2L3/g4YCUuEsyPrhTma4O9uq/2iYI8NHEZuBZT
	 7dvqAZ1Y2v3aBhc/wmEZ1lKT17Kuambp3s3kdJqAcJGhmhkYH2lu0DD40vd7C2gRpL0Qp
	 ycAMCFM+qVmEVGjJeY1Fv+ejGv1E5bk5xWQbpNsPSgBLel802h0Yx10L4Xm6FuPe27+aD
	 mrnwjN1xe0AbNJQxk0AhZUM7qZV2U/7rXbq9CldoVXQgtrJK92oQ5GYwmd1PYs+Nnkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=doqrfQgS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF4D606A31B
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 01:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=doqrfQgS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525141F0089F;
	Fri,  6 Nov 2026 01:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793929759;
	bh=tEM8tnuE/5gJ8QhMp3tDq0gzoSSwOhcBjwKtUw/VYJg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=doqrfQgSwi3B+/S/uQ8yh1TLRE5c+ZOChcclmQJtEmMEE22jvand+qlSSp30dLIBj
	 cIehsu0nXenD8qVC9HhU4/XsP9SJq0Mr6UH7W7ruzIG25A5WpDnT1QVYIHeWhHdd+C
	 SXAnu/fze2QQ9y+qmMYE95S5Bo5hWRMlAi//YSJqNDht9o690+AD0QoXBvPJFhjxl5
	 ehxD+Xz5u8+ARyStuU8CvX9TS/3b0weJoxAS84NKm1TSvYyckrRMj8KBujOC9VgDYY
	 PGtUnPs2KLlAm7msJ2bNTAPylVXIn6gN8fX38FcAQ4aT8NKkz0vvtavmIBQoO/zdgq
	 7Zf3ZAdKZvD7w==
Message-ID: <sashiko-outbox-200539@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Fix radix tree node leak in uapi_add_elm()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Deepanshu Kartikey" <kartikey406@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261106013908.21789-1-kartikey406@gmail.com>
References: <20261106013908.21789-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:49:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] RDMA/uverbs: incomplete radix_tree_node leak fix in uapi_add_elm=
()
--

commit 2393d302cac044b0b4ac5a4d059afc74697b1fb2
Author: Deepanshu Kartikey <kartikey406@gmail.com>

RDMA/uverbs: Fix radix tree node leak in uapi_add_elm()

This commit attempts to fix a memory leak of intermediate radix_tree_node
objects when radix_tree_insert() fails with -ENOMEM in uapi_add_elm() by
inserting a dummy entry at the same key and immediately deleting it.

> diff --git a/drivers/infiniband/core/uverbs_uapi.c b/drivers/infiniband/c=
ore/uverbs_uapi.c
> index b67db3790f03c..91350d3479a80 100644
> --- a/drivers/infiniband/core/uverbs_uapi.c
> +++ b/drivers/infiniband/core/uverbs_uapi.c
> @@ -15,6 +15,7 @@ static int ib_uverbs_notsupp(struct uverbs_attr_bundle =
*attrs)
> =20
>  static void *uapi_add_elm(struct uverbs_api *uapi, u32 key, size_t alloc=
_size)
>  {
> +	static void *dummy;
>  	void *elm;
>  	int rc;
> =20
> @@ -27,6 +28,16 @@ static void *uapi_add_elm(struct uverbs_api *uapi, u32=
 key, size_t alloc_size)
>  	rc =3D radix_tree_insert(&uapi->radix, key, elm);
>  	if (rc) {
>  		kfree(elm);
> +
> +		/*
> +		 * A failed radix_tree_insert() can leave empty intermediate
> +		 * nodes linked in the tree. They are only freed when an entry
> +		 * under them is deleted, so populate and delete the slot to
> +		 * reclaim them.
> +		 */
> +		if (rc =3D=3D -ENOMEM &&
> +		    !radix_tree_insert(&uapi->radix, key, &dummy))
> +		    radix_tree_delete(&uapi->radix, key);

[Severity: Medium]
Does this recovery path still leak radix_tree_node objects when the second
radix_tree_insert() in uapi_add_elm() also fails with -ENOMEM?

In lib/radix-tree.c, radix_tree_insert() -> __radix_tree_create() links
intermediate nodes at each level as it descends down to shift =3D=3D 0:

lib/radix-tree.c:__radix_tree_create() {
	...
	while (shift > 0) {
		shift -=3D RADIX_TREE_MAP_SHIFT;
		if (child =3D=3D NULL) {
			/* Have to add a child node.  */
			child =3D radix_tree_node_alloc(gfp, node, root, shift,
							offset, 0, 0);
			if (!child)
				return -ENOMEM;
			rcu_assign_pointer(*slot, node_to_entry(child));
			if (node)
				node->count++;
		} else if (!radix_tree_is_internal_node(child))
			break;
	...
}

When the initial radix_tree_insert(&uapi->radix, key, elm) returns -ENOMEM
after linking an upper-level node, the lower-level child node(s) down to
shift =3D=3D 0 were not allocated. Freeing elm via kfree(elm) only releases=
 a
small kmalloc object rather than a 576-byte node from
radix_tree_node_cachep.

Calling radix_tree_insert(&uapi->radix, key, &dummy) immediately afterward
must still call radix_tree_node_alloc() in __radix_tree_create() to allocate
those missing lower-level node(s) before &dummy can be inserted. Under
continued memory pressure, memcg limits, or multi-allocation fault injectio=
n,
that retry allocation can also fail with -ENOMEM (potentially after
allocating and linking another intermediate level in a 3-level tree). When
that happens, radix_tree_delete() is skipped and uverbs_destroy_api() ->
uapi_remove_range() still leaks the empty intermediate radix_tree_node
objects.

Would calling xa_destroy(&uapi->radix) in uverbs_destroy_api() after
uapi_remove_range(), or unwinding newly allocated empty nodes directly
on failure, avoid depending on a new radix_tree_node allocation to succeed
during -ENOMEM cleanup?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106013908.2178=
9-1-kartikey406@gmail.com?part=3D1
