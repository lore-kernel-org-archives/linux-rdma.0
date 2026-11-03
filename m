Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699724;
	b=q9pyYjeE4hPLsR/EQhiVZP0HKl1x3RRmO7NIdB6WTg4JYGLhmzxxTcSIAfoa+6/t0O93
	 FlUG+rBCFZkbPGYnygH/gC4y9UsD1WV1KlZ8eU4hia1MYEJXz7Bm7hHQb8XYD0xd9phKX
	 eDsvqBi389q9FVsbUxaKbOH3dMZaI5xGW9HDUV4U/KkuBCFDBzpamB/neiEHG54ixiqwC
	 Su8phmBVwCzUM/0rOquesQgGh+9JYp0r5YDXNJbvaJ+QlivLNMPHxBQKVE/lCNCn3ZV2t
	 gDkjtMZxauiEVpwwkbubUtLcP4CZ5AA2TvAxFnbawEuuuwlY3yJ20mGYZoIo2Gunm0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699724;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=vtVmW11d8SPPr7Vt+7KZw1qUNIs+1JaXCd4F3GABdhw=;
	b=XVO66Luce06KKjbyJZJAaZzOBfidRFcqR3c2cGS3wKRBe5lHxKEdT6dOOukuLXUKQO5u
	 25mKwqnkHQQSNyhwvbOThTjtOI+Kg/mOvxYOOID43uwVkW7fUyMpW2s84uRfsIM3iPdaf
	 Gx/0s2HNfxQG2VuuhuMuh/Pq9Vd8EVG/fMUVdIZXWs2FeOdT5GT9+MFr6gc33f+sq+1Pv
	 lIbl0bHHU1enjJm4w4NA4BLh1DDlN1lighLLZLvNJgoYb2Mg57ELWJWFkMhIjxTmGiNtS
	 w7862Cm3d8p7xEJ+C4e4CXFkRbfUolhffyoBNoFKzFDuNqaU5LMp3jh0iZAzlT1AchQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WG1i3AdH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF9B606A33C;
	Tue,  3 Nov 2026 09:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WG1i3AdH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1311F000C1;
	Tue,  3 Nov 2026 09:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793699723;
	bh=vtVmW11d8SPPr7Vt+7KZw1qUNIs+1JaXCd4F3GABdhw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=WG1i3AdHZT+8Qg2S7I8LZe12ueF0LkCGa8z4U/uDiRxsLufRndeWVwsNN+T64tSVk
	 ANGXBtYP3+C6GeKd25JpbI2GmiHowLQegRGDCXfo4wFmvd6LeKxSSrWp3U2JLsd1JT
	 FbKa+gcS9DpGDf/2jgxKZvXiDz//ezB87MtpDCGVgo0rjXi8dghgEJtWoEq9yPnIVV
	 WLLyzXl9AU5p5TUA/SPqOWw9K5N/v++mrz7IPcH5gYORadEsf8OP5a2Nn1eFRNlHx5
	 4lCaIX+WH+rd7YyRaEqAmQj3luom2onp9ReDdgqJcQBlLcx5P7gT4qrBU+7LTCIjB4
	 UMIhmbWP80lyQ==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Serhat Kumral <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261023192348.11070-1-serhatkumral1@gmail.com>
References: <20261023192348.11070-1-serhatkumral1@gmail.com>
Subject: Re: [PATCH] RDMA/mthca: Fix off-by-one in mthca_map_user_db()
Message-Id: <179369972065.1713861.4162921741075127734.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 04:55:20 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 23 Oct 2026 22:23:48 +0300, Serhat Kumral wrote:
> db_tab->page[] has uarc_size / MTHCA_ICM_PAGE_SIZE elements, so valid
> doorbell indices are in the range [0, uarc_size / 8 - 1]. Allowing
> index == uarc_size / 8 results in an out-of-bounds access at
> db_tab->page[npages]. Use '>=' instead of '>' in the bounds check.

Applied, thanks!

[1/1] RDMA/mthca: Fix off-by-one in mthca_map_user_db()
      https://git.kernel.org/rdma/rdma/c/0246639e79a413

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

