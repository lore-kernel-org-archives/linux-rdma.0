Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537234C8493
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421267; cv=none; b=HGRdxnLADBW/gD43BPEuaQzjrbRQdghTuEUP0Uafe9E1PuywhXMmKS9ZyZ2N5v2+NuElFdJzeG3+ScqOFWZDQdDmk5PYRq9cAOTbnSWshMmqoxGaWVUZW0RWOvRx8NN0aPaqFZksOUB/xYdhzRHV1466uyGJ356n+/BpvFjsArc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421267; c=relaxed/simple;
	bh=miMi1F00VHeYd/TL6MCPgt9YCYKv07oTfAWGsg+YW1I=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=d1G2svdsd9vkrRFOtSnixCV7eblczP3FXlrZDcd0NJW0Tl9KvqB4/dmbqrFG5BJT8NFHHjDXNvuqp+lLRbK1VRrLdkFNBNTXYrdngZ33f5K0oRAbgtt/7K8uAxJ0AXxtVvbvdNDbkWwqJumQk8xgI3IFj9R8IeiIIxq9wjwGXyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V79kK9py; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V79kK9py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCA91F000C4;
	Mon, 19 Oct 2026 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792421265;
	bh=oiT3jRadhZ/MUQE0spwUrhvEARUqjQG21kLPxuf2iKw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V79kK9pyMYDkRidMfieIHaXK3jk6wZa5OqQuOeb7nOhepGgbli0WkFvRB7qKldriZ
	 /A8cQ0gaVqyv2GUf5oPyWLeLuj06flDs2lz07bbXWRy/Y5mRYPdmmDtnt6SZoQwVu3
	 jXf0zTrFJEY/U0qlUpBDoPFkx0Zzd8WvjnuHr6kwvw7ki9pb56Zrn5Sys28FJnt0Ng
	 l0FkRB9Lz5GS8zJ3ATrneaue+CZrxl5ha8D+e5r4rpIKdwXymLWuxOJ/B3a2usp3xL
	 U5rbF64jvWxsplyaBGmad1R+olL1DqUyQyoZ5GXHjtj7/JNWojL2nQ8WakW0Xr4xqv
	 sCgHj/G9CCApQ==
Message-ID: <sashiko-outbox-177501@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] net/rds: fix rds_message leak in the
 rds_send_xmit() drop path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019135441.1420968-258-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-258-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 14:47:45 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> [ Upstream commit eb8a59a17f4a8b6f2afb4a8063e99dd96cc3fab0 ]
>=20
> When rds_send_xmit() picks the next message off cp_send_queue it takes
> its own reference with rds_message_addref().  If the message then hits
> the never-retransmit check (RDS_MSG_FLUSH, or an RDMA op that was
> already retransmitted), it is moved to the local to_be_dropped list and
> that reference is dropped after the batch.
>=20
> However, if RDS_MSG_ON_CONN has already been cleared, the message is
> not added to to_be_dropped and the reference taken above is never
> dropped: cp_xmit_rm has not been set at this point, so the loop simply
> abandons rm and the rds_message (and everything it pins: pages, MRs,
> notifiers) leaks after an RDMA error.
> [ ... ]
> [achender: port to net-next; update commit message, checkpatch nits]
> Signed-off-by: Allison Henderson <achender@kernel.org>
> Link: https://patch.msgid.link/20260730041629.3512480-4-achender@kernel.o=
rg
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-258-sashal@kernel.org?part=3D1

