Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749565;
	b=ZYdwxG7woeTrTBy2rB5+9Lpsh7iShXaEgZKcO+oPnfcqd52t4FA1PnhV1Yjfj6PO4+Y7
	 9PxNFHnIBi5UaJSCHtgB6f4oDwPE3CLCyHMzzhmU63T7RHLIiX25U2Zjjr5E0+bBx8nnG
	 q5zHVcbzuej072EAwkphhMYljiSGaH0FWC6Y0Fuk4j/L2ck0zzNRoH22lCem5E9CRzbd9
	 ARJTVn5q2x+II/mcanK602gyOmXQN24Bms1qkPM6bqyexqrE05DYjS690xWyw+IY/nR4k
	 aleI8gTKg8ZuLd9668I/vSuur7fX38tw4qFnyXvGBltY8b4D4tyI64wqBOTjGF+CMMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749565;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ltL7SSQgFr74Q7X3XXYiZSAYkydzYow6DVjRiLxzT68=;
	b=ao3TDlhWUrK1EZJ6ynZAFPwWSUBeusQtWm5pC6wKFx5IVfC/W7W/TCUPWxDRO8tRQ0Gv
	 bSOAFKNKE7/oX+wYmRLgAcJqliQiMhjQaPwOTrPtynciTiV0Io39W8F+RmU6p9kYhCdgw
	 CivBZbTtwRajwpb/mn2q0YyHScI7bxu1WRdDx4IQXPYwSeRx4kr9GuHsM91IqnX9iJFZY
	 mNJPUC422H/yH73iycPB8gzzzXsefw/ecgXqm32DPgzwHw2i3xJDyOQQ0IO/WjKOCbOFj
	 6d7zNfqvu9fHPXqq2uBD2Q6Yeps33Agxy5GErRlEK4Xog5pHFZF9FGVFAmabIiiVvzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c1I6CeFL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168F5606A323
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c1I6CeFL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAE71F000CC;
	Sun, 15 Nov 2026 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794749564;
	bh=ltL7SSQgFr74Q7X3XXYiZSAYkydzYow6DVjRiLxzT68=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c1I6CeFLoc7THosidwTP2BQOk0vPN5R619bL4bTXU25I9GSIrLQONGj+vclhoexc3
	 zhbZLijSrxym5K6HtzWUk1AlN5wOD1jMI9eNAL7LP0BENaKeMyd5JW8oV+/akjzFBA
	 gVXsnpWvQIzWPhQ/JIXVKGbMc0bWuUwW/cXuYRIP7tX0BDzWnPF9Ks+I5O6VBE005G
	 L2tz5x8NtBhA1RoJSoPutbzAJU4wdG5ZWfewgRENMqebS+D47FVzMDjlehcX9xeNwh
	 Au1EiGqgnW3SUhPpJaaybQ+1YNgCJS8wMgDoY/HReKJfl1kqow0aB5HULu2IPa6obC
	 jaT9gRavXBaKw==
Message-ID: <sashiko-outbox-215532@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 net-next 4/5] net/rds/tcp.c: move sysctl-only code
 under CONFIG_SYSCTL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <avmywjLAQO-9fhw5@redhat.com>
References: <avmywjLAQO-9fhw5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 13:32:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Collect all code used only when CONFIG_SYSCTL=3Dy into a single block and
> wrap it in #ifdef CONFIG_SYSCTL. rds_tcp_init_net_sysctl no longer needs
> the IS_ENABLED() check.
>=20
> Add the corresponding init/exit stubs for the CONFIG_SYSCTL=3Dn case.
>=20
> Also #ifdef the rds_tcp_sysctl and ctl_table fields in struct rds_tcp_net.
>=20
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/avmymGvelu00X5EH@re=
dhat.com?part=3D4

