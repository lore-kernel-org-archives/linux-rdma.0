Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E73248F57;
	Thu, 10 Sep 2026 22:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079130; cv=none; b=TEn+1FXT6n5R2cOfeQv8VD6dcfjMSouxmcJ5hJUekDQY+kvS1tTIDNja27I2qDXPOU6mBGMSfR9oU0tJzqOx2jHOhuPZpU00PlH9xfATXGsz9uDof6IN5yjPMDYO1flzNrhVw/nIPIWn57jAk3i52PymyoOVDz47t3QpB17hrWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079130; c=relaxed/simple;
	bh=xI3J2EkcjmIbk+3fdbdWxv7aTNqccrvDsvMPdxxLKk4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FGZsbto3ZPORhBdFtBwBYwtgztolHq8th0DXXYvFwyzqZA1WLT81tNNhGo5zwZBMvRJS/kvjY9uWZDLIoZDu6Ngm/PTvrQ5C6RCivaVcsPktGAW6YbERUDx3n/1X5nH3Ktpz0AFCIN4gZ2tRV3Q+cJd8DbVRL/oxlpluc+sX5EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b35dFWr0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b35dFWr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E911F00893;
	Thu, 10 Sep 2026 22:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079125;
	bh=xI3J2EkcjmIbk+3fdbdWxv7aTNqccrvDsvMPdxxLKk4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b35dFWr0N3cNfNz280LS+pz2SYP1CTQ06ZX8mV5L8EUXOqyP8B0ks6+f5IQdGDbW3
	 m68KBr4IiTday4MSWIaK0oJ7is8LYJNVPLUnfidKxGLfAP1GO6gOdkKkvOksRz5WdS
	 u7M3BhnAPziFZnftwG/iDpPyhc6m7eMX02TChKCZMxWqvVR5/x9Dv1vA0kHx/WjYLS
	 /aVjXuIR6ivc9Eei17HsIyHlyBX5ilH00rCJRfyjF+WPxF/HYSzxazGhZYoF7zEFKt
	 IeS6J0VtrfbhlAl4DTxahP2m78/R4jRSI28x+YMBv2g/+D7qzNehTKGKKCGWl9GZQl
	 2LL9H6v/Cb/mg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 10/13] net: mana: release EQs left idle by a
 channel-count reduction
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260909222416.884246-11-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-11-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:24 +0000
Message-Id: <20260910222525.29E911F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Release EQs above the live queue count after retiring queues are freed
> or replacement allocation fails. All CQs using those EQs must be gone.
> Return their vector allocations to the pool; IRQ registrations remain.
>=20
> Store each EQ's debugfs dentry in apc->eqs[] rather than a stack copy so
> shrinking can remove individual EQ directories.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D10

