Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513AA4EBACE
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789557651; cv=none; b=lBr3fP6KXj1Fv0F+FH9DMPiqau8+0bIH9duln4Jgqx2OcQV+dw+ri1w0baTWExBMCffGhha5SwQtKzXojBHzFUpwI0ml5riSXRXx6CnugWNyQItsXSwHPMOPGZDkvDhpArXb/f798qBDUqshmRVeH/IUZ2R8HXtk2MkpdfAvB6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789557651; c=relaxed/simple;
	bh=HgQ6qaj30Zu1aH8HYvsYy/KIICAe63JOvYFybDDKlYo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IyVkSa5DJW9hHGPj0cvp9/ObP+Tk9Iq1FmHbG18OE2YMPZfKVFCFVICqZCHgjDXPfp9FE4RePaj00c+lvEG9iQdjLFsRqDYX55LS3RgsRFOIVMYoUTfhQfAFTSd0k/eoGU9C9JEWZWZFuLwnroZtOgO0iXpfdwq6uU5HpFkORrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ofmm+/w4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofmm+/w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0F91F00898;
	Wed, 16 Sep 2026 11:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789557629;
	bh=HgQ6qaj30Zu1aH8HYvsYy/KIICAe63JOvYFybDDKlYo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ofmm+/w48xbQv3ZbUbpEskFzga0jcKHO05hWJSEYgf/+rjGcbdvOCN1uBi0qaYmxv
	 /71p3TGxgT8rcdxpz62JEXR+lWzA/Cd1tlb1LYfK7GJSuLOA8sW83/9i+uR13YKAHO
	 5XLQFbByE0rWIcKwuRDBAafW2zLypXpvAEpemWxX+gtSy4Kl87+QDd81tB4AY+RPx/
	 Cpm11tygv7Kk5gSQP+mWIzAbExNWUj5VPBpDyLpHb/TAE7gcG9rQ7STrj8ER4BZPAr
	 +gThDe4glSN5MygsWEyZBHz2GRZPxyK/r51Iculkmh4NAKZAbAnVde3guNSKtdPegc
	 npMz0mebfzoRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 5/6] net/mlx5: HWS, Handle timeout draining the
 send queue for FW STEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915111912.3926585-6-tariqt@nvidia.com>
References: <20260915111912.3926585-1-tariqt@nvidia.com>
 <20260915111912.3926585-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 11:20:28 +0000
Message-Id: <20260916112029.4D0F91F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>=20
> Handle a case in mlx5hws_send_stes_fw where
> draining a queue fails with timeout.
>=20
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915111912.3926=
585-1-tariqt@nvidia.com?part=3D5

