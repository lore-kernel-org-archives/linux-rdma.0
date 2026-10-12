Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744A2485CE4
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 10:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801157; cv=none; b=GgmSx+hLcN6gLuxZux7qF2iDg/PXJ5ymC4LHC9tXfju0bva1hjSFR1RNL+1M9/YvfoeHxFKJEchRrGUzqZALqh+9gmh5GW7v6m/Rq/6O/S+jzJ2WXLCbBQ1zTZ9OGgxUDbNe7+HfhM2//DzYxeCrEXH51bpeqxrOAoyuXSOTdYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801157; c=relaxed/simple;
	bh=1BAXS/xmbw2IsIzfgbjoOHUhELqzfdfWfeg2MSCkipU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=d83/W6SDUHUXQfhYvWpUJ29/gfoMkf9fy/t2KIot3Oj1o9OJDdJx2dmNEHjAaIdYpqvNOmUQCBKY8nhv5praukcO7ydYs+yMU77/coRhw78J0wN4woVZ7TVfYNks0oQT1ESC2l/A0lTzlljeagdEACGRzde6g81Koe9h0eysHZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMZZ/S1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMZZ/S1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22121F0089C;
	Mon, 12 Oct 2026 10:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801141;
	bh=1BAXS/xmbw2IsIzfgbjoOHUhELqzfdfWfeg2MSCkipU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mMZZ/S1Bs5fFrBvxb7uzgvvnhCbXuX9yv8laEQO4PvIxsC6XvPrF9hes6Q2wJHEzX
	 7k2Si7fqLxVJUYTottBZCoWeDaSW9nUCWoE68CKiZyCFU0p0Jiw7NGyBr9EuZOGwxJ
	 J6V+hFFZdOvmG2yBWKAwKd4zClT0JVqHUVvXD7sWAUW4Gsr8E3POlyou16z1gi+tLl
	 JxJLAEMsJq7TDH5tj0M7nRvV/zlQT7yuIFi3trq1ccrSLMvy19bMs2XAU6b92+y02k
	 msFmU8egolhqk/BdDD2KSN1bUP6aBnWQtWQk3vzqUNqz3Iu8A5npdmzuuM4bwAWDIE
	 XJhxu6QIMHWAg==
Message-ID: <sashiko-outbox-167960@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 2/2] net/mlx5: HWS, fix modify header pool match
 for copy actions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012101937.1335231-3-acassen@corp.free.fr>
References: <20261012101937.1335231-1-acassen@corp.free.fr>
 <20261012101937.1335231-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:32:21 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx5_fs_hws_mh_pool_match() compares a single dword of each action
> since rules pass their values as arguments. Copy and add_field actions
> keep their destination in the second dword and HWS reads them from the
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012101937.1335=
231-1-acassen@corp.free.fr?part=3D2

