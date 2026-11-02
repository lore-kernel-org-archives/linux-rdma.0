Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637977;
	b=B5C3Nfmr2BlKWO4QhYlQXh69hjWd4VrFD5eZGt1mXzc7ujrk9maQPH4WlSK8aOa6LsS8
	 yCL5ac/ngLJ4npFs70OBhbvmKv1LFW/i9kLL2rsXZ4+1L1ruJBgJxjTl3f0gtuR76X46E
	 3TID5ydpg4B72j7vOyllZcs7AEhGve5HePbzmAvYOzuih9Ejf/a/KZUPQ9rIzh9Uak7Rr
	 QQHy/KH0t/x0LG4b+hgXu6Ux/muF0FWCpRBUmWRiAgsBTkFwzRPgWsa7E8hivKHwg8k0w
	 ronKltvd7gz9meKnoQ9AsmBP9SPyYpf0YeV0sWlYi8eAfme4IqkQtGJC0niGvGGhgyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637977;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KiMQ8TcndZKd/Ov24+QvluRDNhVk/2flO4I4a1GLalc=;
	b=b/d3w4ZSydL5G2thmpyEpKx+RTuo6+85MZpkLDuYelyAYDLj1aFF4D3CturFYdcL1/dS
	 QdTVLmOSsMS4V5zRN+aFltgNsS/wYO3ZE0QdaVj+r3SsjRKoi00UFUiF2LE0Ko1w/uRIu
	 Ug/Uz1cZ89qoGYz81z/iw8uZFrlvSgujonByvUwqnm5dSyTeMp9CTuq8cveiSTaLNWCP6
	 kTbzqZq6qnNH9esNfWYPd0JS5YAdVfG6xDkqfhGluKT6KhVRrea92PpShDf7N8dIZ8H8y
	 9RyURogl/4TT7kZTJEiX6OWALRgt5mB5ZdRWJ6w6zKwS7sETU66KLl6NtlqrCVR6zaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GJGVMTJl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E979606CEE8
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 16:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GJGVMTJl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B8C1F00A16;
	Mon,  2 Nov 2026 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793637977;
	bh=KiMQ8TcndZKd/Ov24+QvluRDNhVk/2flO4I4a1GLalc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GJGVMTJljW1J+/zpbnAx3MqK5IGU5vsHAXP1mMfwLF3u23mYaipsdYa5iYeh4tCne
	 Jo8DaMX+D+E2sspN9YsE6qxQDJ4lb1mUnuawzomneUYR76BYrGawHN1p1b2mp2zu1I
	 VbQXQyWiU2Mw62h/vhSQ48Qe2GeIqbOIqjD/+0LFSV3X6V2dAZdF9DyKEWgdOy+/dr
	 9f1/5JR0+12JIH4oPaogqujUXD9SMttmd+4KsxcBAACK2Tfs/2VZy4fZAdf+OyGd1j
	 Dl9G86w/DUeYDBUBcd+E6CLOd2kjhIJhQJec8OiqwEY8WOcHJ/W8KxSpnmFGOM5NRc
	 KwRAxkVTZeKgw==
Message-ID: <sashiko-outbox-193771@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v7 2/9] RDMA/mana: Create and destroy kernel
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102162505.501853-3-kotaranov@linux.microsoft.com>
References: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
 <20261102162505.501853-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:46:16 +0000
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
> Implement kernel RC QP creation and destruction. This feature requires
> extended-WQE and power-of-two-SQ support from the HW.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102162505.5018=
53-1-kotaranov@linux.microsoft.com?part=3D2

