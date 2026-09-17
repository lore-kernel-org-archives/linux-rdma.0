Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C324BF923;
	Thu, 17 Sep 2026 23:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689167; cv=none; b=WoRBYwxVpQ5qRqCFZDgpVY16C76w6fC7Xx3IShJY/tOlYwS1pVbEkPoAeF6fS8y4/zJQjWfkFN5gTJA246SFsz1EgesQ8qkrvwyVtW5E1ZILwFDY8SlSh5w9eEcBONbV3O3ax3FNEFNpAnRnz3tVFGAjyrMcMEnDebLaLByCj8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689167; c=relaxed/simple;
	bh=qAUziYxw5G2G2k7JdLAlpqDmjKcRLYOXwIpuxiZrMKI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=X5b+YSi0G4DEo6TgE1VNYS9xggw6qOFcW74MevnbY281APgm2CFgSecFaKs4uWTDm/rWxSKNyoMD+N9dWW7qOZ23b2ZfVVoYsU6Xw++YDC1ZfM6T5gggXm84+l2tBJkzVlDoGu9jN3uVYy6PbMDiNRVCSz6sqCpBoxoffyJnUG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MeS+q60r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MeS+q60r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAE41F00898;
	Thu, 17 Sep 2026 23:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789689166;
	bh=uX42g5rzUgaRqRLXGtQCWsDUTtSH27hUJqZ9kV7cScY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MeS+q60r7DE5Z59q6GZUOIb2a3teqYHwUDnrzPucHhDJRmZ2ameUSfJ1gJX8KjcJu
	 SWPN4mwg2RGIJBTUjY3DDi1xGMiw9O803V+diKq9tY0DWDFMgnqEtYjx8QwmEP06PE
	 qS8SfR3v1Ggr7ftU4F68lupreki4OOfXRGNRMJUAK47eKMEA5oB6Uke+U0HU7N9Hpc
	 tNhFC76gXsoZv0zXvf5Tav7vQqYYixU28sdXCxwmBJzIGFSSkBBGSstbGpi8o0rqW8
	 9AZPFhQWRX8hylBlHvyziddTE2JRTO5kQIcxZx6ew+Di997PjIPNs1DH8qvI1rbP+9
	 KvCKdZXRl81XA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 06/10] vfio: selftests: Allow drivers to specify
 required region size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <6-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References: <6-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 23:52:45 +0000
Message-Id: <20260917235245.CAAE41F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests: kvm/irq_test overwrites dynamic driver region size
--

commit 97ad8ed7fec97be65848236fd1c8afab2ff66a54
Author: Jason Gunthorpe <jgg@ziepe.ca>

vfio: selftests: Allow drivers to specify required region size

This commit adds a region_size field to struct vfio_pci_driver_ops to let
drivers declare their required DMA-mapped region size. It updates the core
driver probe and the vfio_pci_driver_test to use this dynamically probed
size instead of hardcoding 2MB.

> diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/tools/=
testing/selftests/vfio/vfio_pci_driver_test.c
> index 761bf117d624f..2bd949aafd731 100644
> --- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> +++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> @@ -87,7 +87,8 @@ FIXTURE_SETUP(vfio_pci_driver_test)
>  	driver =3D &self->device->driver;
> =20
>  	region_setup(self->iommu, self->iova_allocator, &self->memcpy_region, S=
Z_1G);
> -	region_setup(self->iommu, self->iova_allocator, &driver->region, SZ_2M);
> +	region_setup(self->iommu, self->iova_allocator, &driver->region,
> +		     driver->region.size);

[Severity: Medium]
Since this changes the vfio test to use the dynamic driver->region.size
instead of SZ_2M, should tools/testing/selftests/kvm/irq_test.c be updated
as well?

It looks like vfio_setup_msi() in kvm/irq_test.c still forcefully overwrites
the dynamically probed size back to 2MB:

tools/testing/selftests/kvm/irq_test.c:vfio_setup_msi() {
	...
	region =3D &device->driver.region;
	region->size =3D SZ_2M;
	region->iova =3D iova_allocator_alloc(allocator, region->size);
	...
}

Will this cause the KVM irq_test to fail with a VFIO_ASSERT_GE during driver
initialization via vfio_pci_driver_init() when tested with a driver that
requires a larger region, such as the mlx5 driver mentioned in the commit
message?

> =20
>  	/* Any IOVA that doesn't overlap memcpy_region and driver->region. */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v6-8af36cf7b73f+e=
2-mlx5st_jgg@nvidia.com?part=3D6
