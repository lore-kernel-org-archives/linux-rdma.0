Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780461;
	b=mWPvIt67bmMLMcS/XSfJcEXLuhBjJWisQ7k2UlIoTkSneXgaM2v0Gs1b8qQdjxjyJthh
	 2UbcKJEXJ01M7Cd1KxR+dnxsB7C3oRYlnqmIQR5Wc/caR4V5ZPn4iYr9RYQRkW5NGZVrJ
	 MJfU38l8YJRal1BuYo7BHbuo5djvVP5jwyHvFqgFxpq4wCEoIWZr2+DQDbYyAyL1YjD9l
	 oLSO5d12GE5rdo++eVNiXo/jKqCztt9bSKlrqPOe3EfgRCE6r4mVqEo1UsUZoslbhTcAp
	 WDiIqNHP8Mv5Y6T4QSWY42CymXDemGBVLKOwS/BwmTjgVwRkKTrQ6U/IHVgrP0gOGgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780461;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=NPgplNj9APhcuna/gT9kuV7uUH+wy+QbbxgJJDCKr4Q=;
	b=0dLeeT/36rESUP9E/TxZUNgYEQR887lF0RjU7r+357K645+rX3RDlqsIJttw4/un7EUR
	 CR3zD7n3TdjUb1UhFGUihcddAzpi7i8s1wWv4S8OegYLoglZ3gCewTUks81UYquLwe1pl
	 t2LuJaIsP676ttVyn3eON02ezE3NNrNVbXN2wRJagLEs2gLMhlfsJGQBiNS60z4z98n62
	 9qZpDxakQSgmOuEzmIc2yO9rvY06WbyRvwYbniTAFUHRP4QX+ZyTyzSOfS5fwKckSOlTc
	 sLy5rfyl3r3wW3rYOE0csRRGfX9pakoE7waI1d2TnPhnvmKY7UZEJfqjuSn5TbN3IBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D9Ulw5Xf;
	arc=none smtp.remote-ip=74.125.224.41
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA359606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 11:54:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA359606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D9Ulw5Xf
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-67db6d4054eso8544038d50.1
        for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 03:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780460; x=1796385260; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NPgplNj9APhcuna/gT9kuV7uUH+wy+QbbxgJJDCKr4Q=;
        b=D9Ulw5Xf/Akan+JoLGp7KULBPG4cEl0Qlr0l8NqNb0IIBAGnM8C3dOTvxifDntne9d
         +ItaobNdFuV7xZZSZdK02FHB6hV/oCpGnt8X5iEZoAN+KxK47nUxrFGqGPj9wEATzltR
         B1Rpn2p6yOdZF80QgC/bKXQIM23vh7IybD7e2aIZP6wTj8oMit1ln6kNIN5yHGzI4uE5
         tq6tZSbx8AoVQhTKkjf0uTR/Bcu6G89lH2vLrsyB7ZsGbVxLNvBKxeDajO+DFdosnlC4
         6kJa388eHluLWJYA2qUZMlnOH8FznOB4rLjhEpJTRJio1rLsG3d6dYXx0Kf1aPo9q7qt
         DJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780460; x=1796385260;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NPgplNj9APhcuna/gT9kuV7uUH+wy+QbbxgJJDCKr4Q=;
        b=oz8BJUaGCrc7pwuKS36NZJgmX501LT6hw+exaQhitkzpOmkL3wrKWUgU8eImKd1yJJ
         8sL0z8GTfgX3hZDeskzNGU75gfITml4GV6NTkcQmdBZ5ApGgSmRAVV4rmJreOyFlgjWg
         BnelQbgdzIgmzJmaXH+8Oxv/cgAQ60GMEjhnFRsV7WP5sHnocQdGtmOIPMJn0UjAtCtU
         plZN0amWANGANMuBe6aAOdeDDWIRVJJ6EK8wwg9ohq3eqw3VI5gpk8iw2vxWU41ZGs6D
         lC3x06qq2reNTGATSDOq0Z+0DKISiAYcWdDGMZ3nzew++MininRv+nxM0L4KRI90LcHu
         xlgw==
X-Forwarded-Encrypted: i=1; AL+hErG0e2ceEv8I9L9dGnGLCuR+kG6jdH0UnalFaXx9pEWpjYQ1jNg8gJ/Qm6yxjIlXbBbVCREOEfFqinFq@vger.kernel.org
X-Gm-Message-State: APuU4Z9dqwyWDs2qfIWQ5DFayXbdqGxWl5srV3Altc8ITwhe2j02oPoR
	v5Ml9HKnv3wtcpcG2YP2Ma83QiCJYVy76WINuhRc9rwHwYmyB04+dKZU
