Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E80242D65
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 06:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010440; cv=none; b=FojorykHq/NZJa/yvYu/mS4ayIvGS+G7/UW5kxV7iri2IdlD7C5OfRPYPBrJKgtVAmRS+IAZ7NC2ueya7wSBXjXjgNIlDgeheSCtfqZ9ZSxbDT49BT2L8maOgIuMZvfhYVNkJO2K8bWjxmx+P9rSa1V7yU+pI6aBU0NuXkfo9gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010440; c=relaxed/simple;
	bh=h4ojaeaT2wKrC9bYsz33rmTQr/9VDWDNEZqMzzldGLE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CifvVD9jwFLNQMo+uY2XZTqEXb6T3LwkCuF3KW5EcLN3JfQ5CbPxM38cjGvjDJowDCRfmYKSo8wL3u20t6tgEy1KrKKTM4JLmgURX94R9/WqVnzB6i5jcKcwOzOih3Bce9X8USXU/3Dae28Ss6IDuN/zFOJqOwHzBclvRvA6OTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmSZwAYI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmSZwAYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9B31F0089B;
	Sat,  3 Oct 2026 06:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791010438;
	bh=h4ojaeaT2wKrC9bYsz33rmTQr/9VDWDNEZqMzzldGLE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OmSZwAYIy3UuJIxF06w9vVAsf6ZK5TGYydz5/fxEtWofsHPrruZSncD4mk7sw401c
	 fxTVxkqJmFIdeYT8G49WkQGwVWUNr/q2PyHHmi//ugr0T84o3HEfHonW9xtxQSCOQP
	 hd/6oyLuYwpfZowOsB/te1iqPSo1tpSvPBfMWAj8VgIWbO27o/AT50g5qyJrwDV6pq
	 ahuEZ/xnKo+ML6qEdNlK5rvzNGsf3xt3xN9LyYUvbA/PzwEioX9j3NFrwRWex11t9H
	 tUM4z7TIE0oGjl1BYvW6/HcIGC9WsP1C9+y5mxK/hDNQwy+qmbuhuczDYZj/JctFQe
	 B2ILY/UIOtUlA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 09/10] RDMA/mana_ib: Handle error CQEs for
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003064037.2092669-10-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
 <20261003064037.2092669-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 06:53:58 +0000
Message-Id: <20261003065358.8A9B31F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Decode hardware error CQEs and process them on the corresponding work
> queue. Complete the failing shadow entry with the vendor status from
> the CQE.
>=20
> Defer transitioning RC QPs to the ERR state so that the other work
> queues can be flushed.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003064037.2092=
669-1-kotaranov@linux.microsoft.com?part=3D9

