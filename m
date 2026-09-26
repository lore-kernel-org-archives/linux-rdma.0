Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878B8412BE4
	for <linux-rdma@vger.kernel.org>; Sat, 26 Sep 2026 11:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790422378; cv=none; b=sTtxphQlaLjr9i4ei9Y/OwDa5D/cEXVYwNDFFBI02qfxKg3LuoeUmqbZcS/fLY2WMi7tRw/O7PJF4NXI49xSK8lno7cFOJ/8gFoREnGNhqYJi26JyWE0BrMLKP2nmnyRYeVRmL5fUy+sd+VkyWmULRJheGMJBoJpX+ge7GtDSCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790422378; c=relaxed/simple;
	bh=F3afvsVYIW37f3CSLP4LMNpfYCofLabT/8uzlWPTai0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E/eBVhvuldpgAPdJbgy8VNwL/JPUWixzyzqmxaNyGm6knTLf/+4Bi8ZS8J9H7+qqC09MCUM/3Q/dkRcWdwYEaybw5T6bl7wXFDr3fNuul09+W8y2NePwn1kO6sHT9+QTEE0hBxnze4w7eRN3Dz8EweQ0wOy48BTfPx7oYjLv2eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILEwmuDc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILEwmuDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C5C1F000FF;
	Sat, 26 Sep 2026 11:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790422374;
	bh=F3afvsVYIW37f3CSLP4LMNpfYCofLabT/8uzlWPTai0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ILEwmuDcuyU5/l0wMxss/EaRFLQAkME5LiPRHyyTvusv/e+/eJNgCYmCIOoxVzGdM
	 tcSPWMCNhHhNsJheQz1f5Ehn9/8KqEF8YH5QbECi9WzB0Sc4l3siOHgBtLHyG8wHWe
	 CQfpvCgpwYGhZWx7AZa5iMtnRlaiJLf3bbFncQMss3G+WiEp8elix7jhG+73fwRNQo
	 W6lhkyCWSp0s0A4piSN03BM17ioS7qsMugjtMa7K+g7R5oMpfZLD+CsXsjrbl035Zg
	 qD3u1RIYPNcaT7kkUNPlOIlhsU/vWiO/+VJTjZV47ZjyVVrVWYg8JnpUfVPTRjf8ub
	 WYHVN+xW+PpnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Do not allow userspace to write the status
 page
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260926112611.3214382-1-yaojiale02@163.com>
References: <20260926112611.3214382-1-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 11:32:53 +0000
Message-Id: <20260926113254.43C5C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The device status page is shared by all userspace contexts and contains
> db_off, which the driver updates to control doorbell flow. The rdma-core
> provider maps it with PROT_READ, but c4iw_mmap() passes the requested page
> protection through when handling CXGB4_MMAP_CONTIG.
>=20
> A process can therefore request PROT_WRITE directly or later upgrade a
> read-only mapping with mprotect() because VM_MAYWRITE remains set. This
> lets userspace alter device-wide flow-control state seen by the kernel and
> other contexts.
>=20
> Reject initially writable mappings and clear VM_MAYWRITE before mapping t=
he
> page. This preserves the existing read-only userspace ABI.
>=20
> Fixes: 05eb23893c2c ("cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926112611.3214=
382-1-yaojiale02@163.com?part=3D1

