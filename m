Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662B539795B
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 14:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741042; cv=none; b=ZEXh9kUkMlZf++tsEsLeRdZsuJ9pHVCMtMK2FBRun+Hjq4v+6wzftSrdRMhMVNFiqGnoF/ySVf6UtzyOXllOX9GbvVW5WesEdg/mcSt6fhqXMIerA+gIb5Rocnu7mgIgbzDKtu2X729L9lGpLLiOMsNfqepaOs6IeljT4AFR1Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741042; c=relaxed/simple;
	bh=nIVkgrshDiCD+AcyfCDi9iDPEZ6p5N58lq74M2gzKFY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Hlo2jv/L/hA0183fhnwB2CjOE3o6LCGAr5mcZWw/Aa2kryevtF00ewPRXUPDeEqFgVWU4b0i/k84pUEIKO5J7G7qTujgEfCR92tcputT7SNl5JmqcJkDOmMAgYnReaHA4NXK8W4rN5y/gjZ043qRR6TFinphghaclXMv1Z4XORo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4UfiCQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4UfiCQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C811F000FF;
	Fri, 18 Sep 2026 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741040;
	bh=nIVkgrshDiCD+AcyfCDi9iDPEZ6p5N58lq74M2gzKFY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c4UfiCQILzOXGRmf4aW7XN8hpCHsf9UBd7e6WXy0SmSROlT4fW8a3h74L8aS9orQp
	 sgbbQkY3mE28sb+rC5ULeMa7pYJa3jUQG4nK7hSO5tcg8MqwTO9VlWG90ulym3nom5
	 w15FGFcUbt/HO6foarJ65WhKm0oiPk25nP19cqhF+6jWU0lBG7tTPohWKB3OMdC8d0
	 TKuGBzLwICqCPp/TyJhFqA3R1/itWXWzh7a1cOwVbXni6vnOhc9gx/Ww3bs8D8vdUP
	 dGpEUb1hlfRBWk9XSSK/RJZjQxqDWf5zTZ7I9x73QSDvi1brn1EYZGYJtaFbEl1kw2
	 6+Fr0tcvTsBGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 1/5] RDMA/mana_ib: Optimize shadow queue
 bookkeeping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260918140407.2922819-2-kotaranov@linux.microsoft.com>
References: <20260918140407.2922819-1-kotaranov@linux.microsoft.com>
 <20260918140407.2922819-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 14:17:20 +0000
Message-Id: <20260918141720.97C811F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Use compact bitfields for the posted WQE size and send opcode. Flatten
> the UD receive shadow entry into the common shadow_wqe_header, retaining
> byte_len, src_qpn and the cached status until direct-CQE polling replaces
> their readers. Use this common entry for both send and receive queues,
> including allocation, posting, CQE handling and WC generation. Derive
> the receive WC opcode from the queue rather than storing it per WQE.
>=20
> Publish initialized entries and release consumed entries with matching
> release/acquire operations so posting and polling can run on different
> CPUs. Retain the legacy completion cursor until direct-CQE polling and
> software flush lists replace it.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918140407.2922=
819-1-kotaranov@linux.microsoft.com?part=3D1

