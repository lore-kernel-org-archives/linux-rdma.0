Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4937748BD46
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 12:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792238809; cv=none; b=CmetXsVqV6OoA+R7uR9h3nvtGscmNg7PLD7P02bh+jSTzcM3JGvggccVSuS499dIAEzVtulrJooSvJmVS3Jb3YldKrMjXCl7CDb0P4MCe47Eq8gV/Kn+ElmpqkaKQxcw399bbg/KKN2DvEXL86uqTbUlCNlUHNN4Z3MItMbsD84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792238809; c=relaxed/simple;
	bh=v5oDoEAWfHlkxLhBJbm83tYXz4PNYcpaN0359McPCHg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=M6FBn2ur9h6mlr6NTd9+ngnUHNjX7rT2nUvOzcQaX3xlMk6JOkc1ibGsAOzeIO8AnPVvQjbEDASQRohuaxK9vyqM0/uw8BodoiNDnt9/rktwziiOR31MhOTrhbYdgTrT2dHmywLoZKzG6lBT4zfc92iO6FsPkehqhLaFt8j4z2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JexxsJNH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JexxsJNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A371F000C4;
	Sat, 17 Oct 2026 12:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792238808;
	bh=v5oDoEAWfHlkxLhBJbm83tYXz4PNYcpaN0359McPCHg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JexxsJNHUtg/VIZgfK/Bm5+HPUVu8G7vuPyzsH5cq0ESgwWnymwpxygY1KiG3Okcs
	 LkKbiP9zt7PfybIT0GCWw9jO+GX1D8MJ/4swwWF+qF+BqffIQ7p9GBG710XZJum81n
	 H/lj+x9bADcKKJyB9uxytmaSdfTzKiiSZQ3ZS+FtKhllhDWqcEr6uUPRAqdLwKc0Mb
	 rhnQpWGMaJRcWfx7ZZG+LE6BrIIB/N3YnKLQhomLU3lPytk8WSefA15pryI8sMF7Tr
	 Cv1nERP5+3QKsXppTJJtpQo7GGu4xTO6IITLAdHI59pdRM/rBxAbFLLKOlwed80xY1
	 1RInpaEV5zX0g==
Message-ID: <sashiko-outbox-175502@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <877e674c0255820b0517f863e535615b4028a48a.1791998462.git.weh@linux.microsoft.com>
References: <cover.1791998462.git.weh@linux.microsoft.com>
 <877e674c0255820b0517f863e535615b4028a48a.1791998462.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 12:06:47 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> The HWC starts with depth-one bootstrap queues. Treat the PF-reported dep=
th
> as a maximum and rebuild the channel exactly for reports from 2 through
> 128. Keep the untouched bootstrap queues for depth one and reports above
> 128, and require a rebuilt channel to repeat the selected depth.
>=20
> Treat the reported request and response sizes as directional maxima.
> Rebuild only when both reports equal the 4096-byte bootstrap allocation.
> Keep allocation strides separate from these limits, and share the effecti=
ve
> host-to-PF request budget with the GDMA and RDMA request builders. Bound
> RDMA CREATE and ADD_PAGES batches by that budget, checking that the heade=
rs
> and at least one page address fit before subtracting their sizes.
>=20
> Reject oversized messages before acquiring a slot or publishing caller
> [ ... ]
>=20
> Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.=
com
> Link: https://lore.kernel.org/r/179196575846.434549.7933818740976196422@k=
ernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791998462.gi=
t.weh@linux.microsoft.com?part=3D4

