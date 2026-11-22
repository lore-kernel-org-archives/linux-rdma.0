Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795370294;
	b=nnng/ic8W+KGfMZOiKtCY+kWNTOhPQ7fgL9SFhl1h23uPX0O8cRgToFUscDkKiq6P7Ng
	 dZSCLsXM3ZQKG+ceG5ZKqJWcjthopS88U8ICbUn906UtAnTJQVqTmVgjv965nsPj940nJ
	 0zFWUE9ZpGsRNvsaMwmiL0INTme9gMbX75s9k+qMlEWtlFveeu2nWhQn/SEwcfoOnsNUX
	 HcUAB06sicPriBVNX3jAMpAYmsjy6H8DyEeTlQFe+HJda5ejoO8uQ3vUWBGtCqBkE6F9t
	 xKSDXeZeFGKWWdajYymF3PbTNd1E581oig6eIoMfKeSRlCyNwDGv4qbmKEQthKzZZeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795370294;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vuDdndq5Xk1Jqah62IO2R4qV/oX19tlHIjNN1kJXuVM=;
	b=MHcPJnXMs9SzvGCTEXADtJcL5QjyXOoDL2gXSlqsAQKeibGByAY8oTO93vXKDDLGCwL8
	 GrAMT96DYZgEaqmiU9wppSKiNSAavs0MBhr2jwZ6lZGSkP/Zz9ZWHri+MyyUM7WtVkvVA
	 hfghDMNHhR0voxuW3gjBaznpuCcUr1hp8sRJzzVkSEl/Z3C7nmbWPVa1hJ54pmvRWYRk8
	 wU8BkvHFwQv7+qkHdxRIjIw5cxuA/MzFM6sFS4Ar16qUIH/ms9pKuRqEe+HH5rq+H0n/M
	 fAU/NDkl6Xl7aiXR3HUTzTv7BOB1jKcrW4Zosn7ak54/NnvTtna2f/qG1yApW56Evvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Td90sdLJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EB3606A320
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 17:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Td90sdLJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0C41F000C6;
	Sun, 22 Nov 2026 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795370294;
	bh=vuDdndq5Xk1Jqah62IO2R4qV/oX19tlHIjNN1kJXuVM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Td90sdLJXqoPG3ScmE+hs3GR7R8DI13/t+lAhmrSnLGKAdU9iiTwn93t+++7vC/JC
	 /ZvTGyUcabP/aM1TJfh6jUbKU5YA6Qf+LJH9kQGLqjLIbD4fjrZy/DE5uRZj/MbpRI
	 MfyJlkADoHSOAiG1a1PIYegem5iVscZrSWRoeZVnuA50G2oUCzkfPsyRQFB9brx3yo
	 m2ADWPKnL/ve5TsiSsh4HcwVOOj2t57JlUXXd+BTDPGhnMxT2gcY3vbL2hzp+ZsHM+
	 6+nY6QWT5Bd/y9sqy0QDRGlKk+ZBhI+OgwUezkCfyZJCS4JAh2lz3YVehmPZJJ8GVj
	 BSCXrzwRadsZg==
Message-ID: <sashiko-outbox-228167@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 0/9] RDMA/mlx5: Don't lose port configuration
 events during probe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 17:58:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 9-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122-mlx5-port-=
events-probe-v1-0-0d54e3d53c61@nvidia.com
