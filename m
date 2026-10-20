Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533481;
	b=GPdcFa9pRUr3a+by/mqh8bQk/dHlUqQSDZiqzXnosI6BH6Nxi8nj1aF31cWoORazr17N
	 eMI51RgguqrbinmlglhDjv3dIcC/wVB6ByFIji5FVNfVoorEa8FzG5PW4jQgbhx/Tuk7M
	 txO/zYM7YBO0pzCu91TLE5Y4xZovLddDecFCftX9OekOdXbaZjrhXD1KVcp7yQfOVxS9T
	 +hSnByECV8uHj+eQ+n+BnLLt7Ju17L+Afuri7woWuuxLZyEVUOrahnHJotaHf/6OgWVD1
	 wWHG312QselR807gE6R5eQloJIfrrr/IhgOKkbpnLcwFRqVQb8iMNFVwqwWBAi9YNIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533481;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=hYnXTzJewxVnTsYQsR0lTJu5zv/qnETwI2MNTZueBaE=;
	b=FNDtTxdVEVoXftzVmEPtuiHavRYBbisT1QCUvU8MVdRsq432TRHNLCvUm610C8Qc6gIS
	 feuzSiUbXYG90F3ZJCKhzKUk83+a+fZHW9thYnTAYN7rjPmr0p790f0p80nrrNbNRKy01
	 XQxN5J46iv2FuDboo+s2GMR0qVtsNBj1J6tB0Nl363ReskwteLSDVsv35Ok/oF2QkmQ0Y
	 ZqXPTH2nb6037Q6sYToH+2UJ47jC5mJVI1Rc+PMa4WPeF5/vIVWUuIWxMVvz2KjmCXC6O
	 gV1pwA6NBE8VtSee8en10eZ2q0Bi758jp2PgLOh3mutP//D91arvWOjjSmKQEgvUWEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=J+M8k3LW;
	arc=none smtp.remote-ip=74.125.229.8
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AE0606A31B
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 21:57:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19AE0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=J+M8k3LW
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-33baa8eb238so13194eec.0
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 14:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792533479; x=1793138279; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hYnXTzJewxVnTsYQsR0lTJu5zv/qnETwI2MNTZueBaE=;
        b=J+M8k3LW1y1p2rAPNOoanZEOm8pIOU1+hFBlot9nZuGIe4j/NEAa3FoXR4K0fIC/Ww
         nMySMKfpE2Akc8lwd9+qGjYpg65pMLQArQFxr4tam3HsNsKTXdlfbPjO2xBVcl2cHAk5
         5zHbTyv+gliwodCFR7WwgWQY720cCKozaMjhp6H0kmml3W2bYWCO0bmj2aC2HDVJlTv4
         qR0UCKjB/bpPAJupIljMfGC8oih7hHdEW9uM09884Y/2Qa0kNX/x6LnMQp+92vf8im2B
         qGwF2UGwdNw88cc+T6dT47t7P8G/p9wcCyLXIZf8fox/xEFre6sXoE5mS4Iui8gmh8xT
         z51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533479; x=1793138279;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hYnXTzJewxVnTsYQsR0lTJu5zv/qnETwI2MNTZueBaE=;
        b=iChnQSPWLkb5ZfjuI+7yzFuN9IocPWjR+Fq7HQGa4aWgL/Cm5WTHVOUSwBDY+uNng+
         zikVIG/JfBFITRlXgej7Ha+MifDw7cXa5HDyk4P8yz2okZQiyAlWydP+Bpe5ibvLprtC
         0nyLhINKw2SMZXV9HzC5SrM4yfkSXAHhVgHJJ+vTX/uNcEMwPrrkT5mMyTs3pZLwq7qI
         J+hTJGVD7Y2T9n2xg33dJX45L345CH/R5+gzNd4Ww0Q1+KxkOaCsuRO9tH63BOR1VjnV
         usLiDXd0qDu7d7FMsipsQAUcMM3jaiWUM7JvWySIk0UtTOK3SAtFZ3jrCAI91WZQsgu2
         6ciQ==
