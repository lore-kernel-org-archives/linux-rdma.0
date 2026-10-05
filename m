Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C36440A95F
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 08:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190000; cv=none; b=mSu51R4YjrWF4J82zOeDgVm7XbAJWTYjC7IqunGQnewaGazcDRdD8KER9ZKtLr9uRQQuOK1EYXxhWodkkvKCYh8zzTV4fXpNY+GNW+usJ30QPQF5MwQYQimNtywmpkzizFm8xOPbfkZ2F/JZCiixwUMknKecFF/b2q/7P8F7rL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190000; c=relaxed/simple;
	bh=/FHUnS+wplvNSLn4wBiLsCePEOF4K2QtsgXBSWgN1aM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DIICtA3bF/9LlzYhudrhESAbSaYqeRLq+GqjD74qDE7X85SVA8Cu/o26cwp9uBcdzWukDyWjobNh9fyZlNrXkdH7mtqlbTWfJZ0gP+D0N97zJQZYcoCWkGBsRyBhY6E2jPmrVoDpzt46qlqeic/7PsWkcXNhoXoOZ3qoe4sm37Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFjgVGCN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFjgVGCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414141F000FF;
	Mon,  5 Oct 2026 08:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791189999;
	bh=/FHUnS+wplvNSLn4wBiLsCePEOF4K2QtsgXBSWgN1aM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mFjgVGCNH60R5fIxBmQSjSmjKrl6Xt7gS3RXE3XSNlIbFJkj0drNstfbNtzIGIZJ+
	 ISr9/zzp0s1YU2vHQ+PKqUwNwN4tl0m3+h5LJQqjHQa4Q7UdUGr8XF4Xp2Te7d8dtW
	 NivetwWsO/vCLxWGiRE1HxsI/r5G14y1JmXVcqM/pYkEHai41ed5vtk9hx4N6xHNKM
	 QyHJNvnpVe2qwUgly805wL+/fS1dkTGk6NR7Erp4ypYO3x78WGm36dFHkmwmhfuOK0
	 DHF1s+VmVB3b9Auz9HsTqZNcx5DZsGBgzWIuXiiYq/FVCxK1ugJEyMLDiXSbYyLW0t
	 XXEF156dbu2aA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Add cap_tx_speed and
 effective_tx_speed support to IFC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261005084047.237081-2-tariqt@nvidia.com>
References: <20261005084047.237081-1-tariqt@nvidia.com>
 <20261005084047.237081-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 08:46:38 +0000
Message-Id: <20261005084639.414141F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> Introduce the cap_tx_speed and effective_tx_speed fields to the query
> and modify_vport_state structures.
>=20
> Add the esw_vport_state_cap_tx_speed and
> esw_vport_state_effective_tx_speed capability bits, indicating the
> firmware supports modifying the cap_tx_speed and effective_tx_speed
> fields, via the MODIFY_VPORT_STATE command.
>=20
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Nimrod Oren <noren@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005084047.2370=
81-1-tariqt@nvidia.com?part=3D1

