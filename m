Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794478068;
	b=1g1tumIYWuih8ssmk9S0KhpBaPpuWc2TDehmrWlDkuNE/816GJrxSlVw7dlVNImm88tH
	 4SR3SE+P4D93pCs+Xy2U7DMtowXZMKLlAXg2vn5bB+7dsv2nPpGGo97RFn/tymPKTjujL
	 PIk+xp1O+TzE0Zk3VzigIfTP+VrvejDHXR/nsbqiwNtzspr9p0/Xq1fma7Tt2vwnqbq2f
	 N/u4f93jggl3JMUo7BmD8njrfguqZTqYOYgzf16JUdJRM2fWSV9wyAVSbMt4648eGmCpw
	 reLvbZaYzUbOtAuxXvmWi27TiNS7Gm2PsuhNTPoiqx2HLIc0FGU5tv0g0Do5QXkxVNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478068;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CB8hpFcaKprHhoAZRaCL1l/n1/2Q6E5P58wFUUAlJYA=;
	b=DWztIel1NtldjGHwWZb+B04pk2KBb936sUftlBsJVMbYgaLJkrDxDVcOmsEN1KODKXEX
	 0L9f6a1Zr7zrcAkgIxZ3cvS86W1orV30Mt+SbYKX/gNmW85gj8dUzM1MLN0VxMXz9ZCp1
	 bhSARjagqVVhYrydyg7qU2KO0ob2Va0UnP061dJj/Q7gOkd2kUDrKkwgIUM4YbW9I/izQ
	 w/GRWDIDfqPYLHhl+qCL600y5jq8eOdjDk8RcxZ7D8SqVSxTEB+zBJVyBPXI3mTUCsigh
	 7G9yfdRFVsv/DPkt4FpkrZ9pxvDlSlGspdUFevdAAuYRTZmz+m475f2HW1hPoZrR2ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R6apUdRW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04308606A321
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 10:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R6apUdRW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F571F00A05;
	Thu, 12 Nov 2026 10:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794478067;
	bh=CB8hpFcaKprHhoAZRaCL1l/n1/2Q6E5P58wFUUAlJYA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R6apUdRWvgGRDV5I2oPauAPXm0LN7rdo+WwJTM1Ac/y8GzJLT3qI0nx5p+AMWXGkX
	 9OVe+GgG5bkivvDp2Nd0lbBMPCXrVbpeKVjlwlgn1kKrXpOoBeQG5n36BvXp3gyyoG
	 2HdvdsFAVZxCMb82kMKqDdKz7zqtBfSvAm8h0HD+AbiLsHacZSUZ1iOQsGcaQqSLB6
	 xKXf8gH9CDE8kW4F2bJ9zW/5SC3f3MrEabD7RzscHgysS/924nvKRdQGuMNNFsgHws
	 Xa0xXgRnv0j/wked88olV5lzmvwmE0I0e7vGafqWab6oh8vN86aVUuIwwuuDA9q1Sf
	 dX7sWsBtejp7Q==
Message-ID: <sashiko-outbox-210923@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] RDMA/srpt: Prevent uninitialized read buffer
 disclosure
Reply-To: sashiko-reviews@lists.linux.dev
To: liuyong <pkfxxxing@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112094138.1390409-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
 <20261110030809.913063-2-pkfxxxing@gmail.com>
 <20261110052827.963143-1-pkfxxxing@gmail.com>
 <20261111065342.1282709-1-pkfxxxing@gmail.com>
 <20261112094138.1390409-1-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 10:07:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Yong Liu <pkfxxxing@gmail.com>
>=20
> SRPT allocates read buffers and creates RDMA contexts from the
> initiator's descriptors before parsing the CDB. When target core reduces
> cmd->data_length, a backend such as rd_mcp fills only the shorter
> length, but the prebuilt RDMA transfer still sends the full buffer.
> Control CDB handlers can also leave bytes within cmd->data_length
> unwritten, while target core only clears the first SG entry of these
> preallocated buffers. Both cases can disclose stale target kernel memory
> to a remote initiator with access to the LUN.
>=20
> Reject indirect descriptor tables whose direct descriptor lengths do not
> sum to the advertised total before allocating RDMA contexts. Also
> initialize commands rejected during descriptor parsing so the BUSY
> response path has valid callbacks and a command reference.
>=20
> Save the original buffer length and zero the entire control read buffer
> before command execution. For data READs, zero any tail beyond
> cmd->data_length before posting the existing RDMA transfers. Synchronize
> each mapped SG list for device access in the response path.
>=20
> The issue was discovered by Qihoo 360's Tulongfeng multi-agent system.
>=20
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API=
")
> Fixes: 8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMF subm=
ission failure")
> Cc: stable@vger.kernel.org
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Yong Liu <pkfxxxing@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112094138.1390=
409-1-pkfxxxing@gmail.com?part=3D1

