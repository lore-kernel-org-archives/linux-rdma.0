Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535E738E8B2
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 22:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789943679; cv=none; b=fCho2Ybu4uupBVDcSf/lll7V+LX7XGNo7JPXew61immpSrfVaRTgGxs4MjeioK/qnN781dEh5g7UEz3R0VZzxeeWIlYt4nC1RiRFolaf3GoZFSsAM2+4vUXLfjg8RPKkRytb5rTbB7yeqN2SgEBJBAcabglmX1KM43m2vgBqXro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789943679; c=relaxed/simple;
	bh=J0HBju+h9ZLB5m1HC6vI4HQp85jO0H151N6Vf/E92EU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q9lVZelpdDPf8o+BT8KwKLfIDsOs/9EApITXhUT2ObpPv83uouAbAllKQW4u6C25jg3kU3sMhjSmYxp8Gvu2k/Xu3/VFtZbU1RfuL+DR+MecJ2ZlZWFsvbCWIZzVZkHtaJbYxlwr5AxSVB08jN/jJYu0b5KdQn0/oJZbrRlCNSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e1vE15/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e1vE15/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12F51F000FF;
	Sun, 20 Sep 2026 22:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789943678;
	bh=TCjnCg9LCBy/4V3zfL3PENRIAL/zRbz9+pqr9565kZw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e1vE15/EM3KttE0cnJBSGgq5nbcQXUdbTPK2ifQ2DGtAEwhSzsPO6btZMmvx9YCMv
	 E+Z2bQIfkPMBXW/zi8Kvv9MtSY0T7YunUTrZaal99QZnEALdweehQ6ctXYLG9ioUg4
	 8VXquhgYypj/SZ0wTGC21ZEVvuSWO5ICwWCnJ3VOw8zUvgcbjUIRM7PQkhc7nDZWQJ
	 88CvL09C3vZxUSFZ7oY3YZvh2717Vv3QSx6S6ds5GbP5e8zyo1BGk8OlX9ZGHtqEif
	 jBS9mcW+swlixXarxmwux79nVOv4qa4JN01TbsRDsOYpf/8x3kvxRuiNjvAABSQC1/
	 ogzVjumszEdTw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/rds: fix incoming message refcount leak and header
 bounds check in rds_recv.c
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hui Peng" <benquike@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919223429.3882046-1-benquike@gmail.com>
References: <20260919223429.3882046-1-benquike@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 22:34:37 +0000
Message-Id: <20260920223437.D12F51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net/rds: commit message claims refcount fix but patch modifies l=
atency trace
--

commit 80f53e33ea420eaf26746196c2c667ca4d80ade2
Author: Hui Peng <benquike@gmail.com>

net/rds: fix incoming message refcount leak and header bounds check in rds_=
recv.c

This commit modifies rds_cmsg_recv() to add a zero-check for latency trace
calculations.

> net/rds: fix incoming message refcount leak and header bounds check in rd=
s_recv.c
>
> In net/rds/recv.c, ensure incoming RDS message references (rds_inc_put)
> and socket receive queue bounds are properly balanced when handling
> error or truncated incoming frames.

[Severity: Medium]
Does the commit message accurately describe the included changes?

The message explicitly claims to fix a refcount leak involving rds_inc_put
and a receive queue bounds imbalance. However, the actual code changes only
add a zero-check to diagnostic latency trace calculations:

net/rds/recv.c:rds_cmsg_recv() {
    ...
    if (inc->i_rx_lat_trace[j + 1] &&
        inc->i_rx_lat_trace[j])
        t.rx_trace[i] =3D inc->i_rx_lat_trace[j + 1] -
                        inc->i_rx_lat_trace[j];
    ...
}

Are the refcount and receive queue bounds fixes missing from this patch?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919223429.3882=
046-1-benquike@gmail.com?part=3D1
