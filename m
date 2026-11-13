Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546314;
	b=eiuGUYdnrGpbYsDzLxltKNeIaGjSrnnQqSNIx4HCkyeuSWzteJLW3oxAdxqQLwCZfYls
	 BsWbJfw7dvDHgXrc2D6f1IZmndr9MMC3mCJD6/L31EkwvaZWUpfmbnbdHt9qkdp6CeMVb
	 LLCNEt4o8/gt/xGhBLUfr7iSe64bCyNNHW4RDdKGDIhOY5mHZBUmnWjcUqMN98rRLBvyr
	 lW1Q3DHvi4D5p8/jXpPHTxvrSRDwbrdBtZXN/SUpLnQ6kqMjv5yy9ScPBDFcJg+ot/Q8D
	 lRIyUUUxZfLTe5gDitqloBuETK5xwoqkPRlSj8Q2fkqQp5dGsNLXfiogKZ3rHzYxMBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546314;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=l/B/r1XeJV651MfmVEntwzPERt9XBLbrS0USMs3ssTg=;
	b=dFL32bdmfKzj1WZkAybM6EVZgUA0cb9Dft3hmEy/vfr1JNigiAN59pSud/HYk0L4QPYZ
	 KiMKOC6W9R8yN90OQ8M7AtBrFf4Gs8KVKgr1CJcEgzNpaQ8Tmcn/k5TFS+Bh04KQT7ITn
	 sdvcZEpJ9BsRCXW7jaTnVnITJ5kAuiQeRSGAxzlqh/erDEIpj5dMEbjY9fCON6Kl926Wl
	 vWNsRzk5CN6iUWl2EXYoNV/Qk12ygOjiBf405lY1JwiRdbQhQXsrsaxcvou19UhojaoSz
	 LOHyGmHttd/LVCSn1WD3s/Ma6ZsFHs2zHTomEVhhsbD8GbRS2LdnW51b16/I15U+eCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFMHieAZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62E8606A339
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFMHieAZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05CD1F000C4;
	Fri, 13 Nov 2026 05:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546314;
	bh=l/B/r1XeJV651MfmVEntwzPERt9XBLbrS0USMs3ssTg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=QFMHieAZCVu/ejGZVV+earKuBiXudGPY0SL1p1nf8k8JjqeuYVbSC0+jBZoy8DDh/
	 vOKr+4L3nJUjhljYdEnC+zqtCP2Kw7TQb0vqxNa8Ol+CnRpMDZ4A+yAKm4/jzR9Bd9
	 9xC3A+bSRMUg0yhPRMEzWgzb65gp/F7yEy2kL7Ac+PRdoYgooDdnhsu6bB9QTet2e0
	 E/DzrPc6KUXeP+bfKsqjZRydVFcugwKEraxjB6bV3Z1ho1XW6/j95aThdqIve9chle
	 a+ZGrAyRmxP9hffg+ODsJiUiCL5ARlheFaqBXyo962qBSTXuMTIgdDmb8ZgZgGOWJ4
	 bUFrejy/hKIeQ==
Message-ID: <sashiko-outbox-212195@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 06/12] net/rds: unlink transport nodes
 before a possibly deferred connection free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-7-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-7-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The transport teardown helpers - rds_tcp_destroy_conns(),
> rds_tcp_kill_sock(), rds_ib_destroy_nodev_conns(), rds_loop_exit() and
> rds_loop_kill_conns() - gather the per-connection transport nodes onto
> a list head on their own stack and call rds_conn_destroy() for each.
> The node is unlinked much later, by the transport's conn_free():
> rds_tcp_conn_free() skips a node that rds_tcp_kill_sock() marked
> detached, while rds_loop_conn_free() and rds_ib_conn_free() list_del()
> it unconditionally.
>=20
> That is fine for as long as rds_conn_destroy() frees the connection
> before it returns, which is still the case at this point in the
> series: the initial reference is the only one.  The following patches
> hand out references that outlive the teardown loop - a socket's
> cached rs_conn, an inc parked on a receive queue - and with those, a
> conn_free() deferred until after the helper has returned would
> [ ... ]
>=20
> Fixes: 4716af3897e9 ("net/rds: Give each connection path its own workqueu=
e")
> Cc: <stable+noautosel@kernel.org> # depends on the connection reference c=
ounting earlier in this series
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D6

