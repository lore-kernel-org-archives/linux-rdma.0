Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAA44119EE;
	Tue, 13 Oct 2026 14:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901948; cv=none; b=Igc3M5pQy2rCwEf/OLsSbk0No6HSLjSVDemSApU/EzYQJmIRS8NuFpexG5WWDzk3niIbm2FlTOJmmsFRaNoYICrrnUpeCsoBLZItsgNuNQFn0fR1ULzqAdxYWSWVK1InHaEqjpKYpL6PUlLpgiR1ApW2Olp0TCP8QoDURxj89JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901948; c=relaxed/simple;
	bh=DNPGTno8Q9aUNcxBdK1W7jgkWh6emdfjKj31dmKmHVU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IKGmPdYT0/AvCapq4Tz12wT8OPlpMpmU3O4m6pw9AHydrHGG3I9upuhL8QCfodCgHpcGfg2LsSzTPHMFbfNRSXIYmE7dH1sUDl1eUCt1fOEzrZ6UaehVvZGhryFJB3ooRyNlJYT8a6pEqmd9+k93QjbHeHRauLbbnqSLhvjEdX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FL3MrqAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FL3MrqAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F811F00893;
	Tue, 13 Oct 2026 14:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901947;
	bh=DNPGTno8Q9aUNcxBdK1W7jgkWh6emdfjKj31dmKmHVU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FL3MrqACgJjtPGpW/6V/lHjHvaw0rfypmkdxH4iKNv5PPyI6bmMjo63CLeYvQMQgF
	 9qXP9bvr09cOS/rc4/t9sJVRkGE1tXxgLI6QRoyLjWORUVELxukc814BlIVSSV4VRG
	 xDtIu72j8/gltmM/imtigUcBbygQ+F0OlygOE5a9d8tveFoRkvj8+S0W8ByNt75iHg
	 hTU7PL+7Gd5gmlxIS7n0LVLifHZLFkeND8KO1KHdCJrMXw9A7qEyw14m40SI8vMZRC
	 lFo2rKuFvoWMRVnAR0AkiNcSoGjiXZOMqHLZ7QtHZHcm9tWPhv+l2hfuS2paZPM1dm
	 JPCxWmZf125WQ==
Message-ID: <sashiko-outbox-169914@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 07/19] PCI/P2PDMA: Collect the path's ACS controls
 before deciding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-7-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-7-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:32:27 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> calc_map_type_and_dist() combines ACS reads, routing decisions and
> diagnostics. Adding decisions for different TLP attributes would duplicate
> the walk or thread each attribute through its counters.
>=20
> Collect the divergence controls, internal-route restrictions and upstream
> forwarding state in struct pci_p2pdma_acs_path, then decide each direction
> from it. Keep the existing rule that both directions must route directly
> for bus addressing, and reject unusable upstream forwarding before
> considering the host bridge.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D7

