Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840224F30D5
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 18:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790188265; cv=none; b=Swhd+l47BV0A1CMDvwnbJ9q3Ejh9i941kM9XlZF9YdtuLfC9qSRKmuH0ijVl6wErMerkRZrjI1kT+xvBDee2oeorkJIiuiUFtAt1k9Se1JeO9H3tRZRZq/X8Bae7ZgvLuHPbDdSGaI74E4MR1vL7wHdBgAwbPKapvtTq8Gx1i24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790188265; c=relaxed/simple;
	bh=lWag3oM9sYGpdHyGnDE7rA3iXeVqrktsZhX6pT4UGs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UN2wdjrzzg7dHKOUBYg/NA5R89amvtGFJhAqOwgxoS8bxxkmN2armtFhoJN0Pc+6bCNEp4QbEuCsEuvFQbWjuvA0qt5gNOLIiwuKtZRTPYEqa3SpXnGc9NwwoPy0ZYfcAeSMJR8JL4t9aR+oxEbVHQOwk6h1Pp4pjbTIA8W1Gf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OuXyJUlU; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OuXyJUlU"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-8623e5d435cso442305b3a.1
        for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 11:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790188253; x=1790793053; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qQbES28pq+4+5SdsOxa0hPCoAfkWzPeIh6+fD64KIF8=;
        b=OuXyJUlUPtMGFQ5DWG/IMX6NGxL8J4NG1NHjhdsM40etbe4/isGYi5Fo1Nswte/qWM
         HRorY+v7u0m1lONdLNau7BOvww6tgrePu3hxCRY6oXcs5WaTIeisJn5qxHhyAa77XDwQ
         9dpApYUHDqbqow9zea7CB2Ao90FaUmytc4qSLKyhz3FozJpJ956QNYpxnj5EB5LYX1AW
         0w/YvHVuOYJ7P1Jx9jaZLBBbkSCVxpfiCw6pNGXfH7Q2PYwu7+FGgFUzHODiUvBqfs7I
         QRiS2Hhn4uD/5vLnshlqK5lbByrWNTuRr+Ha1fyVezkThcXSI9wj3tQN98/t/R7//xP5
         moYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790188253; x=1790793053;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qQbES28pq+4+5SdsOxa0hPCoAfkWzPeIh6+fD64KIF8=;
        b=T+ijz9FzqWzyxVGf8N8/89JrF3hP7zhGdmEJ8jMCnLJQR/NS7IdHOoaZ8WZrvuLuHH
         qFyWjvlaxn9zKVNiWEDnBEQickEQT3AbcQYSU0b30+AtrONwWYJjG7moRhTuoUWp57ED
         58sWenuoxYLeq9nB794x35o6At/15+XN9JcPducWvucqBxaYd2P86o1Hd0Os0dd0RhfE
         v//GHTWwgkLl4vA1egVGqz79EliH7enpgcWtItdHu0jdScz5qS7lZQu4BZl+g4cZT3QY
         sDLEZoWZeySd6A3GPctc/Ny0028Y0UaeUdz7VD2CkSs/0zqaywM56g78iwmNYuRZQWCe
         8cTQ==
X-Forwarded-Encrypted: i=1; AKwUvBz7/NK9+Zoj3/tvw7wBmR53ZKV4Pr2dOMQOcSz3F7RhS3A4FlknOTFBjYRuSdDgVs1UTHFeZE7BRSes@vger.kernel.org
X-Gm-Message-State: AFuF++mbBiBF83xv1WEdVWTxU6HmBBx9RvoNNhPvtI5eF7/RUXi0sPwY
	ovmWOCOoUPBm8YXlp2DeGb9T0gd+QXdung1yB1LcFZp4MAfJxNpa3Ejs0co4/+KX+Wvf324Aism
	yBFpDNiso
X-Gm-Gg: AYBFou0CaABa7BowpY5AD4zuwVCEOxx7alOMyDSCefWf7PD10lxTkPcuMRhpNYl4Lzf
	ENDDQcHyXm8ZMcRPBRqUCJjYLoUIEV2PWk0nriRpOmqEmMSHNJ7RW91BUJK9uTjM5+x3ZMh53dE
	MDCeb2thcwuq6XSJoucbyXV8OPLDXPCtq7sVkmexL/lRQ50wWw/MTAbObKCX3RsFcYKlpKc5Zuh
	V35w0MbfOtxgDK/+Hrfk6Jgc43k/BiUzf37rWx9J6HL5Swn9wItZmCdV7jjizLSni5V/GE88uX1
	Sxlu3se4hb1FRRyl4vV/qg1wlNsf8UKQhuqZDqo2Xp0d4V16JXFkjlbFn91oJNydxxSnvUtlLND
	ovUacbRaeL/aykhZywjY9uus74yLBg9wCxZPW+acRnNjUbwfPIlLAOdIs6f4Fv5CZWnN5/BHLJO
	ykTqUugK65yU1XbPlBDtvZ+oXGW8agm+2iM3USoxGPQ9lxDQgncycFygrmg1VVsZh+2IZAljZE3
	YHg1B+5vRQXzOxibym8oVyWsqYR2nLX9McMI8PBxFOa/VM+lso=
X-Received: by 2002:a05:6a20:7290:b0:3db:131b:8d8 with SMTP id adf61e73a8af0-3de0e7300c0mr45910637.14.1790188251251;
        Wed, 23 Sep 2026 11:30:51 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1d5c12besm1736810b3a.29.2026.09.23.11.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 11:30:50 -0700 (PDT)
Date: Wed, 23 Sep 2026 18:30:46 +0000
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
Subject: Re: [PATCH v7 00/10] mlx5 support for VFIO self test
Message-ID: <arQa1khEHzKOfkCK@google.com>
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>

On 2026-09-21 07:35 PM, Jason Gunthorpe wrote:
> Add an mlx5 driver to VFIO self test. This is largely a remix of the
> existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
> to issue RDMA WRITE operations which effectively perform memory
> copies using DMA. Since mlx5 has a stable programming ABI this
> should work on devices from CX5 to current HW. The device FW must
> support the QP loopback configuration.

> v7:
>  - Fix some compilation problems, kvm and the igb

> Jason Gunthorpe (10):
>   net/mlx5: Add IFC structures for CQE and WQE
>   net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
>   net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
>   net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
>   selftests: Add additional kernel functions to tools/include/
>   vfio: selftests: Allow drivers to specify required region size
>   vfio: selftests: Add dev_dbg
>   vfio: selftests: Add mlx5 driver - HW init and command interface
>   vfio: selftests: Add mlx5 driver - data path and memcpy ops
>   vfio: selftests: mlx5 driver - add send_msi support

>  .../selftests/kvm/include/arm64/processor.h   |    4 +-
>  tools/testing/selftests/kvm/irq_test.c        |    2 -

Sean and Marc/Oliver, can you take a look at the changes Jason made to
KVM selftests as part of this series before we merge this into the VFIO
tree?
