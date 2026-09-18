Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19871331EC3
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717222; cv=none; b=CWeQAShgM5fNph9prBHkvjPZl/JV6VngUVJGkVrnUJ9LqYCgFg4m2ugwtHTOrmlCxklgC0X1mUp75ybxrpqszPb0cmXDzw97A7ZRQYw8hnndII+yBhj31encINOfSlUpKUXVvM2TdtRYq51sVgFQ81fFbZjee+IT56VmQipXYqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717222; c=relaxed/simple;
	bh=GJZToJkYPGCZQp9JDuaSM5RZ4i/SiBBVpZSL60X0lE8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Cr+oOMI8C2wC+WDKmSAo15Uls2px9b1KwWUlnIR9rjN33qW/i2/04ApZWpJmu58Jt1TxYWBeL60jv+5N7X0OaB/t2LFRNcxV72FDO/TU0OHsy9I1vgVVkV0DN6U4tpc+ZWCAWpod/LUuh99TOwwLMbdWZjASnZZfec1CVtXAG1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IwfLKgGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IwfLKgGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F411F00893;
	Fri, 18 Sep 2026 07:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717207;
	bh=rLYZm6sAvQ8pKPc4MmO4nAcKODD1O05BGjp3JxiKPmE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IwfLKgGtv2ar2CJpoB7MU7vsOIhdi7Z66UEhezWEsy5SffI2Zkx8Z3K67qEuYvO6K
	 oYZyRhJOifDm+RZ6kmwsno636WmjfOnQUNlWRx0ug0c0Q7mMVJVDKEfIAFJzyid5+w
	 AWKlEkcFdQye6AFV8KlUpYbN8OVkgsFGPIC0fStDHQN8Be+3E7iW+Rkki5YpC1GDvb
	 Y5I3YFrMl9BYcRbpwYV7M8wET1fz5CKKJexWnrubfuCPP7NbaGxoxY4KeFGIPZUsVf
	 a7JWFjv2JGxjyCG/Hln52d02K5t+IaOpzycXHBJc+nfOpVGoRzSYTa7NRDvJaO85/7
	 JWIWr8bxEKkxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 03/12] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-4-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-4-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:07 +0000
Message-Id: <20260918074007.A6F411F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D3

