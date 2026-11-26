Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719367;
	b=OdhCXHmh/BsaLQ6x8PetYKFK35ke/MTr/UqqfBqlgKN4V29Lu9KyTDTy8/843Km9SX2B
	 KVL2s3Ut99PkfUDK4hLe1snImuqXLDQqcKc2zvBUGNmKzlIPGFJJcnL4UD6DIgD56pR0V
	 PBGvd9eUYhXUGljTaTEUdbifKZ/4//4lNVuuWYJ9f0kb7BJKlwztYM4NmgBwBKsPwJ8yH
	 Noy6wJXyDN9cz9tk7YC34Tv2XpZDetHVkVDO+EfQIADgmCDGfceU+jIvVHxcreT0WTqXQ
	 aeLX9V0aICcUx+NrJLlSTCZufKA8+BRbksROTGuM0qRf3wBqq7CC2RGKDoKLnD3dTgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719367;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=wBp5u2scpdGHC60sEduFSAyUYXBqcu5azPm43TsnqBY=;
	b=uU5vfLczwohGofin28ezZIqklX44KaJTvgU6/Pf+QjCWX2S2122fnACy3jCCDVpUjzz7
	 1GJPYLxR+jfU6l3yqAUoK42soHO+yn5LVhXVYr4NOmDIWPa46X3hU1gF+1gqwjKmRsUIp
	 Aixd1JPbYSjhf3UdiMVRFwfLlKlrYkwCdBDm/V65e+y20nvqLRhkaz+q6fI5qZyIQX9Y1
	 K58VxkQv1FlT0WxQnXqgCGcHhpdUz9eJ3xgQ5VqppM0sh/3VJZ7YsNPLqnWbA2h/YkFVx
	 mQeZsrtDwKlk5z4N6tR3ULRz34UvF9pNMwS8VFKoRv4TYQo+CqCbGdoo1e+HKJm0qGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUYcSNWc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8567606A31C;
	Thu, 26 Nov 2026 18:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUYcSNWc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2FA1F000C4;
	Thu, 26 Nov 2026 18:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719367;
	bh=wBp5u2scpdGHC60sEduFSAyUYXBqcu5azPm43TsnqBY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GUYcSNWcd2YorBAMYm1LEAvuw3XBGUglE5Uf0voF9O4Lpxtbm/aQXTWYYyL3eVHd1
	 eyjmrCESykAJYbfrey9PbX54IhYHbM8gwv0I2CfDLYy4zDYlSwAMW7yMeSZcqveu1Q
	 k1A2GsvX/o+jYVtTNWg5RUjZXZv5+GJwMnoX5EYlSYv4Xb7cEu432cucj5xUGv9ou8
	 1iq7wjhGEsDCi6FcChvkOPz1H5dHZR2Ly3hw8582r+XlDBs1EuV+xWjiajUHubQVc2
	 F5yIZ+JBHMinxHltcEA7RCLvzxKoFA9Xf/kYAtBIh87P45TCivipcoghdwrvVvxlJY
	 ZtXFb3WxiTZBQ==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
 netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, Cosmin Ratiu <cratiu@nvidia.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Dragos Tatulea <dtatulea@nvidia.com>, Eric Dumazet <edumazet@kernel.org>, 
 Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, 
 open list <linux-kernel@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261126061904.387686-1-tariqt@nvidia.com>
References: <20261126061904.387686-1-tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Add PSP header extension length
 match field
Message-Id: <179571936446.1294921.8021340936366731442.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 13:56:04 -0500
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


On Thu, 26 Nov 2026 08:19:04 +0200, Tariq Toukan wrote:
> Expose the PSP header extension length (hdr_ext_len), so steering rules
> can match PSP packets with extension headers (such as the virt cookie).

Applied, thanks!

[1/1] net/mlx5: Add PSP header extension length match field
      https://git.kernel.org/rdma/rdma/c/8c7a99ad6d6a9e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

