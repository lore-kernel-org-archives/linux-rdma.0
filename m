Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794978022;
	b=MH0IOty8tQbbSwUaxjp6i9DZq5/5J7hRh7AlhkaXcs6J+KyRkBJUFemQGzOLVqxDGEB9
	 0s6VxLsp+YnLJzj/j/TWVEaIdY1CDYodtBLMLiFrRuCjHmi1q6ZNYGiiquSiGe8QQmyk5
	 69qd1HXWNUnBCYCKWySEPgv4yXgX0npbZf4ngemotQOVxrTKjS2zjOIlWV6g/v9rUcm/R
	 F+BPoJdiRHD5qZreb6gLi6oBqc5Z9I5CeKMUBReYjsvdzX2aacjtmm0AHDrgf3mk0iCl1
	 Mo491vXLyHinM6zdy2Ky9h/X6M7Pb2AIDCX5u6XVpa7Vd+uefKs+rmzi6WUHPgKyHCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794978022;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BX363R4BkhQoDaabvz5my7Tk4/zGGM3sbRlPSdvh6NU=;
	b=P+W8gMcaBMSlfj4aJMsZEydraMwY8lmq0BzdvDM2kSIjnOD2VHoGgI21U7Vswtcu+0JN
	 FV0HHY0uBZBd0KCk/HG6QCbQHoQDwURJaWnWw7R7IMjwiIRHIRuhZ7ZhYgDfxtDc7QFZB
	 1nFys6j17DibvERs3C5b3y0EGaLkXvfDGDGYxMG/ifpd5BwzbMeVa1ahYBhFPNwRH148H
	 tiAhjpVWS7LT/BsvyIaKvvsrjqMlDjpUjVTBgkst3JEWsCqVuLXjSHmF4B0ibx5f2EnLZ
	 l7mH/4XjMXCgfYWpma8c94tXS7X4f3EVL7ilcPxELmH1kq1sx/H9IbYeHCkD6JRhw/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwJanTy9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6BD606A330;
	Wed, 18 Nov 2026 05:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwJanTy9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A9D1F000C5;
	Wed, 18 Nov 2026 05:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978022;
	bh=BX363R4BkhQoDaabvz5my7Tk4/zGGM3sbRlPSdvh6NU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bwJanTy9piyFqwIAaklbys5csdOlD/8YzjhPA8vaIdTkRvn4UYJ6YdoQ8kpI6Qnte
	 bjcyMuSofiYxsTW+++PDkgu1Eks9oUCkWHQfbbzoUCRjfdYef8n23/khjteMD75BS0
	 V/LzKiNhIEygFwJFSfVKKCPig4t1qxwvt4OOHLN/uDuZYZvcSlMd/uEwk+g29fg3+h
	 EMdycjOMRe5/x/Sqa9py5BDEZ+AD00rK8K0Lca6LunRV8HXgzJHdfTFzvo6QQIfWoF
	 AvPA4odsJ7CJtpTAeOYYs7zzO29F+y4eg0uVqKrhyjrhfJPmktDg3vE33o9QpnslOv
	 B5mCp6e0MaRyw==
Message-ID: <sashiko-outbox-220133@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 3/5] mptcp: annotate data-races around
 pernet sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261118045137.174026-4-jiayuan.chen@linux.dev>
References: <20261118045137.174026-1-jiayuan.chen@linux.dev>
 <20261118045137.174026-4-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:00:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> enabled, add_addr_timeout, checksum_enabled, allow_join_initial_addr_port,
> stale_loss_cnt, close_timeout, pm_type and syn_retrans_before_tcp_fallback
> are read by their ctrl.c helpers without any lock while the sysctl
> handlers update them with WRITE_ONCE(), and the path_manager handler
> stores pm_type with a plain write. Add READ_ONCE() to the readers and
> WRITE_ONCE() to that handler.
>=20
> KCSAN reports it when net.mptcp.enabled is changed while MPTCP sockets
> are being created:
>=20
>   BUG: KCSAN: data-race in mptcp_is_enabled / proc_dou8vec_minmax
>=20
>   write (marked) to 0xffff8d724248abc9 of 1 bytes by task 733 on cpu 3:
>    proc_dou8vec_minmax+0x1ab/0x1f0
>    proc_sys_call_handler+0x282/0x3a0
>    proc_sys_write+0x13/0x20
>    ...
>=20
>   read to 0xffff8d724248abc9 of 1 bytes by task 735 on cpu 1:
>    mptcp_is_enabled+0x33/0x50
>    mptcp_init_sock+0x35/0x300
>    inet_create+0x4a6/0x8e0
>    ...
>=20
>   value changed: 0x00 -> 0x01
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118045137.1740=
26-1-jiayuan.chen@linux.dev?part=3D3

