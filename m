Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911807;
	b=Gau8UjmnGcOLwZ6+0HukDISH9RuX95t/9DD/iLwfKQdL2RFLtgg6gc5NAcO7G48cc09v
	 dEzOWVWOC9xczvolGNMR9hhvn7wsOkEW5Z0QnqI6U/uqws3ITgvvcxolzp0Ppqf732p/J
	 uY3ypMiB4dRlfp6g5yKTY1EiRWtml6UoG0mbK9qEND4w2hMmIpEQFWtFEYpxfcMaKguoq
	 deuTnkFdcbguUDsCgq4hTI9OWUXyHj3GCs/x7rlaS3F0gh604tx8OR2qL4OXbpcITSdJZ
	 XIko1Ws1dWbRlOMoNx1W47ZD/e08WFw/Sq2lumpJ7b4DXvAINN3R+mcg4QD0ipfbBtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911807;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/bppDg3RBbvOL1WvwxNeto/+jI6ToplfCDuhJuCq3uo=;
	b=BAWlFIp9lzhyz2l7KNvitoVC8N+u/rq/Ksx0rtNKoW81O4SgxKxgxSCeYjubwl5LvhqX
	 4IP5T1VG8jOV6ISlJ+uVkMuYlW2/Z9oyqUb+CfMzeqNhHeMEi86EXF3dDk9cmEbIy/y8F
	 qduBNKNSLfLlSx+YlMYT1/yWVp4AuLFUekEs5OsUph1RK221NihcVix6aKmyw4L+JTVLj
	 r7MT76r9/uLuXmNvbYaPXFprW1ZMyzsRR9WNtXLGGbSrDXnGZqFJrGrvKHjWFz7a0rY1y
	 n36zCQPlKuHeAEutqHbcotlgRvtSGtSM+UV8WkDzqRvnWz3Vmq4Um0IjNxifs16nFgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n1viOvN2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B9F606A8B9
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n1viOvN2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989AE1F000C8;
	Tue, 17 Nov 2026 10:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911806;
	bh=/bppDg3RBbvOL1WvwxNeto/+jI6ToplfCDuhJuCq3uo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n1viOvN2Q3lhhlAIR1/EGpx3fidDoeBnrY2oH4GDlLPIfUmrZuh4wK7CuWY0jQC2B
	 cbjqkgusjO5zJRZtk7Kk6UpbswWbgvt8qCjL7APLBvGuz+Omd0lUwVTxryxsaOS/Fd
	 M7eh5BlyQNXVkvw5nPv8VaUqsPab5exovbsXJERwPfFYQ8pWBJX7tul1pJeu7ohlxd
	 qvSCrXEJSD5593T97Jzc+2IZeeyWL5z8gjZFzWhPoJVaBtoz1EQL6KXamE57ZdyCtl
	 BeN/8Ges6i59X4SNryE4RhmTRHocAIrrUgtLy7VALqAjZQtGxTd/0BeGGr1LX/roxU
	 OiDPeygyoDc/g==
Message-ID: <sashiko-outbox-218635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 07/10] net/mlx5: LAG, resolve affinity
 indices only in queue-affinity mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116103010.1129666-8-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
 <20261116103010.1129666-8-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 10:36:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_cmd_create_lag() resolved the first two members up front via
> mlx5_lag_get_dev_index_by_seq() and returned -EINVAL if either failed,
> but only the queue-affinity mode uses them.
>=20
> Move the lookup into that case.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116103010.1129=
666-1-tariqt@nvidia.com?part=3D7

