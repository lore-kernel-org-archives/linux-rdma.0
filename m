Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911801;
	b=RY9hENIH3yFEaNV7/DBlzS9RT5xqLcWKROkQpbZKQshTZlZQechWo4De/03j+MZujb4I
	 OnqeuaCVAL3hRw1GiAnggGcu8trAIc3FLlfVthPj1aDd2OWVBtsbFqNCGR0SnF3A/cB+r
	 4vfbtLfxvgnnnd6MNu5qao5DbO+gRTiEDAdv6q0ov8feEHgATDX21rFCGk+jPWM81H2Rz
	 7VR13jkL4ID0g3EtdeDHRklmup9SXzQPCXtZh3KshpsSklT8Ey+soLj4xfukfeWv5sKbj
	 axhINts5BeH8fBG4cooC9yKcK4Y2STHHpj3iYqZrLGjek5ZG2wAIxfocdlBn02pOIpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911801;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IIiayWe9cpXauGSzb3k5+Wl3Ecj1DKBHolVrRnx8zqk=;
	b=luVx/w1a/w3j/+vV2k3G1LkKfMF5qaecCFhCNNFfYxQrc9qTEJy3Nho6afh7eqXEK6jA
	 McOfxTMHBTwpXHxRWnmXm1HBUN+QX0mYVi8LXQtGyQMbotDDXckDcsLXziV99SuNRKN9r
	 ybSa2y4Q52SIRaATYkyqGb9RRbchqe2e3M+nKkxhqB3I9mkKyrEYIoIoEvMxF6pg6tBK5
	 it+F/CP1aekr2y6GF1zAqjJrjpNUutPEgdF3HBrtPpfnxEWE+yWWeen4MKoCch0Pw/WLh
	 sdlKgqiNVnlv5eRr4w6mvM2qkkCNWTDBpC1dE0MmC8xJTplvMojP4HXZ1p7vcVHgy7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eqXzCSsT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E384606A330
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eqXzCSsT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23231F000C4;
	Tue, 17 Nov 2026 10:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911801;
	bh=IIiayWe9cpXauGSzb3k5+Wl3Ecj1DKBHolVrRnx8zqk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eqXzCSsT9Iz6UQuyIFFf0XLxTtZMG9ej6zxsXLmmuNapCfHNfa8jokMaTuRrfqSs3
	 hTP6W84FJLWKVvLwJdSYhVH8klSF5h9NjSAmPyFVBxAXUTHE2/7FXOLwbyIKBUFPWT
	 uZ1/mIyIfGePxMeMO4g9G0g8nLmVic7D6qnCUUcxGOvAJvbrtLOwCZ/S4e2Vg0/trn
	 SoYi1KV4XXuMTt/ez96P4/bvwRJP/zv4vxzMP4SV9/hHh08iWCejUQ7OYqKOZDdLzh
	 G2tHLGivz48hLCc5MK9R5PJ2lX+P5rMXXWBBlwB9VKGhVVo0c6qSfQ+JzlIS24HS30
	 u2NJNOpQpBaZQ==
Message-ID: <sashiko-outbox-218631@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 03/10] net/mlx5: LAG, skip phys LAG
 prerequisites for a virt LAG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116103010.1129666-4-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
 <20261116103010.1129666-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 10:36:40 +0000
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
> mlx5_lag_enable_mpesw() gates on port_select_flow_table and
> create_lag_when_not_master_up, and on mlx5_lag_check_prereq(). Those
> describe the phys LAG: the port-selection flow table and the
> physical-LAG prerequisites (e.g. member count equal to the physical port
> count).
>=20
> A LAG of VFs/SFs still issues the same CREATE_LAG command in MPESW mode
> from its master. Issued by a VF/SF, though, the command has different
> semantics: it does not create a LAG of physical ports, so these checks
> do not apply and would reject it outright. Require them only when it is
> a phys LAG; a LAG of VFs/SFs instead requires port_select_eswitch.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116103010.1129=
666-1-tariqt@nvidia.com?part=3D3

