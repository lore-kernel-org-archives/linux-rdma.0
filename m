Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06DE414435
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576122; cv=none; b=Avs1Ga+U1Hkx674OkwgYuREM/NsPTkxEPv6hpcdZMPmZqidLb/G92qL1L4f+ZzlQm+E+Sqfmmw8bZowdblgJElpcuELn9ZK2VCQ7rHnZ0WTKB3Z21e6TkcWRfTamwCgAJ3YuETAQ5vC0kp1SlzmmfneOTci2iTfhnEVdyO8OUno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576122; c=relaxed/simple;
	bh=9ZmQmM3W8gVmB9GMGlLcwGcq8VNXqiWm5GQr8wsCnug=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HwJMP0PuNfQkdKucXQ6C4fBe/X+7JQEpQJedb5DQ38pvxyxUIUIO2gRwBo5e2flF/fIm0BRCF6TDMAVTq5Pqej7aTH+D8RqEIZfoZEMuDTeHwbWTVbA3E7J8rVlZMejR/1VnzJK45Indg0Phws0RDo3UIWkogKXF5WMQFWWulPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKE/YqCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKE/YqCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B241F0089E;
	Mon, 28 Sep 2026 06:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576105;
	bh=Iwqx2RxnpLMA9WFHdz/XJoiGbmDtljQMmO+YVGwgN34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AKE/YqCVxXBJfsy3Lp7kV8d1r119b8BFQB/evOOzl8Y0JW+uo2JwxVNCdz/SxH8ov
	 1vkdvu/ie+XaO2Ftb+K+P5YDsolCj4cQu4mr0Rlz4j2kT6WUEuFe7rfqeHQdCHddCM
	 VFHP8anULX6GF9yBZM3WjQb9uZoqDGO9VHLn4nB3ZRwAaY0npUngCV6o3hJCKvZIwU
	 Z6Ki4rhlYkA2hMFOs+tckzBjek867vllaUszx0LR6PQNhVk42Rk+j5oh4rlL9tSKfd
	 ZqfgOjXnYRo7UyqdcP37FhKR0Ayz/sdU0ca9sjG6MRIU6v1UrHMNybfkfhFGXbqkbu
	 sJizJy1dTsDEQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 10/12] net/rds: hold connection references
 in lookup, sockets and c_passive
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-11-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-11-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:05 +0000
Message-Id: <20260928061505.93B241F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Hand out real references everywhere a struct rds_connection pointer
> previously escaped bare:
>=20
> - rds_conn_lookup() takes a reference on the connection it returns
>   (kref_get_unless_zero(), so that it only ever hands out a live
>   reference), and
>   __rds_conn_create() returns the connection with a reference held
>   for the caller on every path: lookup hit, fresh creation, lost
>   creation race, and the passive-loopback lookup, which now also
>   holds the parent while it dereferences parent->c_passive.
>=20
> - The rs->rs_conn sendmsg cache owns a reference, which is dropped
>   when the cache is replaced or the socket is released.
> [ ... ]
>  them synchronously before the final put), and the sendmsg cache is
>  serialized with rs_lock instead of UEK's socket flag; rewrite commit
>  message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D10

