Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68D4547074
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027848; cv=none; b=jPC6PHZfqHQMBpcNygLVJZo3O7MKzdUI2+neRRWUwF3FLPTqthNqX19PZdIlJKGyErpCZDwHUES87kK5zDVyCS4WFB0bySzKI438fS46j3WVuYLyiM0JMagqK74l4KtRxdwMZGJrIuT9DEwTlUUvkBNrf84W4yqI04pt9xKHHeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027848; c=relaxed/simple;
	bh=2TeDpJXofrX6W6cj19gulY0iXrFdccaazwKSbb+TvOI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tiPIyYMvjxm9qixkCg6hUKTqr/Z9+kJTgqmDmb1TPE5WZLdE9eMGs75n6RsnqXZRJsijWJFh2MgCAweqR7kj982JYBDUNqruk72uRZaF6idpVbGwLNTqA21TnWuTm/QKjZNIFMNk7R4MENLbHcZx5s3698E90IgRIT7pUsdFDmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSqiZdXO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSqiZdXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142EB1F000C4;
	Thu, 15 Oct 2026 01:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792027847;
	bh=2TeDpJXofrX6W6cj19gulY0iXrFdccaazwKSbb+TvOI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TSqiZdXOPkcHebTASyKTluD6vibQkxJ4Ctf4r1WZ8P2Ff/F0rrMWyTjPAEp18fAMO
	 XswzvFSgTpXPxAI5odJ9QoqX0St9eTKNIN6uOdvrG8cbDzGSh98XZ1M/dEWC9xgALe
	 k7n9jXv/30Fh93LeGd10eZQPppO2Lg97kEnsv8qdECbsVvf/9tXl6D0M0w0+4otMRJ
	 vXkVNtefiRZVki/LBfBb23Zb9t/WfAER9l7g6MybX3w1dwckpGOBOKMjDyESUcGtUh
	 HsIadk3GcZ3z9OtjcR5WDQUhkcj/ncaGiPWnFG2nQFtHuhUAIdmCUofyf/iFG3GmWN
	 nsy3Ii2e8fwgg==
Message-ID: <sashiko-outbox-172093@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 4/6] RDMA/irdma: Split CQ setup to umode
 and kmode
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015011940.4122452-5-dhu@x6u.co>
References: <20261015011940.4122452-1-dhu@x6u.co>
 <20261015011940.4122452-5-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 01:30:46 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> This split is similar to QP, and SRQ that is already present in existing
> irdma driver. Only variable plumbing was done, while umode and kmode setup
> logic is identical as before.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015011940.4122=
452-1-dhu@x6u.co?part=3D4

