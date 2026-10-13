Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204453D8916
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 10:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791886093; cv=none; b=bRD+KuAINe0yO8k9+94L2vtGqi78xAI3ky3HlobEOqxgM49/3i/8l/1HR4LaJqNL8DIKXuwlFwpmpsxAARE3dVz0MjPsII80DPbBQf4WVl3vBkPQMwG1CjZFDemwPquuF9nU//NRc27rnWykdjg0iFIA1l81sSIQ+2d+qIT3+tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791886093; c=relaxed/simple;
	bh=muo4TaMZn0RutkDiilxuqeWbepiaWH8xhvpC+7d7Imo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=eEHVe+2rWnM7BiZKQdiABT61d8/SvzzNOXZJABt1WDXlgkNc78hG4p8nMvuxYkmdoMFTqsawzavAcCjDE/bBjiHomli8aUnt4Hv4pi9jUMWlYee+uy7w+Yv+GBiwfpHsIPW+dVPwtX+NXX+g3jXyZCeO1+axeNGKVC1+NoCr9zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKaROOd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKaROOd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945E71F000FF;
	Tue, 13 Oct 2026 10:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791886091;
	bh=muo4TaMZn0RutkDiilxuqeWbepiaWH8xhvpC+7d7Imo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TKaROOd5GJuzna7aOAmGxgDyz/wftvKj5CI6iElDUJXdP5SYSZwP2thAaVRPC/zqH
	 uHcMVFwASRAJyzXYmJnQKl8RoOgqtCB2P7xzZ7cvHx+63fe1i5tSG9Y+qPqZXDws4b
	 WN3tUarCRIzCn9qT0+IPObKTF5cQbOgIAIVMv2mWL41DMAew0r8piGiQZEB4On/YlS
	 HKxqCgTRcREK672VCBxHOGD5zQuRrthQfdDMTfDuwMX0yFse7KsdJ9zlvHFVXRa8R4
	 BrL5JBSdXViL2J/y1lfCqKyIARO5tmLhVH5V66nXb4PoEG48WcKrdTO8ZwUF1IDHub
	 OZN8qZ6g09/Eg==
Message-ID: <sashiko-outbox-169456@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 1/2] net/mlx5: HWS, fix reformat pool creation
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012100555.1317878-2-acassen@corp.free.fr>
References: <20261012100555.1317878-1-acassen@corp.free.fr>
 <20261012100555.1317878-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 10:08:11 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx5_fs_get_pr_encap_pool() inserts a new pool when the lookup misses.
> Two callers allocating the first reformat of a size at once both
> create one and the second fails with -EBUSY. TC serializes these
> allocations under encap_tbl_lock while RDMA flow actions on the FDB
> don't.
>=20
> Sashiko AI review of an earlier series spotted this issue.
>=20
> Tested for regressions on ConnectX-7 with firmware 28.48.1000.
>=20
> Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API function")
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012100555.1317=
878-1-acassen@corp.free.fr?part=3D1

