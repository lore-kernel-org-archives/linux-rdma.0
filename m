Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C923C1088
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 11:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791286339; cv=none; b=JffRJWvXX7Mja+gB1uV0W1pf9uzMQJ3JvFXl+JblF98C+eLMrI7pF28vNO6u+EcyRdbMA7LyuAlforFtmelir+IcQlace3zzVsG4r6bDZ1JDwzsOXR3bolTB6vKDDcmAMlYa0a8CtE49kUB0xPHiOgkXtyC/iVB1s3QLW/evIR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791286339; c=relaxed/simple;
	bh=C4Es4OzUSz+tnqrIstb+SWS+QwrLLHUz/vqKEU62aXE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nbkH+VuRrCtcbLxJcRN78hLr76p9qRrilWTLYzIM0urx9Ph2QERdyU4iRzWqN33qi71UDSIIoYBAeAccfQK3fMrROGQKvXwMUvzt64Dh6I8LGXFH4hrl69J5XIwmA3258cFhjNZo9MUJpSv+nMkhldH5+3ppKuJadNNcm/2VbgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzQrkt3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzQrkt3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EAC1F000FF;
	Tue,  6 Oct 2026 11:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791286337;
	bh=C4Es4OzUSz+tnqrIstb+SWS+QwrLLHUz/vqKEU62aXE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fzQrkt3u+48+Zjp8RbugKnhKwdb35DGvzMCtvEqSsmOF3IsrTsyM5Gw3pEeYratov
	 tT8eviFoCMNKQ31poxLTqTx16+eF1Y26MOBEsbP3IjnIWbjRggI5PiP7d2R4Fhe8uI
	 Bh7ubqGc+xzv+PXTRmbU2Wpv83KlzAnAwWEhIUXDP8ssOBFaNgKaGdde0uC1Pf6egm
	 U7yKh9dFs2rTgN2/VkJe19hDtDvnYyVsqdO/fQV00LlTIMxYSf5K7qmADtGoY0MfjF
	 /RirYGQFnYivN3W4elszgBLO4HJCAhMdyw4JkQgWH5g8MBpLFm0nMchP/ldFEWYMfY
	 B0wykvYOs2CKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2] net/mlx5: Lag, reset vport speed on MPESW
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006112415.259157-1-tariqt@nvidia.com>
References: <20261006112415.259157-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 11:32:17 +0000
Message-Id: <20261006113217.86EAC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> mlx5_lag_disable_mpesw() never called mlx5_lag_reset_vports_speed(),
> unlike regular LAG teardown in mlx5_do_bond(), leaving stale cached and
> FW-configured speeds after MPESW is torn down.
>=20
> Call it from mlx5_lag_disable_mpesw() as well, so the reset is paired
> with mlx5_lag_set_vports_agg_speed() on the MPESW path too.
>=20
> Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to v=
ports")
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006112415.2591=
57-1-tariqt@nvidia.com?part=3D1

