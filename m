Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826893;
	b=T1YJKlgVZrzArj74DrMj9x+FZvPJawnHx83qJ9vRlnq/sSmHFPLT/MOs2cOXRhFL6QNK
	 58QGRyonAevaU8VzHPP1NwqOyYSwipca/14FkQN45neQWFFnFtT5KYraEWeMOTmGB3gF6
	 m+2NhvNcN+EtaTcmqruBhskU/X5UcFNiO+NA47U/sxdcC5dYRWGwgT7XkxDtrxRKm/RbX
	 TIRTTPmGwxPAX7pcmlDuRojKucq791yxfV5J/I8aHSpEp8q91PV1iS9vd1wcIxrK/Qh2Q
	 oYdcwnrMQQT8It9h+bAqe6KViU99DwfrKWpCosQmQE4jb32tpBpLyIHYe8t9hF1uEGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826893;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JYWJlyYIG0M8QxclLsh8thjYd5ecaC2qgMkpuLl4nTs=;
	b=S4U1GVwCARATYTyWWkq7SnaeSQyYb7Vo8XrcziOe5K1EORftodO6e36VE91whuqhJwQq
	 O4m4IBJgvt1ALDxo2KYrkvBOMXpFl+JqP7qL3WP6KcxGSN/U/7+4u/gEXRT1FTlf7ogL2
	 /r5gJiy2eeCaXA81t+QeSOv5K8POlwNarfZkyYltbMF16L1FTU9F+r2I0H+C9N8afmfSz
	 KumwydxASb8J0m0OZnVA1spiKAZ8MxHwYzKRfZlUshR49CDqwOpUIW/buao0FrcVMwn0E
	 GBdvhq+dMSty31U5gXXcJMBL3Z85Ul1L5zqho6f3+1k1D+A7n0zER5dAZkvWQn4NjjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nGwxhna2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56DF6070760;
	Wed,  4 Nov 2026 21:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nGwxhna2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F211F000C1;
	Wed,  4 Nov 2026 21:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826893;
	bh=JYWJlyYIG0M8QxclLsh8thjYd5ecaC2qgMkpuLl4nTs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nGwxhna20M7O/iLPC9ftztdz7IEi9uchsNvc4J07jorKAB/Q9t4Pi2K1u2oFYJBvH
	 6oTvMYMLerHXK74ec5w6j9zwvoE3zXjY9PZk8ipzugtK6UtAqyjO3ccnbeWuFr1nA5
	 Rp5YaWKJy9N0YGI3jTkNnqr/Xhh6izoAFijZThB13ZKCJPRkmFNGbXmJ5DZ++OAMVo
	 uKfIno04uylCWc/po/x8d8+/EEnKxiOt0QfwuajYRh35IzG4vPCJLWZSxTMIcjYyZ6
	 4OSiM1rPY1197ZRcdsDJKHlGgHFzW2raQEwJNs8YWqcuMLuyqLINH8wWa2RvOsCLKZ
	 QiP9EX5RHuRfg==
Message-ID: <sashiko-outbox-198072@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 3/5] net: datagram: refcount page_pool frags
 in zerocopy_fill_skb_from_iter()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, virtualization@lists.linux.dev, linux-rdma@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261103211424.127627-4-almasrymina@google.com>
References: <20261103211424.127627-1-almasrymina@google.com>
 <20261103211424.127627-4-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 21:14:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When an application maps order-0 page_pool RX fragments into user space
> via TCP_ZEROCOPY_RECEIVE and forwards that mapped address into TX
> sendmsg(MSG_ZEROCOPY), zerocopy_fill_skb_from_iter() pins the pages via
> iov_iter_get_pages2() (which increments page->_refcount) while
> skb_release_data() releases fragments via netmem_dec_ref().
>=20
> Acquire each fragment reference via netmem_inc_ref() when attaching a
> fragment in zerocopy_fill_skb_from_iter() and release the corresponding
> GUP page->_refcount reference via the existing batched page_ref_sub()
> path so the TX SKB fragment reference pairs with netmem_dec_ref() in
> skb_release_data() once netmem_inc_ref() and netmem_dec_ref() handle
> page_pool netmems.
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103211424.1276=
27-1-almasrymina@google.com?part=3D3

