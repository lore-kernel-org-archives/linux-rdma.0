Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0642C2F87B
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 06:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010283; cv=none; b=YuI8UlE2GAM/OI0zNNAtI0bhvvESgOBBLo5TSfmHOFqQAtdbwpYquVq0018NtR8XQN1tSl+n0steg2EQRr0veyLw4jGGA6vf89SUNfiBF0BomFSJSwZa+YSxrgzv481+Pqn69k7hj8hjl6s5t45F/pEhJYhZ3CLNo8emZjaYxBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010283; c=relaxed/simple;
	bh=IYXMZCsUIDloaQC+QRlA645Z+fhWoz5mt0pCupOTd/8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FbOWsHt4+PTvUK8mxPuAXm2ApIzWiUgQp/kHOvbb83hN4EyytchfszT+hFPcYi6FEng422s4Y272EKyRaG9aRnVXfu7yK7UaZJrJWXkiYbCn45MigNnYi2hd9UufKmNZ3noUdN1HBrTXo0MYhbEuyj0SPHOlPH67YgnsUTyUWvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCuzNsC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCuzNsC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B49A1F0089B;
	Sat,  3 Oct 2026 06:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791010281;
	bh=IYXMZCsUIDloaQC+QRlA645Z+fhWoz5mt0pCupOTd/8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fCuzNsC86GyaLEXrOwULe0a4DealHcjXeO4vK/d1VQq6UGIyvMB77tOSr2xUd2Tjj
	 wBPiZ6R9sOca4ySEH/LcDUqUC/uHO30DOMafZzfUUrtIWb64URqwazs4dlhR+N/m3b
	 FDxm76HRqHiN8Pkdodh1L5DLX3Qq7dxXzdC/kYfU9+orI9yb4MFKtmofY7ZFMBxKNX
	 YE0cShwsh/kDefX62KaoV2w4LHRRkM4pQRWUfE0RurT7QTAYu83LXpnSmd/TQ4a1lC
	 58qABJWMQr/g2xhy6ebYQ5/jszeevTlsP48SLpEuMLUij6CTsaNHIpZpfL4XWS9P2G
	 Fmo3vONqWC0UA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 05/10] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003064037.2092669-6-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
 <20261003064037.2092669-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 06:51:20 +0000
Message-Id: <20261003065121.5B49A1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement receive request posting for RC QPs. When posting a batch of
> WRs, ring the doorbell periodically to prevent the u8 counter from
> overflowing.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003064037.2092=
669-1-kotaranov@linux.microsoft.com?part=3D5

