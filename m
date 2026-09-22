Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9171CAAC
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790039211; cv=none; b=FcRwCwtA3YmAJZZyU8O5ieOJPzijZpzmEeb6k61AIqfUtcnZsVRg2cfjBH4CTxr171Vkhz+cicabtLDPzA0/5jpyJKeM6p2KqfCpMJ0hW1mw3phmrOBZRsvwnmiTUbsOoFoXo2f4ye4X5cGgNtXodGiDpTJlKDZ3ReCNQUWC9bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790039211; c=relaxed/simple;
	bh=BmEMuPDsJwn6GtRgGMaMF+T2NUC9KCrmcv+qKx3pgBc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q3RvJU3JEk7Uje1uD0JgKePRGrcPKPiuFkuH32AhhnmrwP/A9AxEVOnhRoLY5I6UCgrB5HAC2sMCT6HDojfh6D9KLy/Kp7sHEB/gBhoBNVUnvm9z7PFiz2sXW0oEjzxV+0v8fwunhViCD7ptnkD2wB4/uWOZ/92xaqY/WqcOzM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnZq5yHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnZq5yHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEB71F000FF;
	Tue, 22 Sep 2026 01:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790039210;
	bh=BmEMuPDsJwn6GtRgGMaMF+T2NUC9KCrmcv+qKx3pgBc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bnZq5yHzIeDkqzEnPEtYMSgnTQh5GyR3waOohOaKimADF1dNCFosVBeGwO7FkVf31
	 v2AnCA4/+xYJncyxe+DqEDuClkpU4EHNVvSixkaNBBx12SvdJYOh4d08q416DZ9x48
	 sdHZFyd0wsHr5LW4utmE9X/rxElu/Jw2oFhBxxX80WpTEJvpSV+fESydCJR0PP4l5h
	 rHhd3Hnz9PGMhzbz8nn4PpzPIncBuhYwnAroKMlc58K9mMdfptjq3BLEGgDrZkkuqx
	 AL9jMlPHQyjgMAQkZseVAcN32JMgtexna85l4sanEBjJ2fyMRSvGHGxdm2mGMTGKih
	 w+5nqyTmL7LDQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v3 8/8] RDMA/bnxt_re: Use
 bnxt_ext_stats_supported for counter count selection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922061230.7909-9-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
 <20260922061230.7909-9-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:06:49 +0000
Message-Id: <20260922010650.1AEB71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Selecting between BNXT_RE_NUM_EXT_COUNTERS and
> BNXT_RE_NUM_STD_COUNTERS relied only on
> bnxt_qplib_is_chip_gen_p5_p7(), which doesn't account for the
> extended stats capability flag or the PF/VF restriction. Use
> bnxt_ext_stats_supported() instead, matching the check already
> used to populate the extended stats, so the counter count stays
> consistent with what gets filled in.
>=20
> Fixes: 8238c7bd8420 ("RDMA/bnxt_re: Fix the statistics for Gen P7 VF")
> Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922061230.7909=
-1-selvin.xavier@broadcom.com?part=3D8

