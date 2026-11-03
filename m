Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793693979;
	b=ZSaYYCJmYSW2SudKRLVUtngrNSjmqvqq7WQxgwgEBTqWVMfrDXe0fB5XLe8Ta7R58HXt
	 GumqSOaIq8tPAlwMUv5YW8K4JQFyDYbfLJXYzW9UaKFwEgJ46/847OJP0jL1huOj+SP2H
	 iRRVmwG1Z5WMr5tDEJQ3VVkQP6rU9q+2alhDVg/y6b3nWlxkHap8JTGDKkfM6LTVtyKAP
	 npsaRu6PH70pUGdtabCQ7RwFBu1igxhR9auvunB6yrKKU1UrRsANnXVePWPykV7eK0avq
	 gFq28ZMQHvpl9+V2vEETep7QSjKflBjMA71px1KJKINGMO5EnKxrtuWN3XVyPZGfDDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793693979;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xJfhBtc4E9yUCzoj02hrSzcRYLXfh2b11B610Gyj9ZI=;
	b=aN6gLamQ1GPs6AZl87Y/0wfsl8wPgenj9JPS23qwxlyoIWNmfjW23/5gqp6N/YcUtKSm
	 9fAOWq9BlufE6RGCq9cXrE/sukPKzVWwZovak6wCSR1hU9IDO/fZPUq8tCw6sIZ7Vstp9
	 5ZjX1AQzrgHUezmuagoV5IvmXyA/R6r4z/WvHjJ0cZ9hbOCpp2tbZWVcimMGjZK1QFD05
	 mWEqzcIWu/fdTVdhcQ/BMduatH/SR/PaIU6kIxIP6d5/i0xkSW4CSPY5HFhH0MESspsi3
	 SXji32n2h5ZWRda8q7nTYmP9MrjJRFuM2ySOKotivOvNNf/DL4PzYhEAAlEKSiq7Apg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SS0hjheZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCAB606A32F
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 08:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SS0hjheZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01C41F000C1;
	Tue,  3 Nov 2026 08:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793693979;
	bh=xJfhBtc4E9yUCzoj02hrSzcRYLXfh2b11B610Gyj9ZI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SS0hjheZu2Dj204qGzkHu0/d4CfR9SXa5HiTMUeoeCwmX40e0YA0vM+DNq/L4R8r7
	 BOsaBTblkIS1fHLo5HT/BX9PVSLv2yIZFDJ9rl1XJKGZI413I1DcLu9w7R870JTEtp
	 Z5iLFovZdtCc4HmD1aTj+tjEGlrwB8SdNikHdJZaK8e0amNI4YVqDIcTDuQDMnjA3L
	 8OWKR72ifjE5AJ01Qs7hty956eeASJ+Sdr3kF2JpXZaH45nFKvSlVa4qIIOXXUzCAA
	 FWDzXe3/BD0b9BJ6o6zoU68/azDMmI9/pdjI79L2p60f+OZHRZk1kXBpQbwt3KrJdJ
	 WpkWsE2QMN/pA==
Message-ID: <sashiko-outbox-194817@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/ocrdma: Release user memory when MR registration
 fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103081212.1137625-1-vulab@iscas.ac.cn>
References: <20261103081212.1137625-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:19:38 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> ocrdma_reg_user_mr() pins and maps user memory before preparing its page
> buffer list and registering the MR. If any subsequent step fails, the
> error paths free the MR and any allocated PBL tables, but never release
> the user memory. The pages remain pinned and DMA mapped, and the locked
> memory accounting is not restored.
>=20
> Release the umem on these failures. Use a separate label for failure of
> ib_umem_get_va() itself so its error pointer is never passed to the
> release function.
>=20
> Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE =
RDMA adapter")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103081212.1137=
625-1-vulab@iscas.ac.cn?part=3D1

