Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794829925;
	b=5QrmBUDAwiq/K6DACWNdo9fzfgucjhVuagaltRiDbTQJx9WXUZsKPB7HROhcE18mgWRx
	 etJbPry9r423HpR0lO1OHCYlXmbWVoWd9mfUnegg2HSl5Izm0olUaOVFiqMIXnYasxYP4
	 oK2DVZ52sBNVxKEKTHxHsJymazG+fY9ntC8mp4A/irbWzthJTfW3EO8mqyQUFvrjYFzEh
	 chWX73VPjEcVWnXH7YhmJmBe8gq3/e6r8DVOaJZzAJqmJp4mNMZQ3a9YssyTIk60izi5R
	 PokczuScclzlj+0hS9UlMDGLT3SW+q9KXkN1NNu3P4zzu5g2W5f3VHbZY55N3Fy0Zqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794829925;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=+ggAgtRCRsNdJ87i6KfaO+cwyhqOwEZfS1zOfOdXtt4=;
	b=l+cPj/4JttAhXNfxJRG3F5V0zArCNtKL5cPsuY12EBDHHpaFAFKlgaTSFwqOtlYWw/5i
	 0JNxOgWwHXxbr3mBFNjH3+Epy3nKB2hj3RC4x42HbJRx/pG5mUEYQxCwaGWaqfa3f5Kks
	 8Wn7OT5wbWu0mITFXBG2mb3sF08/+4me2jTIOJf0W250s/D/hrEq/1QIhnejTdZhNtw9I
	 bUVK6HG2pw8oBKM2UgHazp26rw2od7fO7UHe/hpR9EesTzf/9oTr6X2C7U2onHS4Inb3S
	 0YUsrRPWja/3m0MBk/BYZeRT5hIQjXkxCqSePOXEKhGMC0XJGfkCNEemRMzQRgSKL3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ayrH6I6d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9884606A31C;
	Mon, 16 Nov 2026 11:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ayrH6I6d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88151F000C4;
	Mon, 16 Nov 2026 11:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794829925;
	bh=+ggAgtRCRsNdJ87i6KfaO+cwyhqOwEZfS1zOfOdXtt4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ayrH6I6dtjz2KXLlDFaZorRzpuns3qKD5zLL11VCWkdgnxn3/ZnERbuY5g+cXdjtc
	 kgPrCMLL4X0r0vRjisOedk4LG5JP6M5TNNBkssxRrAg29e7gMkGXitcal/lgrdHHgy
	 IV1n67fmTHLtgqFsoLLzpdJv4kD5eZ72J/kgdeBXS1FmoH6V/+AGMD6CXlDoA+U77E
	 R97NILg5fRUr1YsAdVd1zMSZNSukX7xtqkzTFZBp7WGk9pT0hi8ivAmMyOkZCKS0x3
	 sehpIFRkbSLOOBUR8XoqjzteT0NOkncM8b6OpAVUukbH9cByxqRo5MLqtMzEB2qU6j
	 jDkJMnFHrN5uA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Artemy Kovalyov <artemyko@mellanox.com>, 
 Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Moshe Shemesh <moshe@nvidia.com>, stable@vger.kernel.org, 
 Tony Battersby <tonyb@cybernetics.com>
In-Reply-To: <20261112-moshe-ib-virt-guard-v1-1-6d2caf8bdb1b@nvidia.com>
References: <20261112-moshe-ib-virt-guard-v1-1-6d2caf8bdb1b@nvidia.com>
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Skip vport context query on FW
 without ib_virt support
Message-Id: <179482992212.1351547.14353874397695544189.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 06:52:02 -0500
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


On Thu, 12 Nov 2026 15:27:19 +0200, Edward Srouji wrote:
> Since commit b02289b3d60f ("RDMA: Validate grh_required when handling
> AVs"), mlx5_port_immutable() unconditionally issues
> QUERY_HCA_VPORT_CONTEXT on InfiniBand ports to read grh_required.
> Devices that do not support the InfiniBand virtualization interface
> (ib_virt cleared) are not guaranteed to implement this command. For
> example, Connect-IB with FW 10.10.5020 rejects it and mlx5_ib fails to
> probe:
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Skip vport context query on FW without ib_virt support
      https://git.kernel.org/rdma/rdma/c/e7732ec135b501

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

