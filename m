Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445030;
	b=5JL5xoS3IH8xydRFc135GyMJzv23rYLuSIDvWquvArJ4HWlcL9pjShq8EQk7/GLfGg+f
	 PEiKpQpi/9NdeK3u1g5nIhJBVDkNNLtLOoHtsSGS3sfBCFcLzR4+t02eJNep01x2wRzvt
	 VLWMf6wzx2aFoIGLjoXmpSVnzi0GGux18FVZyzy+WkL6OyXxuYIzDB136rlQ949CdZR6n
	 +avUFAuftgwj5oblL28SVw21ucyIrzU2oslkiCipy4E1IUifyMtY/BW+JS5kkCS/WDbrN
	 2yT5DxLNmRQITIV7pKzUi70vXRatOkHkCAsVtEoLifU2RHa5xXEocKl4voot/VK8pDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445030;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=90QXvIIUx9sVfOBM2oR40d9exhKznp9HB92wnyt7few=;
	b=CCpx6crQZmpziul3Jij8ztn3tGk/pic2HHAOJBmqEbSsOt4wSllqoepjMYH1h4W4vDT7
	 vG+OhrjwvVl3zqHJNi+T0m80O5wYl4Yb6zMSrRI7Cgs9y6sOKQr68vFi9IwbvJbK5WgSZ
	 0JmjI2Ex6lQSL3bS3pg28/dFRPpt9+AEIQ4OlMGH6aY11UN8wP71nVdVbFSaYjzlLyF50
	 H2e/k7ePwQyeEu/1szBk9MRHyOY7r/MeAwR6c5t2gBkBFoWzd+ivGYJxNaFrSvmowPvEQ
	 G0OWFSsORHzfZ+38Rc6IiaK5Fqu4fKJjhMQxhHYy0v5OXX8+aPYUJAO5vfvhkQhfycw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e1+QW9zz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BFD606A884
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e1+QW9zz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B791F00A06;
	Thu, 12 Nov 2026 00:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445030;
	bh=90QXvIIUx9sVfOBM2oR40d9exhKznp9HB92wnyt7few=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e1+QW9zzT7Y7ilHUk5Y6wd5kSX9YA0/Z2FRdkV6DV5+XQmcdpMQBXIjcxynHwOHOD
	 L3vOaNJq2uct2+tzJqdmv39lf12SE6aTDNAnSVLTFVfE5BCRGs0kGG8gvh+xJRIP26
	 IVl1lLPo5G6jrSCPL4GnsVB9sEpvttuD+kIuC9JPYQUe27SuxlygHbIjx8VzT5GT2W
	 /EGeVjZXVwkerr3tUXUQ74zWy4bTAzGz2JVH64YxQEWKu9Dhgsog7GLMqCh+BFfFhh
	 N8AoCXVkEJSRXHuR65iMujlupwo7ZsnlFgDar3Eha7io63boGwULqQCfrIruEAb/1I
	 jNKRV1M5hcw5g==
Message-ID: <sashiko-outbox-210018@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 15/15] Documentation: networking: psp:
 document socket-less associations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-16-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-16-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Describe PSP associations, and how they differ for the socket and tc use
> cases.
>=20
> Document the new netlink commands for manging socket-less associations.
>=20
> Document the psp tc action, and flower psp_spi, psp_ver, and psp_dev
> matches.
>=20
> Add a new section to describe pre-existing PSP device stats.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D15

