Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969EB3AF664
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769363; cv=none; b=NCbZmIvP0cxgC3AEykFoqKqxqDq6isuQavJ7MXdEY5GdistZdwfSeWJLc8rWF/heiV+3Vhxudtl8/Z+k+5Vul5cf2iGm5KSGw6bkq7ZeoYWKDnUGHvK5A20Z2QtKQg/15RSw4lTU8ZyvNvFEMHLNyCsYb1Cqs9k68khRM9BqeBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769363; c=relaxed/simple;
	bh=AsRxPh03HfOOSsKtyZOMNy/pDEDusSxrptM3Q7CZnBw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jJzJuPYz5C1qN0vWEHWmtDIRlF6K+bJIJs6OpLUO5BRjB2KRkxkf8LOBkPHURgBd4dsnqnqGcPmQG7RO/pfGMUe3OA4UOR1NDZtYhbaWoBWSgjPCXwU/sMRSGyc5R52au8blo4zo0zqrSx2J1BpKysP//RqD6AAmzVGXjHo85fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmTsCYQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmTsCYQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA181F00893;
	Wed, 30 Sep 2026 11:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769362;
	bh=AsRxPh03HfOOSsKtyZOMNy/pDEDusSxrptM3Q7CZnBw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RmTsCYQDELNrZAewauUSlH73tebqRT/gpVtPkObWOl2BNJJ9ILxF/4hWj5m3ghzqO
	 +G0pQcuGVkX3JFtx+l28LlYbdJp1xTX0bDlywfl2UKEUuXClXUhsw2n78uLauQvKpP
	 uOEtYdoBba1sUAS3XzW/dpNfJbwkURTdu2shv2oCpDyOs4Stmr+OGRMIWSju1ZoHY0
	 EbS6PwYaCi2kjWziMF+eEVwWY833dLMx1dQrdWAXb2XPAkFvsx94yS9KdlSHvBBT1a
	 YBudLjcqSQtouwo5XfueQWXoP3ou2pw73UR2ngsEtAjgpiwkINgzBR0mHnq52phhkS
	 Q+DHr0/ysvxwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next V2 07/10] RDMA/mlx5: Extract IB specific lock
 out of data direct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930114227.139274-8-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
 <20260930114227.139274-8-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 11:56:01 +0000
Message-Id: <20260930115602.5CA181F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> The data_direct_lock from struct mlx5_ib_dev is an IB specific lock.
> It protects from unbind while mlx5_data_direct_dev is being accessed.
>=20
> So move data_direct_lock out of the generic bind/unbind functions
> and into the IB specific notifier callback.
>=20
> data_direct_dev can be set during bind/unbind with a simple WRITE_ONCE,
> the lock is no longer needed.
>=20
> Each user of the data direct registration API has to do their own
> locking if necessary.
>=20
> During unbind, the data_direct_dev is set to NULL before calling the
> notifiers to avoid multiple users still accessing the data_direct_dev
> while unbind is in progress. This is to avoid another data
> direct specific lock which can lead to lock ordering issues.
>=20
> This patch has no functional changes.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930114227.1392=
74-1-tariqt@nvidia.com?part=3D7

