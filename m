Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873690;
	b=yzjYeOZTWQt5zHlBez4L3uZIDvf9zkRztQkB8H1H3JwGjIwCDhtIbHl+bM/N3kVhIH/7
	 T4X2hCvu0fnWKoj+5DdgM1mTxeqBe/GaeD0lbEdJzx7w4GlGM9sd3gXFGyIWJxHqYjlzm
	 mG/M8O3k/tqmWAoDkJ1aY4x72lxjDJpEtnN7O8PfjeIvRLUuWWhfmgT/vWov8qj31dMsv
	 I9SfTN5zEN66EG4aol0D+QWk6at1r6U1D7WTI5CMx9iy7Z/8TgzNuG2jseD0mvxqg3cEG
	 gL/3Ha0qZPNrLkMxcR1nsjWYaQeuu0lVh7eqk55vKlvV4H7U7CLgt/00rqOJQ5O7yew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873690;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CYYFIwuIDggklTvJ5pkhzsoy3a1GnhIAHhHZ0/5ECyc=;
	b=L9V/c15XEuszgTWUwOg/+W8k5SMQGChBR61bRgIfaibhz3WqL8mWFkZ3CwR7BCVidByu
	 izdOibh2E0DiIGeQG1zyNr8Ce2Apm4ZYEsWfZkKxK03W04Mt2fAQZ1+E/k0t9J3phLa3z
	 5TkL66qQMSN92cbZTEWLAlrjcUg10MO//GfFwh+ZHpRDfXG856A2NJaKTICrauGVtFlvK
	 2umxisBg+stmTaFG3rvh8P5WmwMyTdjlrYMNZzrCp2TE/DFlDq4ajQrFbLxHTpvT3Up3a
	 yWBqCBYji4yKGbLPAQ9mc2WkgBb8qWQD8d0byMz6VpBIJB+4fHYlMYvsZNXKsO/4vBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mqODm4q8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08129606A33B;
	Thu,  5 Nov 2026 10:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mqODm4q8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724891F000C1;
	Thu,  5 Nov 2026 10:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873689;
	bh=CYYFIwuIDggklTvJ5pkhzsoy3a1GnhIAHhHZ0/5ECyc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mqODm4q8HN1d1UzIe1PRjV+mMNsgDaLtXAGt0CiybA9428vphIDS7LMWSa1Zpv5eX
	 bybx5KZCc83UOIJIU5+rpL+s338FIXGvzINp/LwjEOGTbLglwPWPIKG1ubrJyWqUAu
	 ZoxTTW4rlygmPbN//ZaxlH75m3UIH2kwoODBu1w1wOA0ERqMUs1OTEAslm7vcOIeOw
	 sVvzna7DyQ2eJJaCMLwlbfxnEiCExxCPzM3TY2dT7Mk1/7xp359Lh5l0cVTdqgCN14
	 9xtWZUqInDy+NizG6L32u9Gkqjalc0HBJEqMh7KvSwI7FA176S95n5ebGCLmFGQ+zC
	 8jdj2lrTjT4qA==
Message-ID: <sashiko-outbox-198826@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 11/19] PCI/P2PDMA: Route Translated Requests under
 Direct Translated P2P
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-11-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-11-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:14:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> A Downstream Port with ACS Direct Translated P2P enabled routes a Request
> whose Address Type is Translated "to the peer Egress Port without
> redirection, regardless of ACS P2P Request Redirect and ACS P2P Egress
> Control", per PCIe r7.0 sec 6.12.3. P2PDMA assumes every Request carries =
an
> Untranslated address, so it sends an ATS client through the host bridge
> even where the fabric would route it straight to the peer.
>=20
> Consult Direct Translated P2P for the PCI_P2PDMA_TLP_TRANSLATED classes.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D11

