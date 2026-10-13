Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F4851119F;
	Tue, 13 Oct 2026 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902364; cv=none; b=UdclpZDuBbBuZLapKyQhAN3B6rn4tu4fSkG5F4Rw63RrYadietrNSfHePt11bxOxkmzt84P1OowJi0dwdp7wZMSpuhKSSHuMyYCLUen+i9BP9O1YinG6GGagMfiJWCL/JfA9NNcJdlh2qbCntAn1stdwi5/eM2X6ymuZ33XbqUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902364; c=relaxed/simple;
	bh=zR3m/vtKbsXcYuDgq/+uqLCTwLKY7dcUv6ekkXpxvNY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=daw74U6QB5s5H3JTtbDVeTwXjzN02IBm5OGlYdV+9Tx2c+2VI2pt0oUFAutviuMrKa7HKTtWayDLdI1G/vPYaM9RWQZCXxU8C2rbJ0R6H6l1JnsKRPcqH5VTvKeH05WWeT/Rq1rMBarFgdT43N94Ja+HI3oUD6uRAXYREi0bZTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZ4c42Kr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZ4c42Kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81C01F000FF;
	Tue, 13 Oct 2026 14:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902362;
	bh=zR3m/vtKbsXcYuDgq/+uqLCTwLKY7dcUv6ekkXpxvNY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YZ4c42Kr4pkNS0zp/7IKDegO15/S7v0TNh7MtOgfGebGtG6IuoZk0NKdkajC/DcLU
	 KfORwNVNXuU3M1JiIiQ0VxRvhK6rx9/uTEGJih5y1+8C0x8qY8Z9PYkFRpECyT7fjd
	 c+aXrZShCvG3v6kJOAZqH6fGhOEnKVpXG4oAmYOwkQkQRXTZdrbrP0XVoc9IKY9uxI
	 TAd9Qk6oePN3hyxUU6SEIigM1pv3heWvrsyuTM9nciDFAZ7skazwmQlh4KxHS9rfh9
	 JzjHPgAvaoKvaSGflDULhPQFym+UTmwbgt1k+26CBcnKhKOI3skmJeRmtOGNexkwIu
	 jR/+KhPSOnq/A==
Message-ID: <sashiko-outbox-169925@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 16/19] PCI/P2PDMA: Document TLP-class routing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-16-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-16-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:39:21 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> The P2PDMA documentation leaves Relaxed Ordering and ATS-translated
> Requests undefined, although routing now depends on their attributes.
>=20
> Describe the three TLP-sensitive ACS controls and the outcomes for each
> class. Clarify that Direct Translated P2P and Relaxed Ordering cannot
> create an internal route between sibling functions when hardware lacks th=
at
> route.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D16

