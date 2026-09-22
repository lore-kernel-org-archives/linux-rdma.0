Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD56649D5BA;
	Tue, 22 Sep 2026 22:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116714; cv=none; b=IK48uX6xI3eMYEx9tJOC3D86MaZ4YPI9h0iHFEexrANwzFVUu2nYXdcUlAUcWAZ8cIbwuiRO2OivG9NzDLfooA/zC8XNImahvV66D+K1bgQqm2PylG3xRDfkc4LtX1NwLNqftH33VPDVLUuw05TUN4cGsAica/EHECcj0oSlyoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116714; c=relaxed/simple;
	bh=NIjvk8v7MH1k6tRzgajv++93qDZ+khqver2S0b9bSmU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OA0Vvxy13kdSHiJuNd+JZ6lX8J22lD+iwh4NpGSSZu0Ss6ZNj3QaBvlW6+sdn/UB1kiFEnlY7h8fB6tLJeQ9kNxbZdIYQbV3opYOqa0A1ute1uLZSJB8DzypksVPYRxmu760ikYOoVIJIqsLROsWJ7/R80WDgupIHRbXvJNdXg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5WeO3/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5WeO3/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22931F0089E;
	Tue, 22 Sep 2026 22:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116689;
	bh=NIjvk8v7MH1k6tRzgajv++93qDZ+khqver2S0b9bSmU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a5WeO3/WZR1lOJZroSN1hrNUk7+zMRWd9YZMY0X1s904ofMLLFOnYbXz219yJjhFj
	 Y0GFaRexATwdUP1CkYoR3st4eEOzRPTq2Z3uxneTDzaeQBnjgsi2cUXnCz5vshOuCT
	 NCstQJSnZi30RjbE1BqBPVZFJJ6z8K4crt2dqeDv3qJunC6ZhHB0ycxTEZ3qdlq6lk
	 XyEajXq3dQtkyEyxi3zzo0blhnZnHv40pvnVLq0EIlkyiUDdN+WEV35bVE5NsN/y0D
	 CjdFANCMXnecj/7B/H15B7eKSbYGCErT+nlJRllw4oF6k+p7f9ipGA00AqPpqwX6KH
	 IxYhYgqAh6k2Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 07/10] vfio: selftests: Add dev_dbg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <7-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <7-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:38:08 +0000
Message-Id: <20260922223808.E22931F0089E@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v7-c6d30e8ce1e4+3=
dfa6-mlx5st_jgg@nvidia.com?part=3D7

