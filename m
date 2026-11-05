Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793902085;
	b=Rde1v03OqDKUPkGAP8zD8VyXLn3PRv3eSjlCe4cpZe7Pkge6KeE72EaZu8W+epMj2W5X
	 5MvWCmiEtU+gGQklwNV2aQFIrW+3SaCRV41Opc2BqYEExACIz7ohBR1D3JvDSmopGysLv
	 riXOVNRWU5i44RBIdmWt7yL4HW/Ye29HYNENXeYq+n4dDBSgZj5l4qLJbPfqrzaBNGHPu
	 I/9aE1SAMTlKAI/5HaLaBl31i5D4mBBtD67VcE97LSQDCXZ56+FPu2cvur94ENnf5MWS1
	 iYBXfM6P3lrtUJfsmyz7APgA/oiYxDM8g9aCO4926wQ9CjIPSqvQsj7lDx38jSgPFXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902085;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=toGzM0qYoObh8bgXJJu9UvEfZ7hLuVMjNntvlPxPHrI=;
	b=MN43WTBFryZyiEAhbi87z9fCQqfNbNQOy7KfL2hpcAm2HOTaAERJVjXJPIFfL9DpJytt
	 F8T4TcmuDisV0sFv1ZH8bwjYRmvb3dkfAYuoRVcIOu9pWR3YlDncesYDyP2cXIYvfGEdC
	 QGEDr6sjC3X5U+ba9JIBmKCJ3SMwJV3RF7iqvW23v4L9+iIpK34NuqDip8fczJOTdC0jY
	 lxeVjoZXy3OUTEwTC0Vf9/FkVxlhWbZyyZiCd/hOdS/kFg/WP4PYRnek95fk03x/qstl0
	 OVQ7QwRIR7uIKehJ+1O25XjN6fDM4GrBWgBhe9az8jyM7CQBJG+GTpILGk7MtEDU5QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZVQxFH7+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E50E606A31B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 18:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZVQxFH7+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD331F000C1;
	Thu,  5 Nov 2026 18:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902084;
	bh=toGzM0qYoObh8bgXJJu9UvEfZ7hLuVMjNntvlPxPHrI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZVQxFH7+ASd8RarikD49MzO0/gmNRIWrFErEq1kvN3WfPhjc5JtPIHFndxre/owhN
	 5lN2SWJWR1f5imvggHJXBb6wbbZ22a+IoyoK0ubybJz0ECtPeIL3q0dOZTEIlKvKKN
	 F8Rut7hlWPgqkANcg/a3YEalCOPYUItW5BXZALPaMxed5+wSTYp5nC7Y+VfOJcN9Qj
	 Ij87dM3gRYtUQ2/ZLL+iN9lx8COp2UT451GCxuw0RZyUVjWNng+z0KfenBjdeUHQqF
	 7SECw3S/jScswogQfJhXTFLCZTrBDiEV/RJlfaDUWAJ8zw9wrqLlySO80UP3FlM/gD
	 fJuu/HHT13rDg==
Message-ID: <sashiko-outbox-199693@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v9 5/9] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105175928.1326682-6-kotaranov@linux.microsoft.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:08:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement receive request posting for RC QPs. When posting a batch of
> WRs, ring the doorbell periodically to prevent the u8 counter from
> overflowing.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105175928.1326=
682-1-kotaranov@linux.microsoft.com?part=3D5

