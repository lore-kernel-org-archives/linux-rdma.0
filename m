Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9033C3EC832
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 08:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965188; cv=none; b=EjY0e68mAN2u/P9TwA9aM0ihT2p4kzFNWFN2GEdK4+B3H3rn22+jeiej3BjTsDR6N0i/FjYcmVFIh5f93AhEo5TLHnJFzsp2CfGJwJMuhILdad53/zHFr3GgL4UQXomYk2DBJ9zR6X4y8vI35Bhq+vPm4ZRCOPDb1qyPYkEHXpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965188; c=relaxed/simple;
	bh=FRcR0L50p+6ghtAvgQfHDvVrGDhoLT1aAMkZzu7mXPg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=k7Oq39QI2ezS+sgqDBDw3bdWidPoOXvSszAadOCJr4mzVrS6xcmCaWVbDP1WMdEzXWnTSkcO864YVU/Uj8ir/ef38i+sSQTAkTAO3nKkZbZYkBWud06OGueC+L0IuAcBD1VFzUawFCpL8ckmouBwzZhSxrG+uSiuh3ms//0SHls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YDLss+8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YDLss+8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC081F00893;
	Wed, 14 Oct 2026 08:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965187;
	bh=FRcR0L50p+6ghtAvgQfHDvVrGDhoLT1aAMkZzu7mXPg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YDLss+8+5sEYI2NMlWC/87kXlrmdZksCYJX8GWpRL7UiQMILJWhoqzl2W0mTn/SrV
	 +EQwR6L5pNRJ419XBsOnmhGUh7dEPwWdeZMS+yxFNT6o+7n+MF930F74wNAKKyaOLC
	 3UQMuOIzIi2m2yqm/nkRF03mAxJ1HJ9pw+S/GIKh2d4EcILEUNAUKKjRFtirOWJjRs
	 bR2oxmAFQdLhpSvuvqpRDit9UvdbpIYZtncU1Ryh9n+jSh5y3Ic/88ocG+Ktyg4Cjl
	 lrAf1rMgBKpzMuTjLj6ObbgHcVJUDQTtf1k5aGoEpGUCzBeQEF800L/XKyejlUA6mZ
	 4u2+j62rnOgIA==
Message-ID: <sashiko-outbox-170994@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <df59976f0f5e51ea5766451f02878bd04a4907cc.1791561995.git.weh@linux.microsoft.com>
References: <cover.1791561995.git.weh@linux.microsoft.com>
 <df59976f0f5e51ea5766451f02878bd04a4907cc.1791561995.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 08:06:27 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791561995.gi=
t.weh@linux.microsoft.com?part=3D4

