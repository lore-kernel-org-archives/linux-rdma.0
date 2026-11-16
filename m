Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794834887;
	b=2aUXQgz6Z5MTtMoF28SOoYIhzLhHSR940Loy1lnFuhODv3aCBQXi1A/fU86dm0vPO9pA
	 YY4OnFz+vQyfJ4HIdseaEGRPWp+ebReE0IlVYU4gSvvIywUxjobw937ss0WcYdqtNJtqn
	 Sa/Uo7wPczDUReqBQzSIAWz/I0CMA1mjTt6MEhSJH1oVa+3Jk44u1Me349sQajocr4jhp
	 wTcz6BZn9XYSMXSgw8aPPvgPko1Dnpn+Ph+03Gtebi1LYsVgn22cCKiyLsjdHG75PltqH
	 cAdv288vQoJQrdPWLhcjNvGm7Pg5ksghd2pBbo9HEwr9dlCfF9e4j40SeeRNjAh+ZJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794834887;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=3hirdn1ro0djCVlQQKXkvf5JdzfsLtqB3OGNT1PcbsM=;
	b=Uyz3CqR6kpHPsFbsmnXSNhthSzDOrYOrwv/D38jkUqMn0trte5cBsxBYxAgxFxmnszXl
	 9nXHKp1ESgAV7JS6kNJiRS047r1ugciuh1AI/1dMedxvcWhjOIVdoCCOLraoi00oSFKDK
	 diRlkjY6PXxDABn6ddh9A7O3fyCqkwp5OslAZPwHdiMnenA9Lub9dZlN5ANTh//6fP31M
	 e63d2s70GBpJniCy44cx0XBEp/he5XtkfRrNGFw+nzXe4MReJVuJgTG1Nzlpm8W2FEXXS
	 F+Yc7OZNJNnVHJ82AXjWKhIaUk9keBhMU1Sp/FpTapyYOaAZDV/zWrPNdLrJkTUZUTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LDxTYuKI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA36606A31C;
	Mon, 16 Nov 2026 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LDxTYuKI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3621F000C4;
	Mon, 16 Nov 2026 13:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794834887;
	bh=3hirdn1ro0djCVlQQKXkvf5JdzfsLtqB3OGNT1PcbsM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LDxTYuKIAdZ7MbnpCOdCv5k8aVqa1Z8DqAVuHldzPx95hY4mBut5Aynr1A3sc7XRb
	 LzM0j7n0N/lhox/PNP+GyCjiL06svJe7CPRhzTYAqsfivuy8AC9w+Mr0y7sd4nD51M
	 sPFpjtnro7blkgNPgtulRvSIzRLByxRWYwa//jmxqcv9p8+1BAjPfmXgqJ3V6DA+PU
	 l68mmt6JmZ/Nwd6uYWdYDyG/qQoMrbHhCZ1PR9AyAoEwi27nPaJIYS0wCIl6fe2pnN
	 RofDqqLBVspBM/w5MsmHzciHLdEwkk8WODba/TUBpUiUZceQenTkhSkS+dPk+mmyK2
	 KFSYzh+DKT3Gw==
From: Leon Romanovsky <leon@kernel.org>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: jgg@ziepe.ca, raeds@nvidia.com, yishaih@nvidia.com, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261115085025.53203-1-dennylin0707@gmail.com>
References: <20261115085025.53203-1-dennylin0707@gmail.com>
Subject: Re: [PATCH] RDMA/mlx5: Fix cntrs_max_index overflow when binding
 flow counters
Message-Id: <179483488424.1365560.10721404495022974325.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 08:14:44 -0500
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


On Sun, 15 Nov 2026 08:50:25 +0000, Hungyu Lin wrote:
> counters_set_description() stores the highest counter index supplied by
> the user plus one in cntrs_max_index. Both are u32, so an index of
> U32_MAX wraps cntrs_max_index to zero, and the entries after it can only
> raise it to their own index plus one.
> 
> mlx5_ib_read_counters() uses cntrs_max_index to check that every bound
> index fits in the output buffer before it runs
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Fix cntrs_max_index overflow when binding flow counters
      https://git.kernel.org/rdma/rdma/c/4583abff319acf

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

