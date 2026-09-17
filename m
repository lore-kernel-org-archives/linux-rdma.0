Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282114A8A05
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 10:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789642737; cv=none; b=dPuK5KbU+bB22ISpqkMno63R7nFLVrHZXz2Kbvka+OqLjtvdqj3mvdm6PNUPJM/f9VVYyDdk1OhRIN9eKfPB6xcMNCUTlPGbKVMVzh7c1fMOQyT/uUBiVh0psWowT5GzZiuL6kpnz4Jc6tYoO5QZ5fTNWxWOHqxVL3WP4Cl67vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789642737; c=relaxed/simple;
	bh=ldG008KL0oJoe1FPjpjfzMX5PEAVxXaCsHy2cgInqBw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uLpIactL2h1Z0zJbAnT5IfeayTFFdBTRgi7tMcugAo6iSxnvj2Vaa26X6JCz6KPrnIutNbPViBvuiNEIazYgIFx9UUYpT/gU1Y0ZECCZbB+a2uEW98/AqYskXEFUiyg8qWgdwYsITJ4oty2kP4H17pfk5Ksdwi6y7HWuIwhiaVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nU/QOgF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nU/QOgF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C9F1F000FF;
	Thu, 17 Sep 2026 10:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789642726;
	bh=ldG008KL0oJoe1FPjpjfzMX5PEAVxXaCsHy2cgInqBw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nU/QOgF0XgUF+1fndBcDrRN9d3ACe2/wAd8TJCFZ1yeSPE4Iw0t3LC+79oUg2qC4f
	 JbKDxAij5GKQCPb3IDHQBh+hMkDMhgk899bu2mLmV4xykciDwvpY7neFm4S60bsXE0
	 /f+Cjuy1VEd9gvJaM+2sdiFywrFJiDle/G/KWE8iN8y/pfadXPwkyhjbHakbHvnMFo
	 XhhEf2RiUWxZmnVi5eino2/eNAKYEUAZXJSkIg+cQ1cZk88OFbsUVSBxncOut36ZSC
	 v4hf6Yvg74vMJjhrsTCKu2LNFhFtqQ94rP6iUuQiS8TBgScYeGw9F5q8+zgpE3v3G3
	 3KFvyeG9aqpNQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next] RDMA/efa: Use __GFP_RETRY_MAYFAIL for ring
 allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Margolin" <mrgolin@amazon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917105101.9365-1-mrgolin@amazon.com>
References: <20260917105101.9365-1-mrgolin@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 10:58:45 +0000
Message-Id: <20260917105845.E7C9F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> RQ and CQ ring buffers require physically contiguous memory. On
> systems under memory pressure, high-order allocations can fail
> even when sufficient free memory exists because the allocator
> gives up after a single reclaim and compaction attempt for
> costly-order requests that lack __GFP_RETRY_MAYFAIL.
>=20
> Add __GFP_RETRY_MAYFAIL to the GFP flags in efa_zalloc_mapped()
> to allow retries with escalating compaction priority and release
> of highatomic reserves before giving up.
>=20
> Reviewed-by: Firas Jahjah <firasj@amazon.com>
> Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
> Signed-off-by: Michael Margolin <mrgolin@amazon.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917105101.9365=
-1-mrgolin@amazon.com?part=3D1

