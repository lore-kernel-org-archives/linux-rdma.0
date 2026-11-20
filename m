Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795163662;
	b=dauR3ia6dGhBkHStM38lJ4FSwaLIMU4nKYe31ck5+aQOa3Zw65du0RQAWEaqXKWaNnFs
	 ZYGavUpdTfB8MEQLsxo2g8N0hfTC/amwYWpj3rd2i8iElEH37N10PlIcsz86Sr8IziQTa
	 +hjCDpXaqD5XAAHByuYyxZiXrqLQ5G9jLbXWYh6Skn1Y2NxGybTQ8EgsUMDTe3jQbs3Gf
	 rN5p2b8e/Wdl1DbpkOGVHsMTBU65myO6vLq6Gk4wnnbKWf7qPXbIk428rWxdfCk9YrKEj
	 fNCkNq07XYar0UmxOlaRdg0EvoHuVe2amdr7LRiSgEdTnZb8gyyX8ec66l8Cn6MHJ8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163662;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4IsYEYukQfWDWrFkmw1yEmjq0MPZExvVbH2Su2NxCAc=;
	b=c4p99DO/nXu7uu8ZUPb2lPwJ4JNnxUBxqXQkSdb5+WFdN5e4wWtB7kmilhCQLGdAAwIU
	 hjQhRbCO3W5vbvaMI0Rn1QqM4eNxr+8YccvSbp+N3SKz1LARp03GDf0Kv7Dli0HMRU4qG
	 axhLTLr4ufJkJV8MpaAurNbr6VpuQOErI2+gCuV2Ceml0+b9QbcRolvzrl0CVfSEfD6Zz
	 VsbJdW8kipDTX5ZiRfyWhI5EyBJR3aJAnodNCGvuLgP2t1KAKixoOWk3N6fmOgjpMm123
	 vaEM0gfU1Ufys72NH8TaK4wtPNh97BiiEKTJu0rFWy4H/0ZuEpO4FscbJ5QDxai50OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XSjtcCBV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6710606A330
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 08:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XSjtcCBV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E151F000D0;
	Fri, 20 Nov 2026 08:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795163662;
	bh=4IsYEYukQfWDWrFkmw1yEmjq0MPZExvVbH2Su2NxCAc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XSjtcCBVnDHtSVQVevc5oDR1dhsTrgYIyt9wo+flMwvNTlHk+tq0YAWMn0Dm6P8Rh
	 gViIOE+A3vJvnKf/Ef3x2BuykvV6f45+qyBUbgUhPTThSJIf+rZrCkBVqO+qCk1Ny7
	 Nn/WcnXutsLBgXIIouIQMnkPiqc9SwL/Cp9tMrA1LcZtBruJ2hqGr6WES0crJvUXdD
	 pQD/jEqu7Mv//iUdx4duVPWr7SyZvj/RLdgXxhfQMXC2Ci2WFt75RK8gOBnhzmQ8SR
	 knwPqw0cUSi+sHaPtBJ9zPpPVLgry7v8drGjj+Dn8Iwo6CZffjjAT1uA2bfFdHHbeR
	 Gv7QXxeZBMtFA==
Message-ID: <sashiko-outbox-224745@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/2] net/mlx5e: Fix incorrect name of
 rx_symbol_err_phy counter in documentation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120083050.2540739-3-tariqt@nvidia.com>
References: <20261120083050.2540739-1-tariqt@nvidia.com>
 <20261120083050.2540739-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 08:34:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Gal Pressman <gal@nvidia.com>
>=20
> rx_symbol_err_phy was incorrectly referenced as rx_symbol_error_phy in
> the rx_crc_errors_phy description, fix it.
>=20
> Fixes: 8ce3b586faa4 ("net/mlx5: Add counter information to mlx5 driver do=
cumentation")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Nimrod Oren <noren@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120083050.2540=
739-1-tariqt@nvidia.com?part=3D2

