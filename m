Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037147;
	b=cZlHN6Jo0D43+8yxAKorTaBnumj1itPki05CTT3Rm+aKC6/Fsa8K8jZ8Zgib+jq+6UAt
	 rGsZ7IpzToweqnQuiYggq1+zu781hgD1VJTrZDEtE+JaHc4pXO2rVq+usycDseX6BRVgv
	 BGj+08w0QrUvZqqNk2W0C90RcxbouA0fx2PibzXKAi1v8HGugSlGp5jRBImCGgNtYwx+y
	 Lj2UT+yyRFpErD3FsbA5FocZNH5/5EDuU/0LXL5K9ffRXYHN5M2ZKew7VUTf9XK7H0Sl4
	 LHUsU3UX+XnDWkxTksal0rS5klV3whxE701/zyuf7S1f3k8g84eYUGLhEeTqXaqGjDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037147;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WYV1vSNXyy4Ok53hU/8uusFYHaER/kUAGaeY7j14qxU=;
	b=r2TjDWvB0fmay+Lp5rpz7QdNsCH+QE6Ut8dVNsMOY4O6yaEGyICnAGpeYiiGROPKLcdL
	 SFgJrlqTabBJJlHinJlRnJEFcETs4/QH8w83baO5+4CxGlNTpVE6vCOhny9Ygcvd40gqo
	 1KLxj3ir/9jlxxwP9FF1dHqeIjyIq3cfYnmCL/ZpOvy8x4c3wGZ2Qmf4Ar76NlaWCq4GD
	 NrUTJq9+mLm5keharLKPzKnSXiNZcew5gu6dv4LcZSjYSIpufKlHUGcrRfiVZ7dQy1Wdq
	 WucRFK6B3ClsFOhKH/vY4vfV8UIeY/khNOpbp4ZJuIgC5zG94bYJYWYUpWdsgVT36bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oC4n1mVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F080D60A260A
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 21:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oC4n1mVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F211F000C9;
	Wed, 18 Nov 2026 21:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795037146;
	bh=WYV1vSNXyy4Ok53hU/8uusFYHaER/kUAGaeY7j14qxU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oC4n1mVBMRYWNmlm/jF5dHMpq23OqlXNxO/rn1e/vsCg/QCur4CqkiTfM53HWiA5c
	 Rh/agMvQAEiiqkWhQv/e4Aqy3ZMW8Qe0p4Pz0sFVRKqBWOfgJ/T8T1u3qloJw4Lmgz
	 f94hyZFqUZD/OoIsvpXr7VakEkwWejCdQiARo2fkMO8fpSyaVVHUV4CNdHscVBzEgA
	 wWEOSi4FVwgM8PYLuZwoSbgKPSNb/mZl4SM/pP+2EyZYOX6X6iIvOuB7icV5jrO+nN
	 zRoL3IlDrbjheilf0HUPWq7T/dtHbcnw058SvQ7g56wamxoDiAPjLDHdM6ege3bmUm
	 Et3jOGfx74XOQ==
Message-ID: <sashiko-outbox-221991@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/4] scsi: target: iscsi: do not arm the nopin timer
 on an iSER connection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118211503.2526705-3-yhlee@isslab.korea.ac.kr>
References: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
 <20261118211503.2526705-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 21:25:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> iscsi_post_login_start_timers() does not arm the nopin timer for
> ISCSI_INFINIBAND, under a FIXME that says unsolicited NOP-In is not
> supported there.  It is the only place that looks at the transport, and it
> runs once, at login.  Two other sites arm the same timer for a connection
> that is already logged in: iscsit_process_nop_out() after a NOP-Out
> response, and iscsit_na_nopin_timeout() for every logged-in connection of
> an ACL whose nopin_timeout is written from 0 to a non-zero value.
>=20
> So an iSER connection does get unsolicited NOP-Ins, and iscsit_add_nopin()
> builds them from a command of its own.  Writing nopin_timeout 0 and then 3
> on the ACL of a logged-in iSER session kills the target on unmodified
> mainline: struct isert_cmd is all zero for such a command, and
> isert_put_nopin() hands the NULL receive descriptor to isert_post_recv(),
> which dereferences it.  That part is a bug in isert and is fixed two
> patches on.
> [ ... ]
>=20
> Link: https://lore.kernel.org/all/20220311175713.2344960-1-djeffery@redha=
t.com/
> Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) t=
arget driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118211503.2526=
705-1-yhlee@isslab.korea.ac.kr?part=3D2

