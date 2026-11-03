Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712071;
	b=bkRb9FEdorrfWfTdavyM2v2hzaSU2frM8G91XeOWE4xQCNyqY/Luj4TqqkUDlhYjirj5
	 xHpSWC0NKML1B3jyPEpI5uHzLxg6QHWPyyrz/mk6kcuwrErqtWSXZhNr3TZZHSbe8ieTd
	 Ctk+QWRcjTKNQ+vmH00FTjCDV13lvQPie8RzPKCDagzwK6XiMhlA8zz8QeqghUsk+FSjN
	 0GnGZzAz2i73VfwLkPr1C/VDGr5dX45apu3XlAbAKdTZIBynS/u2H6ur9owyyzPFZHjAz
	 o/s+HJA+6C+VGUYjG9MJxJIk740iveKHNIhqgmnVRPUafwMXTXtM92aVFuVOYTHHltA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712071;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=piV3yXbVBGVZYSPmL5QA+vO1iQhKP4xYX8t1UtIlCxc=;
	b=Y7rv2CcX9iQx4bq9r6jFQaHzHyvl/rKWeRGhVbo88AGvfTI1E6F0UHn8BbsphrX6K7qm
	 u0Vwd7oHrFqoLfDMaALw1E3eVoqZJfLuf+XIGnf7OlzBGPx7qfOBvIx9mUciM6RqQv/PN
	 ucqe7VfpxXxM/WYVFNsL8q4n5vcndowyf3yCRbyjmxa5eJ5VNxwpWaLZd2nGfwVU7TLg5
	 gsuhxANmMhDTCSua3eX8/6r05+6DLSIpaJDKQWIStyMdDavdVCnnTbfAL/FEpHmN6cIib
	 rQ4T2VWZIsQidzGdZ1A+4SmVurhY86DbzSXash2gJuzb6nvbYBSzijkkCxsnXTBMp6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fDKDNRpy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE477606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fDKDNRpy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7D01F000C1;
	Tue,  3 Nov 2026 13:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712070;
	bh=piV3yXbVBGVZYSPmL5QA+vO1iQhKP4xYX8t1UtIlCxc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fDKDNRpyqdUktkw6KAmD18e4XDHwOvv3EGVvOwOFJ8CDYFWy0HDdLZl+aMLcPcO0K
	 WsNzeHXonndGYcMrxnYQraEJCdT0vcGIl0MtXHONLasJdnk6j165aa40MYVee5RS2Z
	 koEmmbvzMx6S2zVSVu6FqoAx08E1wiAmL+BaPX5OmRwVHB08MIDILgYKYBjGVR/jSb
	 N7YpWb7NqW3vH0ZaqHB2FRlichfto4W8QS5pPqvT10KxTux883nH6hGCs/YMfJtT+7
	 JjBqjXIhffVgcpHpZsXmFM5hfAlgGFSuY74YmUwZlKGvF70VLdXrBWwAbdBeHMijq8
	 fmPw1TOcp64Qw==
Message-ID: <sashiko-outbox-195325@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v9 4/7] RDMA/zrdma: Add hardware resource
 initialization and verbs skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103125654.2707069-5-zhang.yanze@zte.com.cn>
References: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
 <20261103125654.2707069-5-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:21:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Implement hardware resource initialization logic and provide a minimal
> but functional verbs layer skeleton. This includes basic device
> registration with the minimal set of device ops (owner, driver_id,
> uverbs_abi_ver), to satisfy the requirement that the driver must be
> functional and have a valid driver ID.
>=20
> The hardware resources of the driver are held in a single allocation,
> which carries the allocation bitmaps of the resource pools. The first
> entry of the memory region, protection domain, queue pair, address
> handle and multicast group pools is reserved.
>=20
> The device ops are exported so that the probe path can install them
> right after ib_alloc_device(). When the resource memory cannot be
> allocated, the 8K index counter array is released with a cleared
> pointer, so that the dealloc hook does not free the same allocation
> twice.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125654.2707=
069-1-zhang.yanze@zte.com.cn?part=3D4

