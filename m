Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE9D39CCFE
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 21:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579840; cv=none; b=jWPtI9nxST9L/jZTnGYwGghxJSIV40ygHNHAvxUuMh+Z2XD6mx9vfEb4OjvZxq/RECfCj2qCkuRHOttOqqK5iZJmXCArZKHA4gO+YlVTyqf+p299LmonYNaYJCtxnGYctE/xVajGqw0v4pk+JUHURnk1M0oI7WFk/bwx1ZVNWx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579840; c=relaxed/simple;
	bh=0EtQ8AqdpV83mPiWsR8/25X8wTwFv8Ar2DuMBemLj2Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Rp/67D6mOPlij4/lWplGKNMQ6DTwiHdQ8Rr0i8+d0EgPWA3dvQI1IEoXUWr9O9QW+zXi4U/K0IjPvQnj35bEBbghBbR0nEel4c4nMT5kDfr9YWLhcoDWxCsPCZs4Ervb/EFAMdCs+vDNQN5AQF+ddyZEm/WKLWiA/ng/7oUVU2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gRWlBil+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gRWlBil+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ADA1F00893;
	Fri,  9 Oct 2026 21:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579839;
	bh=p2RK6eivKmR6gMNd1r8Uomrm3bxdwVOSF0pQiYhu/y4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gRWlBil+dMa71myUCS9SWRF/QT4BuMpLVE3doIQvaLTPTs7hkSsyBXehts/2CENTB
	 X9xQ7/n3opb6pse7raIR+LbzNqRNVm2r9xdTlZX83xOk8MxkDVXu4ZR6zGgEHDqXOi
	 ywPEY9NOqHr2lSZFjNvD0k0i/Ixpub8KJa3irxJrgzvhCmqSi9O/H14BReLTEAbhDN
	 xN0T07I2+XzIz9tplmPsBYFpp1fdA9y8fzpjbDPB/RPV90yEkJndSUE2PSPnxuOARJ
	 F/gVGI3WSJXG3VY+R6vc45FHN+vpITEuVwElarTaMjwxDYu/7C9w3yujXOPjmbNTy5
	 yt4YWPj1je3EA==
Message-ID: <sashiko-outbox-166071@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 06/10] e1000: use pskb_may_pull() in the
 82544 TSO workaround
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-6-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-6-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:03:58 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> e1000_xmit_frame() uses __pskb_pull_tail() to pull up to 4 bytes of
> payload into the head for the 82544 TSO workaround.  It already checks
> the result.  Switch to pskb_may_pull(), which takes the length the head
> should end up with and checks it against the skb, so this driver no
> longer calls __pskb_pull_tail() directly.
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-pskb-pu=
ll-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com?part=3D6

