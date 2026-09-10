Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B0C3C0A15;
	Thu, 10 Sep 2026 23:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084712; cv=none; b=ezkJJGCc9kLY9Wt3w3SKMSwThbDAz5dmvqh/50ExkCVxyWrJ4VsOZd3+E+Oe1aOvXp24L1QwUiJ835F7WkY1zPUSezTX+IicFTTDyCqdeix9lZmHp5xyvn8OYDqEpDIUf1cXtSAqoOkGA4RfGE+RJm2v5LIRkPFzQDQAXroESSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084712; c=relaxed/simple;
	bh=rUlbpeUrVbzPhwi+eTd47zPoAMDGP/lpV99I010Wv9E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EAyFVQ0xkT6huA9E5cGMqADnwXRM+ldjpoHtyrMjhn7QjQ37RyRjszND/uUXQ/7oHFddSZfU7wmfmsz09o1QnfmOCPu8Jmp3p4kMpFrU8cCGrG7Jy+qODrY7pRyI201r1njUMiRViS2hq5ApaH4G+9ulHTwAnd3e1KKZgxuUSIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NbbBr+RY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NbbBr+RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9FF1F00899;
	Thu, 10 Sep 2026 23:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084711;
	bh=rUlbpeUrVbzPhwi+eTd47zPoAMDGP/lpV99I010Wv9E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NbbBr+RYU3nZkLfHDI4HwZwsyE17OFAd6iKDj2FUm/9j6+EYh0jMRZ4YziCDpD5b7
	 54hWptCnHj+QPnW5OwGTcR5fj0ZyUglACjCt1MNFkQIOcCmwkyJLtW1ob4yLmMMmsO
	 vsa+pMNDEYSI5HIQxm3r80DhYINuk4LQc7vKZIHROP+rPXFJFuc4s0g/gl1bxW5YRi
	 yaLOe6uPyz9KUqjDl7bAYDtytYa9hkHh0CDF1GQgUKxtnb9pHTHXNobgfNpEQQM07j
	 P9p8eNXYQIi38L18jpSCgMN2i7OBiifEvcrOBuBsknIPD7HxI+t9Y8vhP+MVCqgHQa
	 XFmL0k8qCR4fA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/10] vfio: selftests: Add dev_dbg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <7-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References: <7-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 23:58:31 +0000
Message-Id: <20260910235831.7A9FF1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Enable it with a #define DEBUG at the top of the file. Allows leaving
> behind debugging prints that are useful in case future changes are
> required.
>=20
> Assisted-by: Claude:claude-opus-4.6
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v5-4cacb99249f6+1=
b4-mlx5st_jgg@nvidia.com?part=3D7

