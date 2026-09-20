Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27583D6CD9
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884727; cv=none; b=IkUUAsWdSb6ts9I0HYJi7qtQQI5jpcnO2nPiSQ13NGkJBQXMiEXvSFrrhPow9TaCqUSvtaEXeQ/Krnn0NTR5zNcgnetIkchVysmbJDNav3NjJEv8NICHNDAzmmv3FQgzBsKShOX+8JA9Jyq18WecbYdTeVRMVBbI6wiIaU1PiLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884727; c=relaxed/simple;
	bh=Wky3pwzss5P+/KXTT9syUtTz8KEhFiBcZ6C7w3eWV8I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dpD0fx5njT6vEnysrHoZLx+UTC3OSM3wL/WcUBGA8hrNNoosX+8N32GzJWGWOPvVR9VpqhVKyprJ95uCL6TKPoDtWtekrthQLiKytvy7oiv4dUj8Up4EWEhjuK2Q0/HxywqVlaVHxBXsQFKU475daCfkSvtRu9G+Ew1I7sv/XRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuL4SNAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuL4SNAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D281F00899;
	Sun, 20 Sep 2026 06:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884725;
	bh=Vv5lYrjPT+Q/oKKR+4lFec1A+oo9zEUy/abuRcbaAEE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BuL4SNAPIzEbDXAm0GPHoMb/P3cga4C4m6emo0GJRlOEH1CLixILrW9iAlXMXG8Qe
	 goxawER8vFP5Mk/Lg1O1hdcoFR7zCtiJdjUv+cvpiovQFmKXft4MCwRvkTq+iX1s2G
	 oNba0u+rcAZJFQR+h2b4dkAyGhLBC6AJ8JA5T+1fmavlvrTZ6WfB463fs6RXSnupHk
	 mbOdSBrtn2CUj7OmoJ+rzsbQiEq3L5t4qghjMqlePxv0mEMFaaWuMa+v6TREYs4rji
	 OF7O8BEGB+98uoNuyxomaBK8olQcsNHTj/+qO543i4334WX07mNHJYuQWF+wDYILRo
	 YhS9kQ8z3vqsA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 03/12] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-4-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-4-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:05 +0000
Message-Id: <20260920061205.B6D281F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_destroy() cancels the path works and then destroys the
> per-path workqueue.  The sites that can re-arm those works are
> supposed to test rds_destroy_pending() under rcu_read_lock() first,
> paired with the synchronize_rcu() in the destroy path, so that no new
> work can be queued once the cancellation has begun.
>=20
> Five arming sites never got that guard:
>=20
>   - rds_ib_send_cqe_handler() and rds_ib_send_add_credits() re-arm
>     cp_send_w when a send completion or a credit update clears
>     RDS_LL_SEND_FULL,
>   - rds_ib_recv_refill() re-arms cp_recv_w when the recv ring runs
>     low,
>   - rds_tcp_accept_one() kicks cp_recv_w on the freshly accepted
>     socket, and
> [ ... ]
> single connection.
>=20
> Fixes: ebeeb1ad9b8a ("rds: tcp: use rds_destroy_pending() to synchronize =
netns/module teardown and rds connection/workq management")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D3

