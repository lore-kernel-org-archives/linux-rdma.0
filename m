Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312EF3F0A9F
	for <linux-rdma@vger.kernel.org>; Tue,  4 Aug 2026 17:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785864849; cv=none; b=JRW4QeKeSAxP4oV4ceLVtlcNRNVu+2eEicATwprEqzcQRvanx4HZg/TM97Ss/SbRb8KPy9O7+nk+mq+OuGoKevyt2dg4SyO05fNiukuKf5nRSn2IW8hz67eGz6zHGuvBeadhpuepWFYhHxX6v8TOmQlQyzodHUjfWrceJ1eJNyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785864849; c=relaxed/simple;
	bh=iAX2mZPsJFIlY7/TcdBe53KvOmZofj+ZPCzSXkrrIgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m7JuVKt9zBl6IyROv9LREPD2lvSHs8DsB4CTqOobb3QdmWx8XJTJEWZusFnvIA9b+YVnlhIZ7flHW6p4HsExmaIEsYPlHJNsd3h0mk1qKtc04pf05RJtKFpBLosWacCmxZRGFLvtj840VxSw9OA8Ph9SubBMtIZJFgncyxozObU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rTGhvLh8; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rTGhvLh8"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3811f512167so60434a91.3
        for <linux-rdma@vger.kernel.org>; Tue, 04 Aug 2026 10:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785864847; x=1786469647; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mJZVCPW6aaT95lIDoaRsFoVQmof2m7B0Dm3vD+5MmzM=;
        b=rTGhvLh88TLq/VN8G65RTIgtM2zoQldCXrSE+DkV0738yVivDGs4tF7htoXUgucW5o
         UY2D010cRFMVIEzpYMCuZxtHWJ5nbdkoM5Io4a62gkGlq+Ov6+pz1eqquk81YuutFUAC
         hUq4pr+dY0GedaZJQthy78EB/UkShVtuxQn2VrE5ZUAWiaDkJTXcD0EsjnnEySblMTIN
         y70W8SZmwbmemzIOaVVn5ELWr5kau/PFIFVyHJUegg33CMvm2HMMdGZol4q9iHvkUaAg
         YnLeyfOJo+fbumC+IrJxHCTlfQqO15oieAR5mnjgIPIda+VAjqC2KYRFic76YzuCbiG/
         /CLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785864847; x=1786469647;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mJZVCPW6aaT95lIDoaRsFoVQmof2m7B0Dm3vD+5MmzM=;
        b=ki6O76EidlJZK9m91VFpfcyLgMxLJfcSYNitlS4Lz1L3hyrtndbxCxWaT7jx7Tr0cH
         JY+40QsqmUJ0sfauTOL5NeI1B9kF3DHeahzsY6dnHo27sAdADI1/CfYGPcWy2Xa9YDeF
         aPxs5hukyt86YTrco1jIkvbGpCUSimOkefSzpz9y/ypbsNSIJWwgaM4qmr0/ViAf2Ptf
         NNw6wc/8h4hhWhJKyGOIt/E5GiS7y0x+U9+aLG1SDNWTOJG0tFb2Tbs+GU6rj/QYm684
         cr9L6uaAF52YFcfen8ayteWRZyvfXFbbxfEnPJXxBJaWpDqlkPmjxeIubLqmClbyAfpy
         6FfQ==
X-Forwarded-Encrypted: i=1; AHgh+RquXjjIDM5+zBOIVSRZNDl6QDed42NGGPWoxMNEEo4tIQQQ1m2SDNETerWZRmh0w6HzDVcRkCChkka5@vger.kernel.org
X-Gm-Message-State: AOJu0YwR24rzTUjmEMZvB8aVxDC3gmA41UekSrYvfB3y+g1e1yHR1G1D
	k7EG68t9m0LP8o1r2Oa272mrIslzo8oWb0U6FdnzncXIFEIxAB1H3fsr
