Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBE22609FD
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 06:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010695; cv=none; b=P3hcfBhlfmPI1HYVilG1lT5/vNcnRNMo12yXOZ1LuoxIlpreEoMqlouvCrIaG1y4k8N2D3RCh3AAopih4Wxt8jNHzhIXhLGe9Bfk4avZlggXSO8z5SRcw77H7Pi8GLTRGN7a2H/hGQh32t5LvbbByCxcBd+eKl9JKQjMar5dbXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010695; c=relaxed/simple;
	bh=xj0RCIGUEuoD8130sGV1cXCnPI8QUmPA/sdQJGKZIjY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RKLrJ98DMprffMduNOf8Mmz0rkw6+46LJqXgGQzF5co1uIV1nZNMdsGaCSJc+H1tJ5unxpgel79aaVmFx3tlURU5S9fltdUJze4AdrKF8Yrhl1Y2yP1jbFzrUCnP3VjuSjhAnmqd4AjeZAy6TgkRfqjwjNHz0qkxKRA7gU3FH20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovf8vfP4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovf8vfP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB8A1F0089B;
	Sat,  3 Oct 2026 06:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791010693;
	bh=xj0RCIGUEuoD8130sGV1cXCnPI8QUmPA/sdQJGKZIjY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ovf8vfP4VkUEEDO8q4juosH0FHYAbQi6StmqmQgHygI4Yhk2CKQo4EglhDaPQkABx
	 41X0sFC3oRRtyMFZF+7Qwc610GQSNA1ar3Xw4Ww9tvI/FsHD1BGvtEzo8OpFcp8I6t
	 OCEI/ssU7iWU+k/8gZt55OqQYQWYGJ6TBqhvbPaEZ/3zJp7CiwqtByk9J6m8uoQ1iW
	 /fmkNX21iyz9TEeKDj1yB6IhV71y9XK4NNHtxILl1Q8X6ELyI4SLp555qznDT2dbCB
	 jxGX4seGiCkVR0pmpIeCAf93mhrAR3dhRWirMdbV7Mm/4asT5vRXl3/+b24AK8PE2e
	 QQgo8zO3A9m7w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 06/10] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003064037.2092669-7-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
 <20261003064037.2092669-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 06:58:13 +0000
Message-Id: <20261003065813.BCB8A1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement send work request posting for RC QPs. Post communication WRs
> to the send queue and memory WRs to the memory management queue.
>=20
> Advertise the memory management extensions on adapters that support
> extended WQEs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003064037.2092=
669-1-kotaranov@linux.microsoft.com?part=3D6

