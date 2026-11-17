Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904413;
	b=FYiHAGyoKSEKVmFMGbBagHsBaF7F/HjLtYDVFv12DP7a5ctDmFPBbpEgAknwXjbERlxX
	 sHb2mdXkafRYelLP6kPcoQMThSdO1ZGpBkOd7EoKfmLwMe9lGc1oFYYOkzNoIBloMWSAL
	 RO6+GXEeUXNASL2+f6VfKvc/pRIkS6XSBOkmt+JdqpOw79ToSg+WLCWbsgR2kLYKlezVO
	 ASsXww8nzSfQ6N0tnLK2DFFTcbArzudvEedwbF7RMQYhaSvKsJYMWkCt7zGFru1IsCOt6
	 kpNDhZxivaloFy6d54trrk4kWkbBBsfYOznp3u6v2QVVeiqtBoyyO0St8YF8Kn1j7jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904413;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wLj6l8i9QYp7kBYn1R0r+vzyDiOu5k/K2sVn8qLibGA=;
	b=ZdAKmy+rgmmyB3v7D5KbXSO5nsQKOqvChfW+B4rDInyVSuoibfuzU10zFD1GM5vrdQWv
	 UkEp4h+4NGzXpF3DcdkSHq4ku6hG4qoS/0PkgfmBTkTLshtBXVhbPnO2mkSvDZu5cVJfg
	 LRucezloowQyTmPDfk0wKKYhSYZwBlYyGltcROPPz8wANVwTUIrqoQmrsodeQc0AAyFjV
	 EcG8Pd51bdztHcMmIsSRn3V6u4Z4kWKm6HyucfOWHAwt2sM7iqe4D6dkKY9H/kCJBp2DB
	 S2T8e/wnifnqk9XCoVV6A+ofvBvvmRXU+PbbEBWlcHqwxb/cwLxki12GhRJkR6MQ5Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aHLUYZJf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D852606A898
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 08:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aHLUYZJf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB2E1F000C4;
	Tue, 17 Nov 2026 08:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794904413;
	bh=wLj6l8i9QYp7kBYn1R0r+vzyDiOu5k/K2sVn8qLibGA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aHLUYZJftaPLvkgSrJSSIDzMJeeKQpRD9gh1P5m5kQ59PdYkkaheCr7shW6cq/zJI
	 orL88f0QrA+JfUgrXDKiNpErJJZ9B9uZKkefFDV8xxZ2CfQU3iDP7AbMawBu1nGCxe
	 CWzNMBJXMZHsFH0s9tDlR2GHPRAGTlQFaMWDXUDVux4PwqNy/PeFOlBEqqIEnFmCuz
	 8wjZJTyKQRf4LunRR0S/s+9GlTuZGzk7RLZ1+RN/5JAdTucp0P2exHw2Mwhfszmu6P
	 fC62+OrpWohZRTmlRD16SCDnNm+608Raz4Kg3Bevdio/iz0XQnAgS2cY1LKp7X07NC
	 lQBuGvWFui/dA==
Message-ID: <sashiko-outbox-218420@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3] net/rds: defer CM id destruction to a workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aibing Chen" <chenaibing@cmss.chinamobile.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117082145.1737-1-chenaibing@cmss.chinamobile.com>
References: <20261116075423.782-1-chenaibing@cmss.chinamobile.com>
 <20261117082145.1737-1-chenaibing@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 08:33:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rds_ib_laddr_check_cm() destroys the RDMA CM id it created while
> rds_trans_get_preferred() holds rds_trans_sem for reading.  The bind
> path then takes rds_trans_sem and afterwards handler_mutex in
> rdma_destroy_id(), while the CM callback path takes handler_mutex in
> cma_ib_req_handler() and afterwards rds_trans_sem through
> rds_conn_create().  lockdep reports the resulting cycle.
>=20
> Queue the destruction on rds_wq instead, so that rds_trans_sem is
> released before handler_mutex is taken.  The work item is allocated
> before the CM id is created and owns the id until rdma_destroy_id() has
> run; if the allocation fails, the address check fails with -ENOMEM
> rather than falling back to the synchronous destroy, which would bring
> the deadlock back under memory pressure.
>=20
> rds_ib_exit() flushes rds_wq after rds_trans_unregister() so that no
> queued destroy runs after the module text is gone.
>=20
> Reported-by: syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dccdb5058c3df2d94811c
> Suggested-by: Hillf Danton <hdanton@sina.com>
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Suggested-by: Allison Henderson <achender@kernel.org>
> Fixes: ec16227e1414 ("RDS/IB: Infiniband transport")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117082145.1737=
-1-chenaibing@cmss.chinamobile.com?part=3D1