X-Gm-Gg: AZFdTZfcTj3nu5+4EYuwMgYiUJ5fzADIqvfO8TDAcNqYhVo4Dvst8xP2WXjgFIlS20L
	L140LeeJO2r/dCu5e9vVveRmGoBUYtnfVChsCwYyXB3eTvJNIFcJcWf8N1DvUT2BNyTiHxxv/rV
	kKiI18511xRYgJJpszyZz+JOMvNgEhFdPpsP6BACNcXQT4SBgdus84DULABQNAPTaCBbs4hoBPn
	X6Clz2MEL37rnEU4WdrPj0wqlm1rHC+ZCGPadV/1MEnW2FW49av6GDWWTDcQ5BTaklLf1dygFAl
	6m6bj7wOs3t0SXvBt1mavhXdIu8/b4hcWpgEnl9ZX8ZwWhAiwBjSk0dGtcVaMsdhecXtKyQZeTB
	JPi95bcOqtdRD9J/qjKxMhcjeR+5d1mu+Ua2NkPNnCTiNa0XQVliKDzJF2SmSQQDriU5pBrncfb
	7/XpvqAFxFeB5HU43XUsaCXvF+IJkgZERclceYwyw9H5njHcZ4ZwyPMe5rWiYpBfm+bVvkfbJQi
	JMtRfbxU9RfRDEKzHmntazwDejWDJARttWfy2l7UjsU83G1pvTljhrsuuJAwtHkCFp3yPjmzIoU
	qW2XuCy7KzA2Trw22ogPM3UKc6tPxW90g/HitG0VTObQ6gfJVmFSsm0=
X-Received: by 2002:a05:690e:13ca:b0:67d:e97e:3283 with SMTP id 956f58d0204a3-67df43ce140mr10731749d50.24.1795780459895;
        Fri, 27 Nov 2026 03:54:19 -0800 (PST)
Received: from localhost ([2600:1700:4a51:221f:cd57:192:f9db:90dc])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67df335b3aesm11118579d50.12.2026.11.27.03.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 03:54:19 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 27 Nov 2026 06:54:18 -0500
Message-Id: <DN5Z1LNNUIXI.33NZ6QHK9ZS99@gmail.com>
Cc: "Aleksandr Loktionov" <aleksandr.loktionov@intel.com>, "Boris Pismenny"
 <borisp@nvidia.com>, "Cosmin Ratiu" <cratiu@nvidia.com>, "Daniel Zahka"
 <daniel.zahka@gmail.com>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, "Leon Romanovsky" <leon@kernel.org>,
 <linux-rdma@vger.kernel.org>, "Mark Bloch" <mbloch@nvidia.com>, "Raed
 Salem" <raeds@nvidia.com>, "Rahul Rameshbabu" <rrameshbabu@nvidia.com>,
 "Saeed Mahameed" <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: psp: Fix stack info leak in PSP device
 stats
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Tariq Toukan" <tariqt@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>,
 <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Willem de
 Bruijn" <willemb@google.com>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20261126211115.767481-1-tariqt@nvidia.com>
In-Reply-To: <20261126211115.767481-1-tariqt@nvidia.com>

On Thu Nov 26, 2026 at 4:11 PM EST, Tariq Toukan wrote:
> mlx5e_psp_get_stats() reads the PSP flow counters into an uninitialized
> on-stack struct. mlx5e_accel_psp_fs_get_stats_fill() ignores the
> mlx5_fc_query() return value, and a failed query, e.g. -ENOLINK when the
> device is in internal error state, leaves the counter fields unset. The
> uninitialized stack values are then reported to user space through the
> PSP get-stats netlink command.
>
> Zero-initialize the struct, so the counters of a failed query read 0.
>
> Fixes: b1346219e535 ("net/mlx5e: Add PSP stats support for Rx/Tx flows")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
> index 73b232379263..4aacb4173b1b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
> @@ -995,7 +995,7 @@ static void
>  mlx5e_psp_get_stats(struct psp_dev *psd, struct psp_dev_stats *stats)
>  {
>  	struct mlx5e_priv *priv =3D netdev_priv(psd->main_netdev);
> -	struct mlx5e_psp_stats nstats;
> +	struct mlx5e_psp_stats nstats =3D {};
> =20
>  	mlx5e_accel_psp_fs_get_stats_fill(priv, &nstats);
>  	stats->rx_packets =3D nstats.psp_rx_pkts;
>
> base-commit: e1055cbfd6eb578417f3ce983cf44462e8465267

Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
