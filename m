Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0A13546C4;
	Wed,  9 Sep 2026 03:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924588; cv=none; b=Qal9Kvu/3jMiSTHqRJ1Szo8Gv8tZYVIQmhhcGeUwXnAOkkz33uhTIBmXQ2yiSVJuN7VXzipIHRZ3pqK6KtJLQPgaLHmVfognP4vIGsYz1DyQ5Z7H/uOgtbN6nMqOfdMrKEHdIylahY1PnhEo3j4xvHzkRBYRzyqkWwzWOyUPzE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924588; c=relaxed/simple;
	bh=OYEwoIRCk3t++faIBgHLn2LzdDv7EbSTlhPRChZ4gdk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Nx2TdEt5ZjXZUSX9wORHOSbQoHvxbRQhM9L6e/litXeYABwy1HtUR+e7SR9nyQFeaLvwTf8RZQfFgp1OzUXHfvM0PC4voiRU8RQz9ql8A41KRHrd86UTkQ/s5ofJCz6ocm8ftHxax/Gt9lnX53xxG5BoyWgJpVkUUVE3rUd6pYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHpdQ6d2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHpdQ6d2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB801F00A3A;
	Wed,  9 Sep 2026 03:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924587;
	bh=OYEwoIRCk3t++faIBgHLn2LzdDv7EbSTlhPRChZ4gdk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dHpdQ6d2WMJGzhPlqI2R7Dv1QPVJPDRQcj/oib8pkuekhh+ibebPX06svxLM1s+LE
	 2Qgkr6/0YiuwfO4BIHC3c0RA40pjIlH+pvZ/1tCG5fc4MyyG4IuAAU9MW+OabHLzB0
	 wYO7/bJyJqM1djEHVF0zlc0vzFP5QScyOliDPuywEoy5x0u21HJObIdsEona/vCVGN
	 2+UhLVASNeOJKaTg4eq2lhlOKX6Ld/J3i2Z2kGJoZeLAntmXc6gA/Fc4sLPH4tL3Di
	 1bxyqFBWpOufGxDu4fegU9X98APDn3FDHaLynJZvSECJ1yHpb34inAqdHXZ/1sLIpq
	 i2m9aeUFqfSqA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 01/13] net: mana: add queue-set allocation
 and teardown helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260908032843.397667-2-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-2-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:46 +0000
Message-Id: <20260909032947.5CB801F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Add queue-set allocation and teardown helpers using a scratch port
> context, without releasing the vport. These prepare the reconfiguration
> paths to retain their running queues if replacement allocation fails.
>=20
> Extract the TX drain, retaining pcie_flr(). On reset failure, leave
> pending TX SKBs mapped; this does not prevent subsequent ring and RX
> teardown. Track successful drain-initiated resets and request best-effort
> sibling rebuilds, without reinitializing the HWC. Clear removed ports
> from ac->ports[] before those walks can reach them.
>=20
> The new queue-set helpers have no callers yet.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D1

