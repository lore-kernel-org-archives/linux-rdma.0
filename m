Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D10549EC55;
	Thu,  8 Oct 2026 12:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791464045; cv=none; b=GxBsUMyZPy7qHa4dIqTvwOaT9ZhUmK+bxwCIvXswg8byvfNl8NYkpNQT7HZZRpEFR24R6m40jiF3B7miQoy3F2kMv+B3fSsJqUNoLO7PssXs9YILeZ8seHuP7h4mrHMTD4x7UyesX1U4RJ+k/4LPwXieidoumq1c+0G8y7htmLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791464045; c=relaxed/simple;
	bh=qHvS/wmHdKJeHQcg5n3Ob9AhoXhD288LipBUyEfPe1M=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IkQEn1lY8PeAyHB4rDY585K2na8N+Coy/pekkV46Q+UHrvI9vb2SxP1FVcqRCYqV3s+7aKViElBPJoRilXGadhKkL27TTohqsnh0fOJZJHbycHQF/W4GwdqshL/Zo+xzppThrUG8jDTE5mn+EuMg2owDFLjIy4Se8XV8VeWDlNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UC8MON5S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UC8MON5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8EB1F000FF;
	Thu,  8 Oct 2026 12:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791464043;
	bh=qHvS/wmHdKJeHQcg5n3Ob9AhoXhD288LipBUyEfPe1M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UC8MON5SK5vdGeu8eoJLKXulPVkQnvQqgYe5vz8E7iRr7qNzZGBG2V2x4QY+jurGt
	 Nt/mH0XPpUtqhgBRspuGwgfZo1nU88tdU3k2PfHyBvJchp62bqjAxixNi0THf6LqVG
	 RoJ6H9e8T7ax9STU5mRJqw8urUwoDqNyDa2/kPKb1vjPcOPTRUrfpEh+S9+MMYx8XD
	 9nEcEQhBLfIXqYKSyzYzrXYRABqdCZvtDpctuxkPR40VHFVzQCf+l0pM1QxdqIdIrc
	 iRvlzh2hCEclHVLH6R2SXGsTDCqaB7qBy6siHX7JTiErzaek3YmwZQdA0/srpf+1YC
	 i1wZz23GJ/8DQ==
Message-ID: <sashiko-outbox-164178@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <693ae6ea1884f7f56ba6a2f11f03beaa5b74a232.1790670523.git.weh@linux.microsoft.com>
References: <cover.1790665894.git.weh@linux.microsoft.com>
 <693ae6ea1884f7f56ba6a2f11f03beaa5b74a232.1790670523.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 12:54:03 +0000
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
> Rebuild only when both reports equal the 4096-byte bootstrap allocation,
> then enforce the effective report/allocation limit on every request and
> expected response.
>=20
> Keep each candidate channel private through queue creation, establishment
> and the direct EQ test. Publish only the final tested channel. If a rebui=
ld
> fails after acknowledged teardown, destroy that candidate and establish
> [ ... ]
> goto-heavy creation flow from v5.
>=20
> Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.=
com
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790665894.gi=
t.weh@linux.microsoft.com?part=3D4

