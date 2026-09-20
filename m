Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8DF368D4B
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884726; cv=none; b=s+59Z8YmbmubfTq4M8iqEHdjF7YusgygEcDp22K1VRufCCgloJTVq2GgEWZuIq06r+XIxEziq5uPYq5GwtoeNUlti9XjYkRqdsKhwfwNNcrlHk2qGxZGcrnGAepb/iIofCr82wYdtXxChCfsi40SkYAB54RCVw/ZpMVPLenGBhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884726; c=relaxed/simple;
	bh=axJOu4jPoC8TfAkBkcFCZ2HuJ9bpZ16+stpcnMJUl3A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N1slekmHvn2Wed0d8VzLW/dTacfLelhV9OUvaEkp5ZlWVVF1Z8lcIVmFmerBud55UscYPilzDIzLth9thwLuvFCNKivZT+3CGXYq0doQZrExleaQt3QZMrvCXXV3pBw3yzroKrZRWOxKT2K6HWOuIVPK/eWA/wb2T1jyfLpGRQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elZHqUm+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elZHqUm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E221F00893;
	Sun, 20 Sep 2026 06:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884724;
	bh=QtIU7OJXGifBcMW+jd5EZU+lmFaSKkCL81Mh3zHBiu4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=elZHqUm+/O6TNwWtY5u5Xg8plsAWFwCVMMhllxFVR6PUKl8ogLPgjRiQGHFXkqFIt
	 OrNPe2WAY4rsyx+opSLgXGeLdGDwxcIikombqSItieLEU3+dNUKGc/+KO+BxDg4wd8
	 C8ig5+W4e5oJ5xMAD0VIwFNsafszWIHKOLkyLdvj74IQ5CbsYze2AO6t958fH0F3np
	 S39zIrKC8kKYklfgkom76FKX8zBNDVo2N0WllSUzcdQeVioTrsLexGu5GbWYQ0jBdU
	 mXLMaok3RdqFly2/ztxPygvnCJYuvvLkzVuXIeXcqhRIjOgI+aznG8tI4UiV3MsaeW
	 OH5MU2gnRFggQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 02/12] net/rds: free every path's transport
 data on the passive create paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-3-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:04 +0000
Message-Id: <20260920061204.A5E221F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> trans->conn_alloc() may allocate transport data for every path of a
> multipath connection - rds_tcp_conn_alloc() does - which is why the
> lost-creation-race exit of __rds_conn_create() loops over all npaths
> when it frees the connection it just built.  The passive-connection
> exit right above it, taken when a loopback parent already has its
> c_passive twin, frees only path 0 and leaks the transport data of
> paths 1..npaths-1.  RDS/TCP loopback is exactly a multipath passive
> connection, so this is reachable.
>=20
> Move the loop into a helper and use it on both exits.
>=20
> Fixes: 1c5113cf796b ("RDS: Initialize all RDS_MPATH_WORKERS in __rds_conn=
_create")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D2

