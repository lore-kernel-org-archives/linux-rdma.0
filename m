Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3132C3B71A6
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482594; cv=none; b=IUYifIhCorKLGMpZTFJgkjG4X2MqYR+EBiNncSNMYzWGsJXsWnAiLM7UMJdjiSCCQWnhfXpPyTbMxiLitMal0hvkKHl0bqGci+InVFwV1OO3V5MWd4yVI7juxPvetBM2dTbaCDWQ8tAfdJxA885puZvNlFwzuiGVTo6dpwR1P7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482594; c=relaxed/simple;
	bh=NR73lsjlWyswIGbnKbD0ibPz1Ob1r1YD88f60DbwF/o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GvwLtTPlxVFeZfkGr79MQR9zvdN/h6w4oLPibsKdrniENPjg1D5XnAs43BvNrXF+JbmKVEWuDGcf653Br9ebm7bnOPlL4rGTiVDAB3vNShBptIuroEm7tpy4DyDZQI2PVdxrInDbnjixf6eaOK2HD/R0D/ai7E6U4D0Kgwn36UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLzM+EQn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLzM+EQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57031F000FF;
	Tue, 15 Sep 2026 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482593;
	bh=NR73lsjlWyswIGbnKbD0ibPz1Ob1r1YD88f60DbwF/o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GLzM+EQn9qviu1G87yuRXLMsUuOwUoMxxgplUqbFRfh42TOTY0+GUpn9WJaEVPe+v
	 taQ5VLV92EQqecy1DVXTfvZ4y5Vz1WXoNK8T/gpJMBhP7pdVDdJK74KY5/A/TXTqfY
	 /qGJOkktt3vngkGDSVa8GrG+U/B3wMF+jS/gLY+NGD4WjnHVVd7AS/bhtRzBnFadMh
	 mxlbjQWG9BDMrBVAZeWC83krsvOgIJl9IxVP4dWX+vBHG2vUl63PgFKF+SKTEnqA1a
	 HMdh+sm8Zu4PAxB+lE1UsnCDAXEi/t8Gjrq5MqSkNcHkedRKgSG4PLL9OjH5z6gY/p
	 Z+V3/xz+05Exw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 14/15] RDMA/mlx5: Initialize QP/RQ/SQ
 resource refcount before publishing it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-15-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-15-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:29:52 +0000
Message-Id: <20260915142952.D57031F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> create_resource_common() inserted the resource into the radix tree
> before its initialization was complete. A firmware EQE in that window
> finds a zero refcount_t and calls refcount_inc() on it; the refcount API
> treats this as a use-after-free, saturates the counter, and permanently
> breaks the resource's lifecycle tracking.
>=20
> Move the initialization before the radix_tree_insert().
>=20
> Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D14

