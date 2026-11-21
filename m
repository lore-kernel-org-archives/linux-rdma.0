Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795240730;
	b=anLO72Wfsn1SGj6mbD1NHAQV0oAxxKppkbG8f+Q3dvMjcitQIR3QOoFiKEHn4sLJIAYk
	 psFcSHCzNwERBKI7bHS3Gut4EiT8JrtHQtPgcOfmRIYKsYK4FHW4+O9JNx05BD4kbU0j9
	 NqQpP+vLvGk7NOuBXEOhqR/XkQ0kgvWePePfcugeKNcoN1iJRV4nBCRWMXJZ9k8kj8TL1
	 DvtTjtD6Sc/9cLf+2xJtAvZte0hPMx60L/qk0YrjuDhTcLTOw50T7nmPADzqhOah4SZDN
	 aSCchPGHWGr2rTBZOa2i5Tafzi0Ga4I+5kuQ8ysceIoSCcmG5Fy+m+C1LsS2tfnjSRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795240730;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hnDRM73TC0nplRxc205ku0j1sS5JoUC+VQrBwd8j4Mg=;
	b=Q5JJSpBEkFVktCw9twLaN7k+a67Zk6EYpHGLhP0CJ+thE2TKY7ynvcfq7nS/trAM/lFh
	 BeJn/h3rOGg2iOSpjVV7b8OoEZ0fwPiekQeB9WDUf70HMz8L2dY0sqhDMZYLSQXDGj9UY
	 jVJ4484ePCm9+/u7UGmlq0eVrAkvI3vqTCmk0qm35bvcG++TXeN8QxtG3Uj6V83OQEqcM
	 oLUAtaXZA9y8FhOnMF1k04EDYMbqxl+vlMidHgNxu3kbWkMPfRo5/O4qExaUddomK7blm
	 cZXnjYFcPiHJ3/w39osyfIV8U0O+UsIjVaHaSsd41J8VVZoMCSjisttEQze7UeO4kVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="E/oF9EDw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A93606A695
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 05:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E/oF9EDw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7371F000CA;
	Sat, 21 Nov 2026 05:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795240729;
	bh=hnDRM73TC0nplRxc205ku0j1sS5JoUC+VQrBwd8j4Mg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E/oF9EDwtlEOefb8q5DVGI8aTeqrgp5bRuKfhd+9iFK6UKL5tEqRO6GPj74oUIlNu
	 CpnMuTRZlJc+r7wzaUpGZdUeT7+p/I+RaJ9KXzssWvIOzFfk4bMEk/3lswiEjk3/PZ
	 QNNFqotvMgcBsiBvvEvrRQdLS/u60oMlZu3ok+ZCJXe+MuMII6m4LGdVv9+ZY32cko
	 IqGrUCTUPx7MZjoMPQc7pZ9ocGD36ip6kTVKCbgVWWytjzJ9Elt3UK6HEuvHC71WHH
	 3goqt/q4haCh/Cq/2YTn88Ha6WhjWY1Hcqe772T9mU8iHvgG26RYfW0OXl7q7G1Vr9
	 f/JTiL2BLVvYA==
Message-ID: <sashiko-outbox-226692@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 24/24] dma-buf: Add kunit tests for mapping type
 selection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: media-ci@linuxtv.org
In-Reply-To: <20261120-dma_mapping_type_v4-v3-24-c0183a409bdf@nvidia.com>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-24-c0183a409bdf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 05:58:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] dma-buf: build failure from mapping2->type access in selection
  KUnit tests
- [Low] dma-buf: duplicated mock_type_a and mock_type_b callback setup
  across tests
- [Low] dma-buf: commit message omits failed map and pin selection KUnit
  tests
--

commit fdd7641c86ac3670b97b442d9f583c8418cdf65b
Author: Alistair Popple <apopple@nvidia.com>

