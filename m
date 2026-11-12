Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794471768;
	b=kmZB4dvyurTTme2WchGzQQYMUsefl5cLJS/VsmszR5acN+DojsROYnNJe8rroPmV+UQI
	 BUb8gyvRl7kh9Vb17copOfgPYoqG6PDUZYwrpIQNiu76H02Ln74eEMXQzkjW76Ok5E/x0
	 KGV6ear39tGgoWLdrx8Xs4f6CInbBajt4G2JzwbGE18EOWrOyIG40Nm5lpjhOw1vhTH51
	 bHKFZNgiC64wj+nrYtGy0a+6ZtGikzNVbIDv3i0Lfw1dtOytI3E8Mp1QRFh7zeJKBWxTF
	 Pszu03+0GzuU3p6mqEhPUwBoksNukDy4pQFW5i+xZWZBnqQfiOZ0bjZScmkLM0INV/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471768;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hc254WQ4CZMoEi3VRWSFNcSUQ4OJ2qlc1/0rpQjGZhs=;
	b=CAAXwllIIBabnmvmKc7ggnfDSk3eEfZhdGdCfxZU7LX0FczxKIUrdQxmlpLnD1VABfFm
	 FBsvtzMwOh2jJ0Ba0PgEtp/qL6STAXuhHeHYelgFUpCBPiKbZ60AiY36xguVfsIniz/fK
	 yos9IVztGWn7KSVnuiqrZP6rHPGWpklV3RN/pv25SOf5YrTpY4N2NG6u1hK/jErcmfetG
	 lGpqnosNwT7l88pRXPz9HNbvK6D+xF9d07WAt6+UlUrJf5HPa33xtRFu5u4J73MTf/3PK
	 b8AaxkRzJ1PPv9GWMEQZMVsk/8PJ47Zk7sruxV5ia48wtxBbMKJDfOUk1E63KVrtuoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jqSDt3HX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1F4606A32D
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 08:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jqSDt3HX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1593E1F00A05;
	Thu, 12 Nov 2026 08:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794471768;
	bh=hc254WQ4CZMoEi3VRWSFNcSUQ4OJ2qlc1/0rpQjGZhs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jqSDt3HXx5D8jyxTDCde9dOAyg27cyauAjle3tUvePn0JoyLiuPPEHfTd20mP3IMd
	 JEQmFrlunS2C3bwAOjZoh07eQczic/lZyTzPJszPtfY/uNHzvHMLRki+0/E4P3L645
	 DJR9FqWcz/HtUdWstcEQ7UzyMovK4QhHEnB61mXQHISzBfk9dQST/eNJ2ahO4dktYS
	 zi34py13Gu3njlZcSmZQUbizVKcjfyaUoGek/puYjM3sjc2+nAYf5KkY9MpWsV3goR
	 s4eMOli7rnI0ESWOBDvTFAzUP3+hAezAydXRpAApOEXxGspyBJ7eg+HMfSMaasHUqw
	 MUpgyJ2mii1/A==
Message-ID: <sashiko-outbox-210696@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V3] driver core: auxiliary bus: Fix IRQ sysfs directory
 cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112081319.3466442-1-tariqt@nvidia.com>
References: <20261112081319.3466442-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 08:22:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Amir Tzin <amirtz@nvidia.com>
>=20
> In case an auxiliary device with IRQs directory is unbound, the
> directory is released, but auxdev->sysfs.irq_dir_exists remains true.
> This leads to a failure recreating the directory on bind.
>=20
> [] mlx5_core.sf mlx5_core.sf.2: mlx5_irq_affinity_request:167:(pid 1939):
>    Failed to create sysfs entry for irq 56, ret =3D -2
> [] mlx5_core.sf mlx5_core.sf.2: mlx5_eq_table_create:1195:(pid 1939):
>    Failed to create async EQs
> [] mlx5_core.sf mlx5_core.sf.2: mlx5_load:1362:(pid 1939):
>    Failed to create EQs
>=20
> The irqs directory state is described by three pieces: the sysfs group,
> the irq_dir_exists flag and the irqs xarray. Currently, only the sysfs
> group removal is managed by the devres API, and on unbind the group is
> removed while the flag and xarray are left intact. Thus, a subsequent
> bind sees irq_dir_exists still set and skips recreating the directory.
>=20
> Manage all three under a single release function passed to
> devm_add_action_or_reset(), so the whole directory state is created and
> destroyed as a unit.
>=20
> Fixes: a808878308a8 ("driver core: auxiliary bus: show auxiliary device I=
RQs")
> Suggested-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Amir Tzin <amirtz@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112081319.3466=
442-1-tariqt@nvidia.com?part=3D1

