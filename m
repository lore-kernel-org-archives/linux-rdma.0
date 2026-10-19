Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29C725B0AC
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 13:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417012; cv=none; b=l+wszwYOnZ3WzAdt4DFdi9YADCendQjQlpP1SQO2I3hD6vVzVD9SUpHw3NIzIJNQ5IgnPfoLUJ3zByPLBt7pcjLHN5imL/5HdkkakNzXoHFYjR7ZUvB0tRxgbOTZk4ShXxUOKcSN+RpufbtDdR0rNHToeMZtencOL8McHoDWWmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417012; c=relaxed/simple;
	bh=7b4y6UH8vY8E//4ACENVxo3BbFxCb7tW3G1sSkLYAv4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JvpAWG63zvLj2SRdPvBjmyWdRBUfczQ1muZ4mcCL8aOB8UkZJLUjFy6wM/hwOnHJYx1fWEPcBh+3oYxtobdQSuaqDbchiePMAKOigtVEeK32vg31phXrziQFRBSTXk8ZazQx+m3Tu1XYJ15MO//v4CVISuuFzCt7Yul7xqBq4kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qa9xkmvE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qa9xkmvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B886F1F000C5;
	Mon, 19 Oct 2026 13:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792417011;
	bh=7b4y6UH8vY8E//4ACENVxo3BbFxCb7tW3G1sSkLYAv4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qa9xkmvEOulqnrBAAKlegTPJX4h2uMZ0b8TrSubm3T9cNPdYr2DbQGWb/SCa7VkCW
	 mRIko4O6vSJGv4qRfml9z7yhf6+sUZNxniCBpCoKIHxEsitrNt3CthXfEUX7eWnvnC
	 JbGbkMi9TQZ36ohPQyFbdzmRxNeTiGUQd9WUjyx2cZVkn9kpy8Jw4KSmxvB4zUs3Ep
	 4s4AuZT9c+gJoaKywfP+trlU7SIuOfdWIETonrtSzWoYfdRw9pn+8yQSH6EQT/o/Yo
	 AIxKBYQx2MKvYB5Uzde0jzWvil/UjyHtgKKsQ+rqY8+v9wCKfChJqyAKJBHnG5z67A
	 Q7zj3xbE+n0gQ==
Message-ID: <sashiko-outbox-177172@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 2/2] net/mlx5: HWS, fix modify header pool match
 for copy actions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019133159.1742411-3-acassen@corp.free.fr>
References: <20261019133159.1742411-1-acassen@corp.free.fr>
 <20261019133159.1742411-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 13:36:51 +0000
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
> actions on the FDB but RDMA flow actions can. Tested for regressions on
> ConnectX-7 with firmware 28.48.1000 on a little-endian host.
>=20
> Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019133159.1742=
411-1-acassen@corp.free.fr?part=3D2

