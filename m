Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795753462;
	b=vK/6u0meDPWR51m5IiK1YnrIpE4NnjgBGcX8utt400avpM4YPgRke2vL6bPjEWY2aTi+
	 dQsCCSrKVa3hk+unpewFwQotP1R7Y2CSVNuqMcXhEeZwJlEoPMlmy6KjDNmR5o9VNZmmp
	 yptjX7JaePtFnJR4kfJc9xDgaeSeozeLnbgD+RvS8AiXe0BDjFvg+cZV1aaf6d1Xmrl7v
	 +X0rCtQR/9skVDMXphFZNP4lvH8wEUI2CUft8C8KPTIKmvcEUee5jdenTJkHxnqC6rsMG
	 tk9pqcNLafEdRv07HfgUCYP1lsbLvU1pBdcg1ma2NfKPEXHoJZJjhQLVwKlXeomEwcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795753462;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=10WvXZJaVVVnpr4VLBmbJkadDOxREOAFlCwLbxLFUHw=;
	b=kD+waj5ak5AbBUJjfcaNnDTsOAT4GOJXzBzgp/MIn3NzYY6hq90YfFKls2hMronIcz+V
	 PnC/uIu/snL+UQFf+bOo0pVj+h3BGiXLY6RMbXEC5ydn6aKXQ1vYgMhZ00rqTAOTUq339
	 d4hDjl/aWhTXjfZDnT41Xik+rd3K9QxiXq8lSUknQ0NwrB48oc4WV4nQ/+VJfxNXFEO3d
	 9VAYIk6fmGnQ6lviYW9eKlX4VNV+K4WNuF5YRfMd0+Nz/ag3+8ZbtVAjUsgCh5APzSyiB
	 TDCIRSRNkYXr2jlvEUQtaxGz/FLALALeTEos7eqVqbBk0lvQ9HvVuwjHQ+8TzNH2qvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NgoDzogR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4B3606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 04:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NgoDzogR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21F11F00893;
	Fri, 27 Nov 2026 04:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795753461;
	bh=10WvXZJaVVVnpr4VLBmbJkadDOxREOAFlCwLbxLFUHw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NgoDzogRXNTseP2Z7BUInc0t8XzTwpM3/Px4TUqwq+iQgmVK1khM3RbLTeKj7tMPq
	 H5DhMoLshuN50f0rlGQcQ+K4wpkgty+yIPbWFAE75RmzoDi45sWARLc9VOWQ6e2zAT
	 7/iOXKEGibESSQVlFLSFo7f52D6IZar6GfpamjJxEUjI2u4H0YmpKoXN8EcHx86+3m
	 PGxnVU6ZhKNOevtf5B1ujF/9U1ayru75hpJamf/76sYQtlzo53sY/mVy6fQpkb71iw
	 SJeYzB3LAUqnuEBVMoN+X4tRaFjjaJGNETF/cBF6luZP3OT7pqfjX5LBeoC3JiY9o2
	 y+xOq5P7OJUwQ==
Message-ID: <sashiko-outbox-236593@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next v3 0/3] RDMA/ionic: Accept CQ, SQ, and RQ rings as
 umem attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261127040832.16908-1-abhijit.gangurde@amd.com>
References: <20261127040832.16908-1-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 04:24:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 3-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127040832.1690=
8-1-abhijit.gangurde@amd.com
