Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E193641A4F9
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 06:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792220195; cv=none; b=uZD7PmRN7XJ3Q6LYL0i7NTY7xEZIXuPTI90PBOJEXStssk3athfMzPufusmQYsjKn5brrMCzHwX/4ze+Ci49Xh2GTq2iISBO/xeEuvoMGC71BNzBfW+bCc/NBAXHmNkxC7Vh08KBNdNgS/1WdoYtGstyET53fTVui/zDDTIML20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792220195; c=relaxed/simple;
	bh=7y/EuQRQdM3GW/U/FhfeAscG6dAyN+YUVN9skBx77y4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=nFObDamdmoutWwPfnDXTsXUK1LZ9qh3pg8qofhutnQoQzXVoyj6jnZFb46Vy0hHukuyF9aEqMyyne32abXCKVNX4e2op6Fbp/JBg6WY6cNvj7PtjlYPmNKqkmJ8ZLv8rCUaaOdd1FkTIPsotlDsTijcRnC4eUFS+B+6BP4j0I8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmA2o5Jx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmA2o5Jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3F71F000C4;
	Sat, 17 Oct 2026 06:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792220193;
	bh=7y/EuQRQdM3GW/U/FhfeAscG6dAyN+YUVN9skBx77y4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QmA2o5JxiDuVnG1v+Cbnk3v8Jpa/vaN2zxOAjveCRzcWOuWhUEi1XFWT6mdFfkzrw
	 scF6eOK/BlDlHiHFTNtCaoD5A/PAeFtrrvmlPTGkcv9T1vsQDuxf+8FDIQEV1/EasA
	 CTfgTqQJvwr14qSysXJzJVIfWOBK01oY5qkz8mcIPIbtZgVRit2pKFpHabFJeNXufs
	 l29wqw0YG6Z7PuK/C7e3TY+jujrRDfNjXxxdLl0eNwnrhHUUvKTMWrPHRHdj8svltv
	 gZooKZBBwcAwCbOdhLzKrpLF+ZF8EavnD6j8y+J5+kB4vcOtFE2ViaxQBs8kBH8XkY
	 s41TJwL4fbaZg==
Message-ID: <sashiko-outbox-175355@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v5 07/10] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017064413.995985-8-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
 <20261017064413.995985-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 06:56:32 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Decode RC receive completions, armed-PSN notifications, and MMQ
> completions. Retire requester and MMQ shadow entries using their
> sequence numbers, honor cross-queue fence dependencies, and suppress
> successful WCs for unsignaled work requests.
>=20
> On an ARMED completion, rearm the next signal PSN to generate the next
> send CQE.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017064413.9959=
85-1-kotaranov@linux.microsoft.com?part=3D7

