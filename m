Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D135275A4
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790187975; cv=none; b=IRBzvxXFGj4P1IHOtg1k/v2JTg2SwOdolQd4i8G7lfnNwTHb5DRAvwfUZEpLUC/8a+q+JzV1GtOmcV3+PWS5rCgQLHT/v8IJLI5cSjB2JjAzR186QLi76UXl7Mi8EXUGbth44gZhmoKNCS9exk+wAy84PBW+JWFbJbLk/G+H4hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790187975; c=relaxed/simple;
	bh=LhiPso6phLQM0wA+k6tjmIhIVqDrjbY4C0VTVIyFW7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cSYiP3oJWYdz5GHXty8RUyhFcBY07KqNWzOAyLiFnSg3OUIWmNNMiu7bY+Voodsxf2ICbjpxtkKllSjs1FzVEv0iwf9ja/jtCZiBhI6hPyOzJJTrEQzENuilVyUhLyC5mZQnjI8M0J+1VL/CmNoxA/I6F0aaGdFV2BdH6tLAOok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cb3d6YzW; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cb3d6YzW"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747f0135fso8717945ad.0
        for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 11:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790187972; x=1790792772; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LNon7FG4gNvQZ8cTIn7dGZggjcYoEo+V3D2k9W/8Sxo=;
        b=cb3d6YzW6nrGuRRS6oSU6xIv3mfNSvAfD4J+NhlQOOwGhtfYHTTWnAIK8qaVqc1gkc
         r0EMkPHPvvuRU99MGAgbwLazKtATFcwxTWwuJdRVO4+8BXBh8alzfX+EQfop05AIYzub
         06zcGdrRIZeWntKW7Z/GsG8cDvxIw95aqKmtrB4GUybxBPseaSwjRFdzyNfnsxZG72WS
         i5rhwkf9o7Wlgs9oHqgmGnk8IXv+DAZEyXpVj2V0OHPL8M1QD/gqAlmwtAmJhqAp/zhs
         SElDmw4UvXWAAA0OKEDvJioloFPEYLJAT8X61OdhF18NghTfdBl6cuVTC59eTKPNsS4b
         LLKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790187972; x=1790792772;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LNon7FG4gNvQZ8cTIn7dGZggjcYoEo+V3D2k9W/8Sxo=;
        b=ecnIDi5iVw0B4Z6idHV1P7Vv2inBZVKOlvyu1bSNo+nmm3XRcvpUkr3SlI7zSG3FO1
         m2cbz2lFKbPnl2vCG2I4PqBTDKUxdGXPsnv+nSo8cQ8Q/ghXf9juanlzZpa4KVwXFQF3
         aeSJSHI8I7n3758jyv6zX2OBrIBq8AIYJsH9/ES0sX0w4Aoq/kk3n3dvQhVcrTGgPoM1
         PMzjs9Sq9NuA/URq99WTiN5r7oFV14Y4WsNOoTnY1AuqluWBRR9q5YCF1krFhdrCGPEO
         Yxtc1uiISkhcTeOXaaT5uGK3kEC6VjxVlAMGzXzJj0Z6vbCjxS/wu2lTi9n2PkFwHDMm
         YStA==
X-Forwarded-Encrypted: i=1; AKwUvBxyehafDYT7mOjxUNDffYrs2+n7+SSZ3CYeyjMWmgX0wTxMyzan5caBAr6LeiR53L+EjUlsr3fPKnhu@vger.kernel.org
X-Gm-Message-State: AFuF++kna0JRsiJ+B6vSy8RNXOw0jExIkH5aYJa84X+/MiW/vg3J4Tpw
	cndyx3zriUlX2AAMMDsogGYrmECiGiETZU9heqtzbuXSiBodYTa8Anj2FCLm+BGqzw==
X-Gm-Gg: AYBFou2VEU8qgOKbbW1Ws6T6UB+z9c60FcJL6ty4gt8xf4Ajt3Mpl/0sXRux4JWvxfD
	qNZ5Fri4af3gby/kyrIxifOj0xKSpipgmL5MmteXETi7JJJBU9CfSUkQQwGbRZJYID35iLwc+cb
	4OQpBxdQ9Xj+gEUAhRj3s4cIJCd2uYpKyKFsmqU7Jp6gdJPUgPG2dKtdeF7IjvRqSbZikfJCFTN
	qx9pyqSlp+Kw4a0Cz5LNCTro5TfhLfyD9foB9ZM238Qq32uGLeAUI/nFVfMmxjCydnGG7ESzCqb
	rL394oO9+J+flzuZYXXpD679xy9HxU9/aAhwpUN37v2DTzP3UBXn7eVBGvHQ4vOUzYF8ZsNHAy9
	VkP2yvGTFNAG5/vfDTrDNz9Mv5dXKtaA76LI6nTtKuUWhDJIcATigiauS01zbrAgri7Hb4WPBrn
	iHcWHPSggegui+bD8An85c7tDGc53PdwSAWa+w/Xrhv1hitV5SYYPfLrQ9gBcDmicHMIh6x4rOQ
	OmsO9JmfmW5w7BWDU1/YAiIO0oLbIa84SYxDNlVmSHK/uzie4w=
X-Received: by 2002:a17:902:ef52:b0:2df:3b09:664 with SMTP id d9443c01a7336-2df69dcdbf3mr30657015ad.32.1790187971787;
        Wed, 23 Sep 2026 11:26:11 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5eea15sm15475075ad.64.2026.09.23.11.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 11:26:10 -0700 (PDT)
Date: Wed, 23 Sep 2026 18:26:06 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Leon Romanovsky <leon@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>, Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tariq Toukan <tariqt@nvidia.com>, Zenghui Yu <yuzenghui@huawei.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 06/10] vfio: selftests: Allow drivers to specify
 required region size
Message-ID: <arQZvkNtgq-NlUkh@google.com>
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
 <6-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>

On 2026-09-21 07:35 PM, Jason Gunthorpe wrote:
> Add a region_size field to struct vfio_pci_driver_ops so drivers can
> declare how much DMA-mapped region they need. The mlx5 driver will need
> ~18MB for firmware pages. Existing drivers pass in the sizeof their state
> struct. Since drivers all use only their declared state we can use the
> value directly and remove the SZ_2M hard coding.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: David Matlack <dmatlack@google.com>
