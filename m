Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBFC3B5F59
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 08:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791881564; cv=none; b=bui2HAGFNb00MPCzrWm0RWGgtomJm5VBky2PLzbb6D1luwfdbxAvvXAAEJEPUmfOcO1Avut+Peve18gnIuzBVOreiFp1yP4ZxcznlE6fud5ROiAraZzvnPYh2lQjCGGJSQqIbATonL675sE80+hpadtQ58hl8IJbgr0PEArWaGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791881564; c=relaxed/simple;
	bh=zc/cJfXdWlKS1bhtjqYI2F68sxPSGZsi/xhRu4IhXTM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=c9822cVLndSX0pchl6AHZcszwuHYZiMGlzdOdK1/R9h8CFnORJJ9iXXvte84Md8C9rouquJL4voOd8xlh3aIlUCKSyvPORzZ0d3H61SgR0k5MEGDBj0805PhA+QMv4SbZZL5neIdzAWNt51RoG1sUoV4jJt/4fg8KHl+/vd3lVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ef7ykAIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ef7ykAIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965F11F0089A;
	Tue, 13 Oct 2026 08:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791881561;
	bh=zc/cJfXdWlKS1bhtjqYI2F68sxPSGZsi/xhRu4IhXTM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ef7ykAInvdvkr4RN5AEh7iaX6sOL9bGcAkrnf3IAIs5x0fhHrgKGtn6xm6GDHc1tY
	 8cIuRxZPD/vEHFAzMB6mb7tjBFUEjdIDZffpf8aK7oVoyDWQj5d+yona6uFGTlfifs
	 n7fXwd1dMV4i4jOMlZvTL+tdeYsZ6WvZTkmFHSf9hAB90PA6cNjSPfVa6yfH4UARUl
	 N9oI1Yc/3Ki1wRC8qGCVcM2oXhwRxE8cpk0Q8ABs1lERDQ5nH9fdCAHlBZJofGaPLo
	 qBCXFe8gMXDsa6TAzfy/HhlOQbF5lNRSy1hynRgadnB+e1n4IFFoiL2I3NEGwtozwd
	 2S+1jq53BBsgg==
Message-ID: <sashiko-outbox-169284@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc 1/2] RDMA/bnxt_re: Use kvzalloc for QP table
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261013140427.256612-2-selvin.xavier@broadcom.com>
References: <20261013140427.256612-1-selvin.xavier@broadcom.com>
 <20261013140427.256612-2-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 08:52:41 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>
>=20
> The QP table size depends on the firmware reported max_qp, so it can
> be large and a physically contiguous kzalloc may fail. Use kvzalloc_objs()
> and free it with kvfree().
>=20
> Fixes: 82f1f575aa13 ("RDMA/bnxt_re: Fix allocation of QP table")
> Signed-off-by: Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013140427.2566=
12-1-selvin.xavier@broadcom.com?part=3D1

