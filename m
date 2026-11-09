Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794204044;
	b=tLvlf2KTO+kyK45tfigk/e78lNGYDpFPi97eszrvcy/6XJS0WxyMGd+Ds2gB0fvrWlmU
	 pibpabRCVDTrP837aRl+vk5TheH7LAfDzHkT5mhWd+44AIwcI5xcuz7cqYl3H+lbcrd0r
	 03gFevkb1j3qrvepFJ2d93jrjhY0MCwZUn5QsDr0o5hBDkqabuASl074adB83bd/+6ic1
	 uzYz1PbDww2gfIkX3Nqzf3zkO0NcHNG7S/rOkq80jl/2pFIaVZuuejKngczeHEmAsTsye
	 MMKCbuvxOTr5sQe2MFhuzu4lO1549ncOJLLooodpFdibrRBqcXG5TtjbilbP+2zGIHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794204044;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JnH38Qke0dcLvNp518+5EvLVu7o3/Crn1Hzc8hwSUa0=;
	b=j7TtnBaZ+WWvL0tyMsfCKywP5sSlMe7dPQmdouRekSnoyeTECQ2MjPd+su2LkZQggetK
	 7EGoiuHrp9v5qUQL38G9mAo5vVSXaTzxCYV1KHGvVsFdlTLm6NvaKtJxO63LbpXovjWRB
	 2nR64HRVaC++FmAnAIwG+soxWcQn4VB3RgK8PZJFD1QomBAbndGmgCqhtwlTq1B+fDS3t
	 CfawQ/fxoJ01Y+hQtbg2k2apazulU2PMgomXvUHSPOfiL4SPj+CCvrrkr5VNdTC8w+bi7
	 W93bV+habor9j7s3xkUGYGCAPg/FfJHmzQNpL8T0/+I0Z5vKT7e+3giO9q1rj81IijA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cdq0qFzX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03FE606A33E;
	Mon,  9 Nov 2026 06:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cdq0qFzX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF521F008A1;
	Mon,  9 Nov 2026 06:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794204043;
	bh=JnH38Qke0dcLvNp518+5EvLVu7o3/Crn1Hzc8hwSUa0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cdq0qFzXk4dqMksfIJAuRMy2GOLknaocI4lKWmENE3cWdDaGfRwnQc7zrOeNDLjtQ
	 IUmvho3j0V5HwKLVVbqWKyjGhWAo/3SwKUn5RKM6bMUT2FQAnhEGpCMK30mSZo8eQX
	 gg7b+fZ/l5IM76rHzckXOnqvzdfRyvv6/arWfp678d8DIpT9odRZ2/fHRv7VL1iFC6
	 5RoyRJROQGeRChv5tYwEO88HFcw1feVkJ+RW5uVmWClouHfRPlVkWzTqhwjScM+oqr
	 w0uvI4SrS1VaDvgOTpepHLp8cW2U/P/hAfqS84OYJUL1dbff2sNgv6+C28VJjrFzkM
	 XRusHe/GFntFA==
Message-ID: <sashiko-outbox-204473@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 4/5] net: remove skb->pp_recycle and
 consolidate netmem refcounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: virtualization@lists.linux.dev, linux-rdma@vger.kernel.org, "Michael S.
 Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261108060016.2131509-5-almasrymina@google.com>
References: <20261108060016.2131509-1-almasrymina@google.com>
 <20261108060016.2131509-5-almasrymina@google.com>
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

> skb->pp_recycle was introduced in commit 6a5bcd84e886 ("page_pool: Allow
> drivers to hint on SKB recycling") when drivers had to explicitly opt in
> to page_pool SKB recycling and to avoid touching struct page on the free
> path. Today every page_pool-backed netmem carries its own identity via
> netmem_is_pp(), making the per-SKB skb->pp_recycle bitfield redundant
> and error-prone when SKBs are cloned, split, segmented, shifted, or
> coalesced across page_pool and non-page_pool buffers. For non-page_pool
> pages, get_page(), put_page(), and skb_free_frag() immediately load the
> same first struct page cache line (compound_head, which shares the cache
> line with pp_magic), so checking netmem_is_pp() does not add an extra
> cache-line load.
>=20
> Remove skb->pp_recycle and check netmem_is_pp() directly via
> napi_pp_get_page() and napi_pp_put_page() inside netmem_inc_ref(),
> netmem_dec_ref(), and skb_pp_recycle(), dropping the now-redundant
> [ ... ]
>   skb_irq_freeable() does not exclude SKBs holding page_pool memory
>   before calling __kfree_skb() with hardirqs disabled; TX SKBs carrying
>   spliced page_pool fragments are subject to the same path.
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108060016.2131=
509-1-almasrymina@google.com?part=3D4