X-Gm-Gg: AR+sD11nhVQ2U6Dgzg2pU4aen6Zj/KsmcYERt3Pi0Vh8k/dzseTKMmDl9Mf2XeM1D0m
	sWnJDOY5jXLz7kmruj4He/v6wT9zuQ3PY6R3WQ1vrSWPj4W758EA/mQA7OjR5TOYuylZo094nrY
	s916aFEDtlCC3zJM9X/C4OxZIiCbqfQqsbd/LAiLoP8bbbecY8qujx6gg+taVLJvXm1Bx7wyLbK
	DtyvJGBQ8XU0BYWYqWB8TmOQY1WKb7JjYafBcsRWufKcrug5gaUVpQ7naimvGti0ccEeuBM95rw
	HKvUDnDerT/RFKsQaBFsPqXz60ByrkBMTY+rYwqShTwrfpRgSNzQq0kge2nERY0EHaiNfbpFSYA
	MVB3EULe5IlZTM7x01iFSTGesqiG+/M/QML1x/X3b61eiaJp7PmKZ0N7kVeQnLu1amGUP/i2wsH
	O6lueakm/Hca6fdzW1oVSZ1QgPVh1F/Jp1dBfoQFac7QT3DtaMZo/WmGlAqUllVNoR6rKPzQ0ao
	yvuj4Z436uYHHualuoxfELtrOTEbxBo0JsR/4/2qBY=
X-Received: by 2002:a17:90b:2f03:b0:382:1aaf:4bab with SMTP id 98e67ed59e1d1-3903c6cc30fmr526351a91.27.1785864847541;
        Tue, 04 Aug 2026 10:34:07 -0700 (PDT)
Received: from ?IPV6:2600:4040:9399:4000:e553:72e5:7d37:c7ef? ([2600:4040:9399:4000:e553:72e5:7d37:c7ef])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3903927c711sm255036a91.11.2026.08.04.10.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 10:34:06 -0700 (PDT)
Message-ID: <0b3278c9-550e-4b72-8469-00c86180c2ea@gmail.com>
Date: Tue, 4 Aug 2026 13:34:03 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 08/13] net/mlx5e: psp: Handle HW-decapsulated
 RX PSP packets
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>
Cc: Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Alexei Lazar <alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Doruk Tan Ozturk <doruk@0sec.ai>,
 Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu <jianbol@nvidia.com>,
 Kees Cook <kees@kernel.org>, Lama Kayal <lkayal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>,
 Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
 <20260804083535.2946459-9-tariqt@nvidia.com>
Content-Language: en-US
From: Daniel Zahka <daniel.zahka@gmail.com>
In-Reply-To: <20260804083535.2946459-9-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/4/26 4:35 AM, Tariq Toukan wrote:
>   #define MLX5E_ACCEL_FLOW_TAG_PROTO_MASK		GENMASK(23, 21)
> @@ -25,6 +27,10 @@
>   #define MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC	(1 << 21)
>   #define MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC	(2 << 21)
>   #define MLX5E_ACCEL_FLOW_TAG_PROTO_PSP		(3 << 21)
> +#define MLX5E_ACCEL_FLOW_TAG_PROTO_PSP_DECAP	(4 << 21)
> +
> +#define MLX5E_ACCEL_FLOW_TAG_PSP_VER_SHIFT	17
> +#define MLX5E_ACCEL_FLOW_TAG_PSP_VER_MASK	(0xF << MLX5E_ACCEL_FLOW_TAG_PSP_VER_SHIFT)

[...]

> +static inline u8 mlx5e_psp_get_version(struct mlx5_cqe64 *cqe)
> +{
> +	return (mlx5e_accel_flow_tag(cqe) & MLX5E_ACCEL_FLOW_TAG_PSP_VER_MASK) >>
> +		MLX5E_ACCEL_FLOW_TAG_PSP_VER_SHIFT;
> +}
maybe GENMASK()/FIELD_GET() would help deal with this bitfield?
