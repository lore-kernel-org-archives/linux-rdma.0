Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793845283;
	b=XHtqL077I2+OjJpUCm1AUlr5MaMsa/4XzZjCMADeOrPL9TFNdeLeh2U1kX8bZOx/TYzF
	 5tNq+SbH/FXKGIEwvlmvScxnwIy2C0EYB+v2J7VuvHnARurm5LF1SvmZOMQMe0s5mNsa7
	 ljl5Y1sHYPHj+3cW4LYox+Jhu5W2f8pmKu33li1fVmk1/KFEl7HsUEGFR516fjMyOQLNP
	 C5NoClBIgcXUydR+vIjCi46BypWKlhP0N5wLEx/Ifvg2xxG1RGm9H+pG1R8UbbJTj5776
	 nQrjE4/hw2urhoS15xr9dUySxWD2GiZ5jf34yhhCgs55eiVNjZMyMo9MxrqaSAwpnpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793845283;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=CPWvCpHCYoWPM5p3/a4KEe4RRG4SBGN/TGqMoA1qGPw=;
	b=AyqJqThm6VlLChKF7kYxwFyjDzE6db44IQdSXXmI8eY5EFeWEqkxh/icEXWyT2v/c4QS
	 Wg6t8BIixbAB9Z+bK7bGMdFQ6yg0BuxXnMMObhaZZwMau+flkfUPjT5EqwWye2iQqbdGv
	 K6PCKgglV2//eykQBaDgzUKtCNl74I562Xsq98qLYFRfHk1iS0Yh+kkoVgSGCjYbnIpEa
	 5U2NMrmgjxW1NixCEFQ1aQ7bDjz7THV7Baxn0L5IOC7h/WSsEAxp7CXoC9k6MzKM+Fq7t
	 c9eBazNjpoK96WazZQioiQapXK2vvB+IcNZ+ifumvUesYKiJis+8Q6jKz+EJfDqUMAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=upYHlsIT;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8BA606A32D
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 02:21:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF8BA606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=upYHlsIT
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3550c917fd3so2062562eec.0
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 18:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793845282; x=1794450082; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CPWvCpHCYoWPM5p3/a4KEe4RRG4SBGN/TGqMoA1qGPw=;
        b=upYHlsITZy9Egx9YYgwt7G5l8ujPMJ2sprITqpQJ8YYIF0KpweIe0Y2XL8zE9ilu1i
         xs6ZGv/606sHvwgPSm0UCFDE6d2pAwyyxqzFkBRIITXNTMfbgZlbro5Kacp0ggGLCnDS
         77GIfh8EkEwq6VzYFJleOyqMPviwuHP8aHndDfCs2NtRl6xWHqJst+FFAZJR+bTFkUt4
         MNWK5iYz6b7T/q7rwNg0zLbbh8xRucO3mrtYT7bJv40h1kyRmQ3R8H3qg3s7Wxjeik3w
         4nvrJHb1DQdzPLxeqCDKUNIr6B2PETw3tQZku/Tzw1AuqnKQpvSPVkUHb8zIZWNaZX7o
         Pe8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793845282; x=1794450082;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CPWvCpHCYoWPM5p3/a4KEe4RRG4SBGN/TGqMoA1qGPw=;
        b=Ev5H4+bprhdqYYFKnUBCskvLIl7RbLzHjD6p9MtZ5NIPm+abhs0lgaqm6FMCV68gWI
         IEvP8mA1V+D/VJwkDI9bfs6bF01gxK5mrmRpN4UpjkZIZsNZZlYce70tEfHUg159wXJ2
         kU8E76XKELuRe90MhTAEDtMmEAWMrdofN6HwdKH2434MUjkw4FsqAl37Q+HPI92xYEdU
         UDMpIcbmcwY9HnPjVcgyKX/DOttHrA750Do4+u2/08APGGJ5Fkd34yFk3gvdOTgDeQ6e
         GjzpRPlILGROmpFc1fgBH9uASE28dbA7oWfMt8UmFgAQ1V3PPXQCCPSXBFfAN/WD7psa
         b0cA==
