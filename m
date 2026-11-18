Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022030;
	b=UGBtONTUVXFmzqElbT95evMHSBISUkVxcXsiAlEbXqB1oCiTb2QBuTk34dGHaT4+ctbp
	 wMO0S9p9U6/gyeXI5Jl/QTIIWX8Y/H9lydkiKZWPAxs/6YntcGnFA/ciANEf5jywqHunt
	 YwA6ZggAUo1RvcH1wp1q2+4cpRD2GIkHFo//lZsTwPJcNxf1vOjzxk3g/DxOtj7J5ouSU
	 gNMAYhvxs52gIetKzS1zmdsOKX4Hq+ow9BPDSO/DAPGiIq0qTp6omBz+nh+UvJb6Me/Ct
	 vAJbjYBktQJ7NYxacP/5rQTZECtZigOBtDSyUsudpP65HVxy/9xcgAnMj6ChvmsBjiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022030;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QDA0/cPTCx3zC7U8vf5+7/CAKXDQ2tsXcXCtlqkE7mM=;
	b=TEB5ExajYKxPaLoENYo6dTE9XnCzrjkOmjXbkOwZ87J7BCN292StwXnEqjABo3X5CXbg
	 n4/mnYeR+QINmc6ZjwxF43khvt6kRmcC7gYACSRA5vmeWpHCP7LdlrIBQmy7aqKqGQQR/
	 Pe2OOa2vY/jUBJx1cW+481CnBr/AQ0QHCmlOZCFHApZSafeHee2zTY4rsj4tfA3N80rn0
	 p2b8VPCAm5hRnZyZ/8Pfz3BUrE+0QxUFg8XwqsLU1eMjNiibK/27fuWSDgnT77v+GLHwm
	 n21glhXXq9m8uG1BAhydXNplfnCgiH/EY3CdbX5zWq62LnFIo/+Gwr8vt5irsGve7UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LmtHXspm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C372606A333
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LmtHXspm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22471F000C5;
	Wed, 18 Nov 2026 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022030;
	bh=QDA0/cPTCx3zC7U8vf5+7/CAKXDQ2tsXcXCtlqkE7mM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LmtHXspmYlb6xIgV4SmJ4t5QlboZ7868P2hLFVxydnAJYUCj5mRXDNuH/PYEGmRFi
	 02T5uAeqKj2hom0aUto9gcmmv7trSAUMYPmas8ucc+LTCq6boIm/mFCmWWiWFOCS44
	 tSUqBOn4Di1Mw2CzB8/aP60yNjZ7PtHLznoQmE0fvA1RdSTmx/pc/urAgcUEV14dML
	 G/N9iXFX7k2BdgoqOrpgpphHPUzwcEuG56G01Zf4NVNyhN13d++vvlV1e11r6hD6Qe
	 +DzOxq4f4GVrBh0xNkV89/ZURNSD7IalU4f9XleurbSJuNUdmvfOX3v8a5ooKVMsJO
	 My/pi93zFbL8g==
Message-ID: <sashiko-outbox-221615@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 14/21] RDMA/core: Set the CQ comp_handler
 after its poll context is set up
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-15-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-15-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> __ib_alloc_cq() sets comp_handler before it initializes the poll context
> the handler schedules, and for the workqueue contexts it arms the CQ
> before setting comp_wq. The CQ is reachable from the completion
> interrupt once ops.create_cq() returns, so a completion event raised in
> that window would schedule an uninitialized irq_poll or work, or queue
> work on a NULL workqueue. A conforming device raises no event for a new,
> empty CQ, but nothing in the core relies on that.
>=20
> Initialize the poll context first, then set comp_handler, and arm the CQ
> only after that.
>=20
> Fixes: 14d3a3b2498e ("IB: add a proper completion queue abstraction")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D14

