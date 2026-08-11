Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AC646AA9C
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 21:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786482557; cv=none; b=g8xFVMTOcn/X0+y9vHtzfPaXmGKciFakcQXd0R5OVF4dr0fHysZoHNSYdRQr6oOzlCX95GvurvxUBNqQv27XuiRhYLBHatEbVleOJqYE4sHPoiS+6rnuQPEhf/XvAp6hjzct8VYGyITTc+vHHT9YBXSMcchEVNVr012YKG5yquU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786482557; c=relaxed/simple;
	bh=FwNARzcbMbLf7kTkzLZos3PP0XC44XFJ9Kq/f19ElGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DI6zeQvtXtRaXPBG2dbmSNTq7Kw+E+d8RfqwxcprTEqtQs3FaO/A9ww6ejdXrLF9n3/bQd2XMKKfFhuXTt7ygcvizXLYPLfK9urMVkhkEU5XSVhX5cihhkEJX8vdmbdYKbbeK9FGa/+jolz9eNa5jOppniihZN1X8g3+eHS9Pbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=foy9iZUV; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="foy9iZUV"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84a4d8fd6ecso362681b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 14:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786482554; x=1787087354; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FCfe6U3NJnWWh5FIk3E/yNJv391SUeQXzwUsI84caIo=;
        b=foy9iZUVOTorzawNa69ViPer6GywjUCRuHMiQX9DDcq/zR5DQDUip2I+seA5xEwp+/
         obrm4G/NrkFlgvFT1rp2vHu732Q5Amhl6oofT2qpx9JpzVUvvXjGaJIJeQCrxFIwD0ba
         bPxJwtmzRAPtZc4sexwMoREbo7aULpRojkdFkciUUZy8VvQk2KQhU7gOHTnDJv1ygng5
         tVogFQx2qeyB6K8lA3ABXgGd3QL+ZGA/Y8BZCwvuJiGEmFKDm3SK4l5WRNXsv8YXizqz
         /5mU7LAu8+hTiYX9ucAVuOMVISYmb7I1A5hCA7VH/8FPeJt0EEzmKRljuiwfJ54MqNj/
         VgfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786482554; x=1787087354;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FCfe6U3NJnWWh5FIk3E/yNJv391SUeQXzwUsI84caIo=;
        b=ihiwCL5s/5BgBScQirNYDrtW73XFlRjQXHe3VtUPXh8sHs44Q90Yed+U2bXoldj3ft
         Nh90u9iZnjtIUAVQLRdpT4Iov+HQrhboEfkQ0Lnk8VVz0PLypYcuepin2oQXHJWUjw8+
         bs05sZPcrTVPCwEbrDVHpRFehN+datkKYg0b526AqyXXew/JLqXOIpELFwN4IzXKBjvp
         zLTi/s4zCKwKnRgaO1KEzWCeg04yujcsWu2O7qU9w6M3TSHe1h5p9iSflKWnDqkcrYiK
         oboz/JDmOCnPg9blMgzHYucMFA+Fpief2no4oVnLAQhYnHlvb6ZxSPQYaDr8bR6ZVAfG
         KlrQ==
X-Forwarded-Encrypted: i=1; AHgh+RqnnAB7sLbxrim6NxiUF3T+GpVQ8V6/zDagVPTCc6mKEhsMvt10DDRNvhNSYajweyGMFl0jUJ9jEwVV@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/teDOoi5hJbFI1uvafIvgdAV0KJh0dL1rbiavz1tCxKDJxo53
	PBA/6SWqhEqOchFvwR8RCHDVf40dh6K8I2Vxb0JyrXEgYLvzJBi5z8sJgPPLPt/KJA==
X-Gm-Gg: AR+sD10X7kzTE8QQj4/9sW8kL6oL6cNmAvLFWNnLM7eka564TcydWKMVpFovUtOrwQK
	N2nTKNC2b24rNHmF3smWRSC5Cp84RLE/UF8mGEBql46lyhsPGJSjJVVN0Q6BLo5AsfLHLuqFQDH
	JTjSqC58awyiBqqS6+bbdXUrByXilFN9NbcGpltzmYkqQpffIkd4DiIwUfn9FIaK6QjrbY6OQ1k
	lYgwY7YyS4CEtJM/8/B+DX/zIWdOHa5907OTZjiNweSG7me/LbaOPvnUgHNXhMBtXiDNKKj451v
	v37PvA+UntT7p3DLce+vKFQD1TnUw/5jqbzXvcC+6TmmMP46n/8QGSOOAoHZwMWJepRCYah/sbm
	Kv2xl9yUORyp1jZ7xCqRwwYPSMxpcY5r6o/8Y63/PEAayRHP9WUIYKvW6sUSuCWd1BAgXGPra3j
	m/YlZFbZoYtQYmkFAqhVne7FHdUDIkBuzgLJDhPfvapFPun/H+9juWDxN+89cirO+677E57a2t5
	BdYI+4tnd1IeYeP7FT8rbKY2orvCQ==
