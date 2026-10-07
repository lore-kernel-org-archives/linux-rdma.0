Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3FA40F73F
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 15:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387835; cv=none; b=KNsLnrjhS8kVdELP1IcTkuvCp7P6FqrPFQoyEsvQtXin1bma+eopXrEaFLx3eM5PhwlbsLJmkwUJPPjr74eJKmdPFuKOXLmtkyjtN4CJYrSx1nxEvkPhxNWtIgGO+yS9XMnUkcjkUy4k8sqruny4eEDBz/ezNQywlgeEXMDoeAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387835; c=relaxed/simple;
	bh=3P1AhcBllTX6AyQIX62TzEcvouknAtuf+QGzY/QR0F0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ZqJkFKw2PLL8fGoDsv17SKaQ2bE+bzMSC8JpuWAJCCffQtGySKAiU3Y0CRg8fj/L4RIK+P3E276xQU56LNbwuiS24KcsAdsshhlUor3opOHPAkSYhAQRhcRLRPm8p9MJNybRbEtBYwm3OYu73caw+KK6PQGM21ps8wmDksyIBlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PRNc2MlO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PRNc2MlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFBF1F000FF;
	Wed,  7 Oct 2026 15:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791387829;
	bh=3P1AhcBllTX6AyQIX62TzEcvouknAtuf+QGzY/QR0F0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PRNc2MlO9dY7yY65zbDlPHgcSjocb7b9WdVYFEY0Q2TJHmKjNZcbCnYgAhdoTg5pT
	 QcMksRSBHaffhPk4KAYnkTUdXGMcYB6v/xtVYziYP3ZtjwmwbxpboxNjqJdouQMdW+
	 Apf6CUtGclEXkMuP/VaoXHL4qviVZLFTMjjMpAX9SegiIXs6ymLbBKjgZ3uy9IdH3Q
	 JPjECBGAzeD7abZS8FOL9yrEnUWctR4kalukbrHb1dyMxDeFK4bMvfcwK7RLEQt2If
	 bLQC9LR07JTu/7S1rA5z2MLgN4fDi0O6SpBNJgPwFR694OC2Gs30rOwy3WeBCY0Ojb
	 PBYfUjpW5mj+w==
Message-ID: <sashiko-outbox-163156@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 05/10] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007153330.2979799-6-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
 <20261007153330.2979799-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 15:43:48 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007153330.2979=
799-1-kotaranov@linux.microsoft.com?part=3D5

