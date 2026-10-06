Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7694CA29D;
	Tue,  6 Oct 2026 23:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330126; cv=none; b=p7rJ5Pkz2rNcOfAoPclZrPxjB3cYH0pTpL4Bjtj5oEFFDWHpPSogFhjrMkfJ2Guk0HXsacdF9nntSckt96K1WmhEa8cPd/qsjKBKnD/beCMRHcY+CPGaKBEy3qrltj+mN2f5pLzRIDkwIfgnUSUWWgnMNYjf6FBbECjFERy9L9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330126; c=relaxed/simple;
	bh=WNhl1g61F0vezu1w3OGerPtFa62pYnAAq/bavu7roq8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=qATerCxw7WP0vr4uMkCxnlIkfwcKkA4n7s+ojzNdf/Dz1dk1seaD55AuZbEUFm8A1ZfTTtGmnji0rTSZOaelZvAA0a7yCfBYraiV+g0J1oArU2bHFJmoGh9ATf+C7VlHfLOLoMSgacdgtK228awm9eKZlq1fNbWtYefYIS2qQhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tdr3v1s4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tdr3v1s4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9E91F0089D;
	Tue,  6 Oct 2026 23:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330125;
	bh=WNhl1g61F0vezu1w3OGerPtFa62pYnAAq/bavu7roq8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tdr3v1s47RKfelHob9NuE9kqhoGl6zpbc2Jf+NowcH1et/l7uBwUmrc5V+weffHQC
	 AzHs3J5IvjP5Y08yEb3Rpz+RDjsgiDaPjxBI3AJuvHQ/bgPszL0Df/YNM2tm2Aevou
	 zgRGR/f0HQFqI0yXKcwg+3RP3kliaWbenAhK9Jk7T+0V/sgh8x5Aa3fMUyIHvTKPOV
	 JO6FSwJoqJGjc3+BbGXDWtqxrwVYv9oHB11nWPnSmdmjQFGu+4BM8u7Swq5BbYvnYu
	 rlEDadmGthwG5lu9/Mw9mOacFLuxH2qsjE3OdrNV1uG/KhOKx1L1AS7DZl4U6OZ4fQ
	 IWuceKBTszjxw==
Message-ID: <sashiko-outbox-162519@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 4/8] xprtrdma: return -EREMOTEIO on P2PDMA map
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pranjal Shrivastava" <praan@google.com>
Cc: "Anna Schumaker" <anna@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20261006233248.705086-5-praan@google.com>
References: <20261006233248.705086-1-praan@google.com>
 <20261006233248.705086-5-praan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:42:04 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> ib_dma_map_sg() returns 0 on any failure, so frwr_map() cannot tell
> why a mapping failed and reports -EIO. Use ib_dma_map_sgtable_attrs()
> instead, which returns the reason. Pass up -EREMOTEIO, which means
> the device cannot reach the P2PDMA memory, so the RPC fails with the
> same error as other P2PDMA refusals. Every other mapping failure
> still returns -EIO.
>=20
> Signed-off-by: Pranjal Shrivastava <praan@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006233248.7050=
86-1-praan@google.com?part=3D4

