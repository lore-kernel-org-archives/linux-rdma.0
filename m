Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708AA4E73DC
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730190; cv=none; b=JyXwpeeKg2ealoYHSx3bQfRiKtrd1oWfY4njSDhKvZ/RK5wT4Ma1OHE/SNGpGbfwHbwXW7+b6ht8/HQwcCRFD/yzuMIRHAK91oZU7zqMXCNuMWqioxgiimIiK3sFLCxF30c00YsgrR/DnO9yqmVPEoSXL99Xj0rK0e76KONdEUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730190; c=relaxed/simple;
	bh=IZ+bw4/0hRksG5r2cpf2kMbO/ZriiuDmDOfzhFHs5Do=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Kd7fQVNXmlup2kfMpQIUaEYZ9HtbjjN+0nz+WzdTJOcPHilK1VbwGOFm88TyhJofnsqG10LI0wO8bCJiLTVcrlLdtllMSdn9JQ5FRHUaTdQQo0CRooTN00IFzTHMt3Of9UM1ug+SuQQtjm4SjqHJsxWE5IkjXd/eG/d+A/YDO+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U7nDRHMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U7nDRHMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3851F00893;
	Fri, 18 Sep 2026 11:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730189;
	bh=IZ+bw4/0hRksG5r2cpf2kMbO/ZriiuDmDOfzhFHs5Do=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U7nDRHMrkAf+Edo5KrzBV88/1OZ3U4v1dnnQ6lwermd9G56hUfAjRvyBtcmEV029P
	 jCNJlhBsyXTT/fiSYUNMVFs1hUBL6SSu8f0csWiTcG4L2vn00im0CUm19//CCP2u6j
	 ESTr1J8lW4BzgoLbmf9pNlUX1aW1yoMdKun9gGeorrwNnmWapbvjf6MO9wVqFUunfR
	 qhqVCLoBV1W4pPEHjglM2/AdyNfEDgQH62ijpNbnTZnoz+HF0EHtl4tS3yeOyFAT4H
	 2mYKOBAFxFSQZbpmCKsiZqJCkhBY/ZLWoCE7kPjv0GgjsJVAO7uIKv9u/p9WK1YykD
	 jzgucoBP8LnNg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 02/10] RDMA/mlx5: Add
 mlx5_data_direct_supported() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111422.4054862-3-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:16:28 +0000
Message-Id: <20260918111628.EA3851F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> The data direct capability FW checks are duplicated inline in
> mlx5_ib_data_direct_init() and mlx5_ib_data_direct_cleanup().
>=20
> Wrap it in a mlx5_data_direct_supported() helper and use it in both
> places, in preparation for moving the data direct matching code to
> mlx5_core. For the same reason put it in driver.h instead of
> data_direct.h.
>=20
> No functional change.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111422.4054=
862-1-tariqt@nvidia.com?part=3D2