X-Forwarded-Encrypted: i=1; AKwUvBy0TWdkTcYgDcWXJnyHomUVne+iNWHV+u1J1PeBnUnwQ1utLyVN7quEQjHRgtlHft/SuPFfH0T1aJl4@vger.kernel.org
X-Gm-Message-State: APuU4Z/JfMxO1FLXrEe8r+5XUYOg8oNVr+Inm5aJdRDTwFd2Bmlcl1u3
	rI5Fj+GBdXwLz22pXimnMycimaXMH6ukw9ayDQJZ180wdrylq5487a0h
X-Gm-Gg: AYBFou1tcmr1yws0eXB4QroIrIgzjfTGR4uhWyPiLDh+kew2GvLpnu+aA6RP+DNb1Ni
	r9misc4+WfG4sJ+k5JLJKtm0owOswOlDDtpnZzUxFDEPyStYxrkJICnDwwWKZEgoa9hAq5uKenG
	faC3EDgb4ky/tpTj7n1bKXEwBE+Y7gbkiE4UPDzRU1jCQLKv+tkWe6uvVlj8aePFBKsixvKUgZF
	PlANPRlTLLHIp1RShk/GgBhbt/6yBiIKigPSvdZO7JdH4ovzh+e0umSrGECNwjKi6xnapdzU4u4
	dJuDolhJkwElN3VxrUnr9uIVbP8ZtZXMBL61uoNS3oDDpuc1+fuLjwy7uJY0XTM4XTpjTkoM6wh
	x1JKGZhwYJizrGKs2vHGVXK4ZS/+06YPOU4T5AxjHvdKlcBV/NkHjlBMOydNO+hgtuwdecKa3TF
	LRErKTQhxo5g5RsA3PswOhJcUEF6OavqcsLyb1CgYXVowVW20NP/iVjg9LvbE18nDhZm+lnTLx7
	ZilWme2zr7NAczeKXgusr5C59ewxENVH0PFnsitIBbEAPvFAuh+CyjOtrjlQ+BUQ9+34wz2LYeV
	xBd0EIlz9VYA+6xObuD55kJLD5AM
X-Received: by 2002:a05:701b:4186:10b0:137:5b9d:cf87 with SMTP id a92af1059eb24-1ac4f91ee96mr27294468c88.0.1793845281828;
        Wed, 04 Nov 2026 18:21:21 -0800 (PST)
Received: from gmail.com ([2a03:2880:9ff:71::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c272sm11719698c88.8.2026.11.04.18.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 18:21:21 -0800 (PST)
Date: Wed, 4 Nov 2026 18:20:49 -0800
From: Narcisa Vasile <narcisav.kernel@gmail.com>
To: Peter Morrow <pdmorrow@gmail.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Simon Horman <horms@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx4: drop the unused is_supported callback
Message-ID: <auvoAYT/rwFrzoSH@gmail.com>
References: <20261103122109.1798144-1-pdmorrow@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103122109.1798144-1-pdmorrow@gmail.com>

On Tue, Nov 03, 2026 at 12:21:08PM +0000, Peter Morrow wrote:
> Since commit 557d80138618 ("net/mlx4: always create the eth and ib
> auxiliary devices"), both is_supported callbacks return true, so the
> checks in add_drivers() and delete_drivers() no longer decide
> anything. Drop the callbacks and keep the aux device table as an array
> of suffixes.
> 
> Tested with this change applied to 6.12.113 on an Azure VM with two
> ConnectX-3 VFs: both auxiliary devices are created at boot, and
> removing mlx4_ib, mlx4_en and mlx4_core deletes them cleanly.
> 
> Suggested-by: Simon Horman <horms@kernel.org>
> Signed-off-by: Peter Morrow <pdmorrow@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/intf.c | 44 ++++-------------------
>  1 file changed, 6 insertions(+), 38 deletions(-)
> 

Reviewed-by: Narcisa Vasile <narcisav.kernel@gmail.com>