X-Received: by 2002:a05:6a00:4217:b0:84f:3f5e:f072 with SMTP id d2e1a72fcca58-84fb53ff444mr185899b3a.10.1786482553078;
        Tue, 11 Aug 2026 14:09:13 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84fb1f6b2e2sm237294b3a.55.2026.08.11.14.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:09:12 -0700 (PDT)
Date: Tue, 11 Aug 2026 21:09:09 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH v3 07/11] vfio: selftests: Allow drivers to specify
 required region size
Message-ID: <anuPdf84cFtZbeE1@google.com>
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
 <7-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>

On 2026-07-16 02:03 PM, Jason Gunthorpe wrote:
> Add a region_size field to struct vfio_pci_driver_ops so drivers can
> declare how much DMA-mapped region they need. The mlx5 driver will need
> ~18MB for firmware pages. Existing drivers pass in the sizeof their state
> struct. The core code will round up and minimize it to SZ_2M so as not to
> change any test behavior.

Please update this last sentence to match the patch.

> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c         | 1 +
>  tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c       | 1 +
>  .../selftests/vfio/lib/include/libvfio/vfio_pci_driver.h   | 6 ++++++
>  tools/testing/selftests/vfio/lib/vfio_pci_driver.c         | 7 +++++++
>  tools/testing/selftests/vfio/vfio_pci_driver_test.c        | 3 ++-
>  5 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c b/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
> index 19d9630b24c23f..40b8541b588eee 100644
> --- a/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
> +++ b/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
> @@ -418,6 +418,7 @@ static void dsa_send_msi(struct vfio_pci_device *device)
>  
>  const struct vfio_pci_driver_ops dsa_ops = {
>  	.name = "dsa",
> +	.region_size = sizeof(struct dsa_state),
>  	.probe = dsa_probe,
>  	.init = dsa_init,
>  	.remove = dsa_remove,
> diff --git a/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c b/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
> index a871b935542bad..c9b28365c5eb6b 100644
> --- a/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
> +++ b/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
> @@ -226,6 +226,7 @@ static void ioat_send_msi(struct vfio_pci_device *device)
>  
>  const struct vfio_pci_driver_ops ioat_ops = {
>  	.name = "ioat",
> +	.region_size = sizeof(struct ioat_state),

When you rebase on top of vfio/next please also make these changes to
the NV Falcon and IGB drivers that have recently landed.

>  	.probe = ioat_probe,
>  	.init = ioat_init,
>  	.remove = ioat_remove,
> diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
> index e5ada209b1d102..547369c5cff95a 100644
> --- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
> +++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
> @@ -9,6 +9,12 @@ struct vfio_pci_device;
>  struct vfio_pci_driver_ops {
>  	const char *name;
>  
> +	/*
> +	 * Size of the driver's state structure overlaid on
> +	 * device->driver.region.vaddr
> +	 */
> +	u64 region_size;
> +
>  	/**
>  	 * @probe() - Check if the driver supports the given device.
>  	 *
> diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> index 6827f4a6febe99..e13bbb7ee423dc 100644
> --- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> +++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> @@ -1,5 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  #include "kselftest.h"
> +#include <linux/sizes.h>
> +#include <linux/log2.h>
>  #include <libvfio.h>
>  
>  #ifdef __x86_64__
> @@ -28,6 +30,11 @@ void vfio_pci_driver_probe(struct vfio_pci_device *device)
>  			continue;
>  
>  		device->driver.ops = ops;
> +
> +		VFIO_ASSERT_NE(ops->region_size, 0);
> +		device->driver.region.size =
> +			max_t(u64, roundup_pow_of_two(ops->region_size),
> +			      getpagesize());

Blegh this is because the IOVA allocator insists on a power-of-2 size as
you pointed out [1]. Can you add a comment here to document that? Or
better yet, move the rounding up into iova_allocator_alloc() so the
callers don't have to deal with it like this.

[1] https://lore.kernel.org/all/20260529173753.GB128816@nvidia.com/

>  	}
>  }
>  
> diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> index afa0480ddd9b2a..f68239da574f5a 100644
> --- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> +++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> @@ -80,7 +80,8 @@ FIXTURE_SETUP(vfio_pci_driver_test)
>  	driver = &self->device->driver;
>  
>  	region_setup(self->iommu, self->iova_allocator, &self->memcpy_region, SZ_1G);
> -	region_setup(self->iommu, self->iova_allocator, &driver->region, SZ_2M);
> +	region_setup(self->iommu, self->iova_allocator, &driver->region,
> +		     driver->region.size);
>  
>  	/* Any IOVA that doesn't overlap memcpy_region and driver->region. */
>  	self->unmapped_iova = iova_allocator_alloc(self->iova_allocator, SZ_1G);
> -- 
> 2.43.0
> 
