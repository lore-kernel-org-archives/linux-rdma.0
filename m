Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11913DE450
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 21:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792185419; cv=none; b=tat2VkdZMzuVsl8ubmX9P5aJvNMlmpUILDTAvqov7FcNnbXJE2MTiczeKtCyKj5JmKNnKMUGdx0gUtaOsx9oM3SdqiFFiBh6Eku1ezqXV2hlHbbjwIJWlAnMaMZKvTG9nunPb2p/t3hb/fxVRfs5BhJOk+SuJfiIjpnd9IBYfPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792185419; c=relaxed/simple;
	bh=h+WGI4gRi0QX4IyHyuuXHgEiLkH7jYGk6bTEKqkpHGA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JnkyUUHGJVLwchm27tpb36CP9+4YgggNB9SVm4sBrBPUA9SG8hwTQQrY2/0CoM8/ihFHrNF19F5cGTJZtYaq2aS3blcn6uwb4yCrzrCMIwY1ao4H8n5WAhCyM7ZttTHyHuF+SJM2zeB0Z4FlXMwG0w4n4DmwN8W5RCOZX7B8iq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBwHU2JN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBwHU2JN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190B51F000C4;
	Fri, 16 Oct 2026 21:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792185418;
	bh=h+WGI4gRi0QX4IyHyuuXHgEiLkH7jYGk6bTEKqkpHGA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nBwHU2JNhjXj1us19DPaiN69TK8ooG4Oz9L2zImbPrhkrQW7h/tAqPtMPMpMmkNqw
	 e0yMb0ZvSGlGvaBZvMlhA/MzDO7CYLR+h+o/LrUz7ld+VbOQ0I7Rv9NU1y+ilApUhU
	 QZNMbGMf1GsdhJYPzy282LcSZBuxQHnNsLC9qSEqH4AIGoYvzHOgAtdqg4JN+yHniv
	 RvfMi5mfkJ3Zl0Afxz6RXEBOUiyoSHe7cuAxUVvk9PBljGzoxSNUqWqVPspTlDARJg
	 ALIMf4GEBV1q0Vndjs7aqqhwQZwqIpVC0YXWluttcpuRRb+513Yk++hR+kwPCRW7cM
	 vKVa3MzRcSR/A==
Message-ID: <sashiko-outbox-174942@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/srp: Avoid reading uninitialized has_port on
 srp_parse_in() failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016211509.12973-1-serhatkumral1@gmail.com>
References: <20261016211509.12973-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 21:16:57 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> srp_parse_in() returns -ENOMEM without initializing *has_port if
> kstrdup() fails. Only check has_port when srp_parse_in() succeeds.
>=20
> Fixes: bcef5b721568 ("RDMA/srp: Accept again source addresses that do not=
 have a port number")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016211509.1297=
3-1-serhatkumral1@gmail.com?part=3D1

