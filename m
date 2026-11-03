Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675778;
	b=PioprisYdlC9bUsv+mhbO//mjG8s60DHiFXU7wSuiqnD2bTnFvGyBFGtn5VDOgTqSVCU
	 738v3bq9K5ormzJ0oDo3IjblIqYy2ARfupIvYLhE+rfFiI1Ohg9xdjX9pKCJcSMKh2v7K
	 WVifjiTM+ykm3n0xIbI+Vv0UIH5MEfScnpVYSe5LcvkfuX2TPl07ETCvSN9iUWIpqRTcV
	 2uz6kWWFfAfoZuExK86nDmHF6h2ShKp//uGUTs3Z8Qfka1cg0kXNeXAsmW1VeDyaHSXg+
	 M9JSK8qi15A6yxbrUvpVuCO9ESFSWNOvzqUU41+cwzTvENX1m8NaraprMW3dTcHYeBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675778;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zI1tzutuu7aQB59gmhklsLpqzXXFGye8RpX42x+13JY=;
	b=Yc62nGY+/FU3bU7pAGBDpb/BbiTB1V2mXawqJ7lJwAMm3Hr9AyppQ+ikOq/JBWbobSCF
	 EjYWVT7txSoUEra5yu9FeMk3F8NtZLsTEfGtAdb0WH3oFZ3OF6fYuH5nRLUI9XZSuXkI/
	 Pve7O4yJuqK9SrR9CXE5ph+TJD3bCx2RQl4d068tmXYUaXI4+xNLzjLKcN+NvAKZFDtbL
	 xqLD/pxwAJpJZ4MoG8npo/t3bz2wQcgQ0Np+Dj0n9vPWbc8MBn2Mk503V6jcDLBdZcAoz
	 0bKpXnpY2uN7UwdSWHQHZWJn1/Is2daa2a+QuwwLt8Wj9gvcHgVB0tKHAnvI+mObgMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nN1YRU5F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5E1606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 03:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nN1YRU5F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4555C1F000C1;
	Tue,  3 Nov 2026 03:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793675777;
	bh=zI1tzutuu7aQB59gmhklsLpqzXXFGye8RpX42x+13JY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nN1YRU5FjJeayLaodu6Vq7QFKNB0f+aXrl3HU7AP/DmVpQmqMIJcJFOmHGBE+vbcD
	 b3YzXCVRMddpu2L71955Wa+Gvs+iaQq8G+6vaLxYqXgeDiBCuGQOlLqjQCQ2AO2Z2D
	 73r7scX8WcpKVX4UbuaNOlunU4pZq0fMHzTkuvKWzHbJkldp4UgDPg4LXuB0nyNAXs
	 wmdf0vLAxR5FchUbyowsrpuiYkbhPl6cC2dr8GZpdRWRR+9uDb+xrAXNbW5eXv8LAH
	 kUhmOIB2r3WM5/e5WYoQjQXfH30KCzXXF6vue+XnFs3aaJFPcw7r//1T0ogG3+lIQ/
	 GlLf7/gGeFOPA==
Message-ID: <sashiko-outbox-194502@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] rpcrdma: Serialize notification registration
 with device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Xiasong" <lixiasong1@huawei.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103032758.1302493-2-lixiasong1@huawei.com>
References: <20261103032758.1302493-1-lixiasong1@huawei.com>
 <20261103032758.1302493-2-lixiasong1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 03:16:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rpcrdma_rn_register() checks RPCRDMA_RD_F_REMOVING before publishing the
> notification and taking a reference on the rpcrdma_device. Nothing
> serializes these operations with rpcrdma_remove_one(). Device removal
> can therefore free the private data after the check but before xa_alloc()
> or kref_get(), resulting in a use-after-free. It can also finish its
> notification walk before a new registration is published, leaving the
> removal path waiting for a registrant that was never notified.
>=20
> Use a module-wide mutex to protect the client-data lookup, removal-state
> check, notification publication and reference acquisition against the
> transition to REMOVING. Clear client-data under the same mutex before
> destroying the XArray and freeing the private data, so a later lookup
> cannot return a stale pointer. Keep notification callbacks and completion
> waits outside the critical sections.
>=20
> Fixes: 7e86845a0346 ("rpcrdma: Implement generic device removal")
> Signed-off-by: Li Xiasong <lixiasong1@huawei.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103032758.1302=
493-1-lixiasong1@huawei.com?part=3D1

