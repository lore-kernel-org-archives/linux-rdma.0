Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720183D47C8
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 06:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792219771; cv=none; b=DxSf8sv2lhQqpcZPIggn9xYbxlivMr3tqxGD74G1JUBi1msju5i2r/fDmVgrR251CIWsYuddJ6W0QK8NfX2aBtjjoj1fjx3fIiL7rIwFR5YV75TuK748+xevWy+OsckSXjkhpje4hstqeTRWUJbyb/1qAEJAxCg3wtYWR2O5Jac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792219771; c=relaxed/simple;
	bh=H5VBmPf3oppT+mx0m2g0zp8B3vnFVPD77XFTIueRbdI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VWjwuypEKcEdAbneHZP9430S744EQ8SskjrNERccwSRIKIK3+TZHi5G2q5Y9dbBT+YZgYO0U+tMj27Pfc+h0QNBjyHgsVhs1nyEuts5i2Vt4XZgq5y4rNNdbMZ7HXUqB7qaHvG3QW0IqO0KAGlxHXH294/zG0EZWunes1DwX8xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddrq7grq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddrq7grq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2011F000C4;
	Sat, 17 Oct 2026 06:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792219770;
	bh=H5VBmPf3oppT+mx0m2g0zp8B3vnFVPD77XFTIueRbdI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ddrq7grqkF4VnBy/BMAz4s6kY2g9eUvogwH5sTvtXOwbZg4ENlQb4qaDder8SqxE1
	 EAhj4oxZ11S0gTb1Vs5Xum2mGgy8tdKN4KgGVvKXO7w9U3RilpbbYntv0d0Y9LMci4
	 fYV5W6gvp6Hp/0aMwSlUyMpGVsYDeMNfP3GNusFs7Xz0/raX6Xs2i8tACFiCixsOD3
	 qpCsBhonZX4kaXQPG9P1/yQrfVamMe/nCjen7t8XyaLKGWpbAXL7fz4lKKuuX9hY9Q
	 /fBulCOOdTL2h8ZTxL1dTkclO+L9Zoe4zmfO7+fD9EK1zRU5pzRj8hT1nYwvw4eiYa
	 5j36J8IHLhilQ==
Message-ID: <sashiko-outbox-175351@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v5 01/10] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017064413.995985-2-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
 <20261017064413.995985-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 06:49:29 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement alloc_mr and map_mr_sg for memory-registration MRs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017064413.9959=
85-1-kotaranov@linux.microsoft.com?part=3D1

