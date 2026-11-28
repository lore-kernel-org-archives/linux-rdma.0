Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795874374;
	b=CfV1RFn3hqKCA6TijIDip41TwxwY7ZOkXO0hij8dNnCYalj/2oBRH+zpFWdLHbZllfyU
	 jRDXy/JySf6/Tihaup9W2DNVdwUUTUa85H4Tp/qfARLpQcFAn1xMdSDluN0YpZ9v43+pq
	 ikZY8iuhUl0epnr++6PcDFWWh1c1L0S5PWYZG++lmP/GFAtbaxq2NDWW/iW435Gbxu75u
	 MWnoG5x74NZjPsXn6c0TeXHplU637koWbqCo2cLJUY9eRlPVZys7jSlbMrqwYgLV6ntgb
	 o+1BQp+5+AEyHj0iWTQlHOc2zeyaCU7wr4oBZ2qYi96N7SYY+VBHLeo1jyDnmuSiOxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795874374;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tUrf4Mx4AywpaCzFPIxTZCmWORKngTkKS3HqHvX/vrY=;
	b=F9662b31EyWWVYBqwVqLENidOuLeO/ATuCl7/XUE5xD5bGchxPpLZDAZnMiS4oK0XmGb
	 g3il8+0hIaFT5kpelIdHgEpVz3G68mfZ1UbEpB29oiBjXn7jlKJbIhyDL42PpZbWhjxrS
	 K9TWQ8WSfbeObbqZeSnwpOPCHX3CCqI7wzyGPbZc9ZIhfEGFPiE/BHJhzzLQvTBxGBJX+
	 w5Lyr9iGC+22LhwLmDou6fulMwl2OGKPHvW6bKx6SGEE16ocNyj0Izdk3Qs548QFO+tQe
	 T0wvu2RE5xN7eSDIYeUadMXpz7Wk/hJXgCyCGjJOQ7euGHbuhK9i8YdpAJSIkya4H8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S8E7oFqI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8511D606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 13:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S8E7oFqI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21B71F000C1;
	Sat, 28 Nov 2026 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795874374;
	bh=tUrf4Mx4AywpaCzFPIxTZCmWORKngTkKS3HqHvX/vrY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S8E7oFqIULpR09VcFLYXuOT1b7vcKGitACHaUNkTrlbddAFDbZfxyX/XdbUNS4MgB
	 8eADvAOXnJMc0MjHpkakCyCc0YmgxX99GXPydVWRv7pfcY+z3xPV/Qt7puG9BGy/Yz
	 6XwwzdIA04Fn+n1nZChXQGnvz7e3Uy2fqMf0bPuKg3ZzyFK3szToakiVaLp9eDi1sE
	 jm2/0nVIbG4ERxziIF+sh6MPUhGVJA2Ut8uOweonFVUMoyirxexoM5ue9Mw1wJGmyp
	 TRGfhaLU/eC23DIInJJsZptm9lVlLAPZ4ZfEkmSCkCrRVkUnmMA8iQE43BKjZjRQtV
	 611UeRtT5Q69w==
Message-ID: <sashiko-outbox-238738@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 0/3] RDMA/mlx5: Support pinned revocable
 dma-buf import
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261128-mlx5-pinned-revocable-dmabuf-v1-0-a4cde143a58e@nvidia.com>
References: <20261128-mlx5-pinned-revocable-dmabuf-v1-0-a4cde143a58e@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 13:59:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 3-patch series:

- Patches 1 and 2: no issues found.
- Patch 3 ("RDMA/mlx5: Try pinned revocable dmabuf import by def..."): 1
  potential issue (1 Medium)

A detailed review has been sent as a separate reply to patch 3.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128-mlx5-pinne=
d-revocable-dmabuf-v1-0-a4cde143a58e@nvidia.com
