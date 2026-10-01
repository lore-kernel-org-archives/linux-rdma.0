Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C623485CE6;
	Thu,  1 Oct 2026 12:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856246; cv=none; b=W3UaxbbUBlSmLghzt/o0ApykxOCYHnnQwqWuVfFRXKjYg+88QYTYm7qsNEYs2yRw2Qgl/TYTRZmQzG0Bkt4YLtL0jZbAfG/Ml3J88Te7HY2kQfkWKvZx7mEEFnQBn94zmRw3iJGDQMtNmc9aZ+GmyTtH8yZX6heNGsW2L2sp2JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856246; c=relaxed/simple;
	bh=5z3oEw7PaUyQs6b4y/rnbrXQwKYoX0vuE4x8zOk8vFU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IGuYLTdGEfogNGqAgVlWS8Bh5mA5SH9ane1niXqpEyLekMvBc1r+TiFuSTbn4stJjJQUsgbeRxyFOKx1o0W2tHu44On32JsH5DMYaDLLXJSnassB2ysECFsH04nWG5wtqkvktL3Vhd4X//4BanDxehhgilV8TsEFDYqiO1NLN7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EE41+fzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EE41+fzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7041F000FF;
	Thu,  1 Oct 2026 12:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856244;
	bh=5z3oEw7PaUyQs6b4y/rnbrXQwKYoX0vuE4x8zOk8vFU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EE41+fzXOJWMpMMz7fBBfxtXPahyOlANFdfBsBdd7BUzBb117LfHYrczizjgcrG/K
	 guvikNoTV6WvUPO8Tv8yx5xKy+48h0DQrfjDXca2Xbp2fJx8LP0nYmB17GhDKnzz8N
	 AGIRGVef8KuCA1YFrvK6vQHvTJOGAbfo6lfI1qzV97t4qEcyqZWEZVUtadVvlItPzF
	 Q//tj1iJ7a6dD/2rt6m+XWpqanAwlzUr0tKqEC7veroflnMJYfzvcVsGQ0mmy+Uz9v
	 CvyJw9CUKAuN+9Iu0F4KVzmt/96q9nCjV5Di7HP8+HPVmqadsEvr1bEU8eSrDCTNzH
	 TwwBSn03ndJnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 18/18] PCI/P2PDMA: Test the routing of clients with
 ATS enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, media-ci@linuxtv.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-18-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-18-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:04:04 +0000
Message-Id: <20261001120404.9B7041F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> A client that enables ATS for the whole device must never be handed a
> bus address, and Translation Blocking must reject its peer-to-peer
> traffic even when the caller asks for the default class. That has to
> hold for answers taken from the cache as well.
>=20
> Cover those on the fabricated fabric, together with a client that
> declared per-mapping ATS keeping the per-class answers and a client
> without ATS answering for the Untranslated Requests it will issue.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D18

