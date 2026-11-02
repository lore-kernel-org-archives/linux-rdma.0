Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793639276;
	b=yFCm+C3WNfiHhXevlNlePEubMDphOaZzkfIV0lbSwzFNmafkbYM6htp5vcdAFR/Z8ZOa
	 ObiWMkIPEJpqXExpEGJ8ELdcLK7MKak5JiuW+AueHBeP1SS6jf4YfpRzs987Zt4CJwZPs
	 +JxhAH6mrmuHc1xRSf1Hm08gzXhBIoS0G83njOjs/NYrjni+60q5Z2/sVQj9cFHz3I4tL
	 0W9XR+s/yQlXzpwyysoyTIDeWkIim5rRPGEq06vXxuLzkxUWah+BPleyTtizjjoavHT8s
	 Nhc9I1Jl0nJFAa3BtK+wegrym0ebXjLS1k8paPS80JCUepLH2OQH6XhwPB2jPQ6hOEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793639276;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Gjw/ah55h336QN4X0nFr3jYi6dEX0qiqyKULXo9l36g=;
	b=nXZf3B9SNiIv0AHppIfJQ676zJOK4zs/A89tVPM2T1klg7eJZiqrOeqoIbgNmvjXJxOy
	 we2Romz+LzOZqk3jaC22d/25+IBD6vepbwVl2V7xYWvWOfbtZwXmWgxSO2MhLIEZXRf4e
	 gJbEzW+7n9YimpoaYdO/DURFjkhibtwoOdkGoSEkzEzMV5JtyqZAFvmEzb4Y5MgrkCd+v
	 tous1NAa9lBWWpNcLcmArUblhX6JyDVMEBhLw9mswmXOqYSfzsnKYBH+IToz4vCBXL17D
	 ufs0X7ZDzbVg4eeF/C17fMJYIH99ihLZYp2TVUz4zR4lfk2iQMY55yznaJ2Eq4ft4JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kEv6AqsO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5166606A905
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kEv6AqsO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9311F00A16;
	Mon,  2 Nov 2026 17:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793639276;
	bh=Gjw/ah55h336QN4X0nFr3jYi6dEX0qiqyKULXo9l36g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kEv6AqsOwenTcQ0tmnSdbT9MpRrOnuorD+yZ5lf9vwMvkKxBszMexs58/miXhF7NY
	 hRR5GDpYjKvUYLuZu4iPoxMaVbJrNKSP9HJubAwTyd9DQSzCtnee1f93H/6pi9oNoF
	 /Ls/XfGPhIq69DOA861YK7VqkMjjgN8DD2O5cjHCFSELCQTrC0VIJKxJCbsQr5xaud
	 UaxKnyIY6bJA+6Zqlew5FlH4NigN9NFMIS0Cb/SoBm6EPF1+YIP2MYR6D2f5isSQZc
	 secO6daT1vNbp4FAwoUXlzKvQtPs1R1vuotI5yUbWGyCE9HCOS0D5wTJDxwWRrzL//
	 mKWElaP4WLj3Q==
Message-ID: <sashiko-outbox-193802@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v7 9/9] RDMA/mana_ib: Handle error CQEs for
 kernel QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102162505.501853-10-kotaranov@linux.microsoft.com>
References: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
 <20261102162505.501853-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 17:07:55 +0000
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
> Decode hardware error CQEs and process them on the corresponding work
> queue. Complete the failing shadow entry with the vendor status from
> the CQE.
>=20
> Defer transitioning QPs to the ERR state so that the other work
> queues can be flushed. Complete software-flush setup even if the deferred
> ERR request fails, since the error CQE already guarantees whole QP
> shutdown.
>=20
> Clear pending CQEs for a kernel QP after a hardware RESET by setting
> their QIDs to zero. Discard CQEs with a zero QID.
>=20
> Mark deferred errors as pending when scheduling work to prevent stale
> work from moving a reset and reused QP to ERR.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102162505.5018=
53-1-kotaranov@linux.microsoft.com?part=3D9