X-Forwarded-Encrypted: i=1; AKwUvBwfgbAhNFX7DkVd4XqHtJVyn+Ab8DPGZ20TqJby77eV+R1sYgAhgSGOmUVDeo3phXtuh5+VhGYQZ3bB@vger.kernel.org
X-Gm-Message-State: AFq9FYIaZRHxvJXHh4xcEc/nh187LUVvW79D0zVkRy7Fop0kHFcVd43N
	tgOWAGvtlWeDJ8nmFcIt9HSQNQDclCYzyVgKkXxLxx+oFotL7WnR2kV6
X-Gm-Gg: AYBFou26ktMz1FjJ6IbMqpeTBiLfIkUS0Cbe/mLCLLedcaiUf3WUmLJRqVsKWB3jIVF
	n1JRrAN0l+VYoBJusJdG5/IE1fugYCwhi0JXI0SwZ4jyKKujmV48+KmgV7pPUQl+8yZ7stSxQ/1
	GMryBLLxKfXykgDgmlT4E5K1mJ8+PvSECYgz5kgAyvhStmoDVV6iA4BV6ZNOis3iEDF6YW+NV7I
	oVpgabe9mWXnf7QfHxatSMgs5Cit5dh6OfV9v1d6Ul+fuXCEc2g12trlVl2d+wFky2lgHFtbF2O
	sKfINQiUr3hAEbcWVDHultpYd6Jdj4kkEKZRd22qtzHvTSVaaSEx1zy4gBahx3d2381ZFD40m/O
	gx5i0QcH4agNEpW9Y0+/JUA+d3+cJLDwIIPlFTBiE+0GTqFlEP9s8KWK0JJKkzPgIB2IfJhktq4
	ypAKtfsLI8wqrL5mXsM0JD71a1Mcg5SscEV0uvUSQprsMlYnZQaDIo5kp/OG5KXz2jLXNtXeSYY
	m9YiQLwOMAbWMvpSy0mSGbGbCSt3RwfftPVNZ450O/CtbixBw==
X-Received: by 2002:a05:7022:7e84:b0:143:4450:e1e6 with SMTP id a92af1059eb24-190a7660d75mr193063c88.35.1792533478955;
        Tue, 20 Oct 2026 14:57:58 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:70::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903bb7f098sm1857639c88.12.2026.10.20.14.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 14:57:58 -0700 (PDT)
Date: Tue, 20 Oct 2026 14:57:33 -0700
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
	Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Stop asserting for RTNL when closing
 channels
Message-ID: <atfjx6iJJiqAq3Io@devvm16445.scu0.facebook.com>
References: <20261020153659.3440902-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261020153659.3440902-1-tariqt@nvidia.com>

On 10/20, Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> mlx5e_close_channels() has an ASSERT_RTNL() from the time when RTNL was
> required for closing channels.
> But the driver has been switched to using the netdev lock a while back,
> and this fired from a flow which was forgotten during the conversion:
> 
> mlx5e_tx_timeout_work()
>   -> mlx5e_reporter_tx_timeout()
>   -> mlx5e_health_report()
>   -> mlx5e_tx_reporter_timeout_recover()
>   -> mlx5e_safe_reopen_channels()
>   -> mlx5e_safe_switch_params()
>   -> mlx5e_close_channels()
> 
> The RTNL is not acquired here, but the netdev lock is, and it is enough.
> 
> Rather than switching to netdev_assert_locked(), simply drop the assert.
> Upper layers (networking core, ethtool core) provide locking and lower
> layers (NAPI helpers) assert that the netdev lock is held.
> 
> Fixes: 8f7b00307bf1 ("net/mlx5e: Convert mlx5 netdevs to instance locking")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Stanislav Fomichev <sdf@fomichev.me>
