Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C29937DAA2
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482317; cv=none; b=uBHbymV8EIdPseQu2Jsoq+Synjphzj+j1MdoxjdtZh+zCzl/KjdV6dqEA5oiDo+Uu2FOs5V+BpHqK7jrHk9iKH7PsWGWjvTjZPbIxsuVG+9odFafcxbIONxCYKbLAFvFW8SRfIEL7qff0GcJRaJXA9Kb4ud6XUdTYfm2Kgk5pRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482317; c=relaxed/simple;
	bh=Pgj9VEBypyxaHUnBJeJnQfATeoDNMVYjV9YCZUcNFdo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=otMOXHSXnn/iv9oKjV5UHji72LZusaeksV4oXE1/cNzVtHoWs3VGLieY7V64V+Td9RxfSsqVWzlfiXwhVwJs/U/Fj760cJQv5JHuUSYwruB7Ozk8m12wYUjJA4tOv5j0cuS3jJM36konV0zz+P8I7sTmT4sS5KbgFgrNwh/DGMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C93iz78Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C93iz78Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF231F000FF;
	Tue, 15 Sep 2026 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482315;
	bh=Pgj9VEBypyxaHUnBJeJnQfATeoDNMVYjV9YCZUcNFdo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C93iz78QdaOlHKQxKQimV355eJrtp9xjzTiDsu5U9OJKd/xXG/aEuPbySlqG+Gua3
	 9f7UlVLDv96rCDI2KBisu9s9V9BJiHh2UIY/HPxFNEcpNRAtFKADyhKqEGQjkU4umW
	 gIayXffy+G46H9AZJS1hzHiy1bQ3znDoHiNRFEEHe87AbHDeHpyr3azTmKwAduLcs3
	 P3BXT3e7LjrgaeAfdFObnrLF7cppHW1nA0HoJhHqqIss701YcScnSvNrDlqUGL9GVD
	 0M4hZXfKek89u6MTUxZNXwlCWO9uK4XJFwWDn0A5s1pCHJmiJzh8n/Ju+smA/WKpAX
	 WQZ+LU+gOPIAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 06/15] RDMA/umem: Map CQ buffers
 DMA_FROM_DEVICE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-7-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-7-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:25:15 +0000
Message-Id: <20260915142515.9BF231F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> For a CQ ring the device writes CQEs and the CPU only reads.
> DMA_FROM_DEVICE is the correct direction. Use it explicitly in
> ib_umem_get_cq_buf() and ib_umem_get_cq_buf_or_va() rather than deriving
> it from the access flags: CQ callers pass IB_ACCESS_LOCAL_WRITE so that
> get_user_pages() pins a writable private page (FOLL_WRITE), which the
> device needs to DMA-write CQEs into. That flag would yield
> DMA_BIDIRECTIONAL from the access-flag derivation, which is wrong for
> the bus direction.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D6

