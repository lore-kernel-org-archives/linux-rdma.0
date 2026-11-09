Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794204043;
	b=0iTWDYtTE4inYqCYn0kau+wb7M2N6f4tJl9HvsIsiLhJgNeLimlX5fUF23zwJcHY2gci
	 vKdFswDFKEOhsvXARlBYYcjOM1/rOSyf83r1YuO/fhvJG4M7tFOqxhF0AsEW35/r1Cjrd
	 Hy/hffZRyTtHQ5fk0imXtYzCR5D+QH0NvRrXf+EE0lDlRrdx2kvCyd9Hl2MyKUvxNUpqI
	 8LLDGIlezYK48F/gX/HUOFVdHfqpL2MXR1sUJjHcjy12bBfAhgF/xseE5yJY22x5shFmu
	 Z1/01ftteOp/ayurW4SGS6w+shysVZcT8nApQdYVakIL72vfYsrzAfUnLIDU2NCEnbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794204043;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QpZo9amzJcy9TafpVWqdaIHz5m9nEPLYUGaZ1jjst+0=;
	b=xkIJNGti5n7bE5mSGkqhB9GtLijyKiSm/o8dTQrAuTxOLSRkCm7mL43vma7+7OOKPDYQ
	 oKrBw5OcfSGqUx3e6bJKCdLunJDw9cYgiCLejt80+kZf3Zf5wSUyLCe9JZhBpYqWYMSEt
	 a8lXxAcTLEcNLUTk4Nrojul0BmHSHt0j7m+waywrwm9PhZvmLiYXIhJk07C45iccdupyH
	 pN8ovwhzXqFIWLAcACuEit5Qg+2ZnfsFlmLPDhxLavLEtpiFKFxpNpJS6orNaP63ZPJ00
	 wma+kCy6RG1Wm4XSfgRvL/K1uLxdTweXVaQFBAxo5Lrt1zOGGgbFlNf1Qpgcmhd7/GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S4JeAbR4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D5C606A338;
	Mon,  9 Nov 2026 06:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S4JeAbR4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F321F008A1;
	Mon,  9 Nov 2026 06:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794204042;
	bh=QpZo9amzJcy9TafpVWqdaIHz5m9nEPLYUGaZ1jjst+0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S4JeAbR4eW5E8nmnkI115ayPhN6ry44YaAqcfvo0iuc4iUPMqsOTq2kkwD/csEhGO
	 aytftk/vdF2suO2K2B7K/APiiDoMKx9Ztp+LTaXC1wUo4s5Ox8P2z8UGpdEYoqt5h2
	 rzWlzraH26cc1yBbyaGZ+Mh7BY7HeuEgjDKGNyaiJN1f4BmqzYoa0IHz+wz+yXYjhH
	 w6Bme2ejnNpp+VwSlmGq42ziPDSLyN3+zA02KoyjnDbpwG2zIrXU9k0kc7fCSnem58
	 7PFEvTndF6gtFdVCDTPdQGLgCY3J9eRvyIMlfcYXVS4MPQCamDcg12OJrdc/oUQcXx
	 7cA308BArbTDg==
Message-ID: <sashiko-outbox-204472@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 3/5] tcp: detach page_pool pages before
 mapping in tcp_zerocopy_receive()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: virtualization@lists.linux.dev, linux-rdma@vger.kernel.org, "Michael S.
 Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261108060016.2131509-4-almasrymina@google.com>
References: <20261108060016.2131509-1-almasrymina@google.com>
 <20261108060016.2131509-4-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 06:00:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Once tcp_zerocopy_receive() maps an order-0 RX fragment page into a
> userspace VMA via vm_insert_pages(), vm_insert_pages() increments
> page->_refcount, which prevents the page from being recycled back into
> its page_pool when the RX SKB is freed. However, while the RX SKB still
> holds its fragment reference, the page remains marked as a page_pool
> page (page_pool_page_is_pp(page) =3D=3D true) inside the userspace VMA, so
> subsequent GUP callers such as sendmsg(MSG_ZEROCOPY) or vmsplice() can
> encounter a page_pool page while holding only a raw struct page
> reference.
>=20
> Establish the invariant that pp_ref_count is only incremented by callers
> that already hold an active pp_ref_count (>=3D 1) on that netmem, and a
> raw page_ref_count is never converted into a pp_ref_count:
> - In can_map_frag(), require !skb_cloned(skb), page_pool_ref_count =3D=3D=
 1,
>   and page_ref_count =3D=3D 1 for page_pool pages so the fragment being
>   mapped holds the sole reference to the page; cloned SKBs or page_pool
>   pages with additional references (including drivers holding an
>   undrained fragment bias) fall back to copying.
> - In tcp_zerocopy_receive(), convert the fragment's sole pp_ref_count
>   into a regular page reference and detach the page from its page_pool
>   via get_page(page) + napi_pp_put_page(page_to_netmem(page)) before
>   queueing the page for vm_insert_pages(). If vm_insert_pages()
>   subsequently fails, the detached page remains referenced by the RX SKB
>   via its regular page reference and is freed back to the page allocator
>   when the SKB is consumed.
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108060016.2131=
509-1-almasrymina@google.com?part=3D3

