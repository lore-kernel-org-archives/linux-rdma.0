Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8945F449B01
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 12:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634120; cv=none; b=OPqw+iumvmLSoOfmkuHDtbhecICfl56K4vh/oNofx9v5lCMRZBheF0aojXRLW8J2NDaIV6yf17tfGk5BFLryEhM/VQp6N7lcxGMVaSIyHvPi/YLJCOHSQmPYukBCAMtKHKX32e+kKbOZig5RBScj5nO8gmFuY6a8z2zFUrcFUpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634120; c=relaxed/simple;
	bh=pnuWg4r1n8hEWIHHrWryn/EE8AgM4kwnLGXuuwCJbxw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ReIPrZ1wGxHnyRHqBZvsZMiZl37zC2RmwYG07Xyfl6SLVXu8OOMgSxsb/Rtadi8M7k3TWV7+soe58YSfWbUjzwwPJHytxYC/AW4zsOPYG238lU5WlUUIzMg6VthiKaD5fRc/DKagm1wx3Jk4UYjtIvQ1PeTSwf/q9AXjmXdXTuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zf2eHmPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zf2eHmPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016351F000FF;
	Sat, 10 Oct 2026 12:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791634119;
	bh=pnuWg4r1n8hEWIHHrWryn/EE8AgM4kwnLGXuuwCJbxw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zf2eHmPcg/8ZsX2QV6sVHjBezaIgWujgrhIv1NX0Q9GlhyFt6PryqgFCom2Tah0+U
	 fsByRijz7nVrA5watjQEWjt6/u91o5AZdPKfczrxV1KVQ46APbYQ/kg95SNLUoMiXr
	 ukHfijmK6iUUGOwgWZnmKFkov5UVhTLPo73xh+uaCgx8zXIZQcqiI0z9NGKtEffg/W
	 gRpGzUplWCPFqXtoeVuCkaCY2SU38Z+MRaBo1XKQihufX2VVUczjDrfeFpxVUjtg1l
	 XcBJ9UBF1sLv4AtbKy4sjeWceLONPkJVEqwT09mIKiRP4Otlfh6U9VdQyEfO8r2QI4
	 L/FVvH1bqPRIA==
Message-ID: <sashiko-outbox-166488@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: HWS, fix modify header pool match for
 copy actions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010120147.135825-1-acassen@corp.free.fr>
References: <20261010120147.135825-1-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 12:08:38 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx5_fs_hws_mh_pool_match() compares only the first half of each action
> since rules pass their values as arguments. Copy and add_field actions
> keep their destination in the second half and HWS reads them from the
> pattern alone. Two modify headers whose copies differ only in
> destination then share a pool and the second rule writes to the wrong
> field.
>=20
> Use the HWS core comparison that checks these actions in full.
>=20
> Found while checking a Sashiko AI review report and confirmed against
> the HWS pattern code. Not reproduced. No in-kernel user puts such
> actions on the FDB but RDMA flow actions can.
>=20
> Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010120147.1358=
25-1-acassen@corp.free.fr?part=3D1