> dma-buf: Add kunit tests for mapping type selection
>
> Add an offer list and a select_mapping() callback to the mock exporter
> along with map/unmap for the two mock types.
>
> Adds tests for the exporter/importer contract.
>
>  - test_match_set_is_final: a later importer attaching does not change
>    an existing attachment's match set or default. Later attachments
>    influence what the exporter selects at pin and map time but not
>    previous attachments.
>
>  - test_select_at_map: the exporter chooses a non-default entry on first
>    map and the result is tagged with it. A pin taken while there is a
>    live mapping inherits the type and the choice survives unmap/remap.
>    Only dma_buf_invalidate_mappings() allows the exporter to make
>    a different selection. An -EBUSY from selection leaves nothing
>    established.
>
>  - test_select_at_pin: pin selects, and the choice survives map, unmap
>    and unpin so a pinned importer that is never invalidated keeps its
>    first type for the life of the import.
>
>  - test_unmap_uses_own_type: after an invalidate the exporter may select
>    another type for the next map. A mapping made with the previous one
>    is still live, and each mapping must be torn down with the type it
>    was made with.
>
>  - test_select_survives_own_invalidate: a pin or map whose exporter
>    callback invalidates every attachment still ends up selected, and one
>    that invalidates and fails does not.
>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

[Severity: Low]
This isn't a bug, but the commit message lists five of the new test cases
while omitting test_select_survives_failed_map and
test_select_after_failed_pin.

> diff --git a/drivers/dma-buf/st-dma-mapping.c b/drivers/dma-buf/st-dma-ma=
pping.c
> index 8c69ae212455c..42e6748f0ae65 100644
> --- a/drivers/dma-buf/st-dma-mapping.c
> +++ b/drivers/dma-buf/st-dma-mapping.c

[ ... ]

> @@ -374,6 +407,485 @@ static void test_mock_attach(struct kunit *test)
> +static void test_select_at_map(struct kunit *test)
> +{
> +	static const struct dma_buf_mapping_match offer_ab[] =3D {
> +		{ .type =3D &mock_type_a },
> +		{ .type =3D &mock_type_b },
> +	};
> +	struct dma_buf_mapping_match imp[] =3D {
> +		{ .type =3D &mock_type_a },
> +		{ .type =3D &mock_type_b },
> +	};
> +	MOCK_IMPORTER_OPS(importer_ops, imp);
> +	struct dma_buf_attachment *attach;
> +	struct dma_buf_mapping *mapping;
> +	struct dma_buf *dmabuf;
> +	struct device *dev;
> +
> +	mock_type_a.map =3D mock_type_map;
> +	mock_type_a.unmap =3D mock_type_unmap;
> +	mock_type_b.map =3D mock_type_map;
> +	mock_type_b.unmap =3D mock_type_unmap;

[ ... ]

> +	dma_buf_detach(dmabuf, attach);
> +	dma_buf_put(dmabuf);
> +
> +	mock_type_a.map =3D NULL;
> +	mock_type_a.unmap =3D NULL;
> +	mock_type_b.map =3D NULL;
> +	mock_type_b.unmap =3D NULL;
> +}

[Severity: Low]
This isn't a bug, but all six selection tests assign and clear .map and
.unmap on mock_type_a and mock_type_b, and an early KUNIT_ASSERT failure
skips the teardown since reset_mock_state() does not reset them.  Can
mock_type_a and mock_type_b initialize .map =3D mock_type_map and .unmap =3D
mock_type_unmap statically (or manage them in reset_mock_state())?

> @@ -381,6 +893,190 @@ static const struct dma_exporter dma_exporter_param=
s[] =3D {
> +static void test_unmap_uses_own_type(struct kunit *test)
> +{

[ ... ]

> +	/* Invalidated while that mapping is live: the next map reselects */
> +	dma_buf_invalidate_mappings(dmabuf);
> +	KUNIT_EXPECT_FALSE(test, attach->selected);
> +	mock_select_idx =3D 0;
> +	mapping2 =3D dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping2);
> +	KUNIT_EXPECT_PTR_EQ(test, mapping2->type, &mock_type_a);

[ ... ]

> +static void test_select_survives_own_invalidate(struct kunit *test)
> +{

[ ... ]

> +	/* A second map does not reselect. */
> +	mock_select_idx =3D 0;
> +	mapping2 =3D dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping2);
> +	KUNIT_EXPECT_PTR_EQ(test, mapping2->type, &mock_type_b);

[Severity: High]
Does accessing mapping2->type break the build when CONFIG_DMABUF_KUNIT_TEST
is enabled?

struct dma_buf_mapping only has a match member, not type, so these two
checks in test_unmap_uses_own_type() and
test_select_survives_own_invalidate() should use
dma_buf_mapping_type_of(mapping2).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-dma_mappin=
g_type_v4-v3-0-c0183a409bdf@nvidia.com?part=3D24
