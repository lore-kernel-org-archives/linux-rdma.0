Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9243C76AD;
	Thu, 10 Sep 2026 23:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084715; cv=none; b=L6Yt0y/U0ABVZFJr+SVjgUJn6t2aU0furGRNvPLaY1VUUdI4tkaewk8U59hkgqBzxsOYVcKTFrz//3YkIy0/EM+YHQpWWqClMyh4WsEj+bUeiSsF+rmo/gCcJ0k882ebmI3e7Tcm+4NozIefmjZ4lnKQ0+ROd9FHV/oHJABtms0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084715; c=relaxed/simple;
	bh=Wlt+zw9u3BBvTKQVn/sMM5Hb3I5PVr+iYWifVgQ3vmE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZMkamaaW+arpLc/ZjGuGrIpE/ACjZvYVLz8o37qlLbTjp5pWzLav7m87GfS79RiNJKeAAONEuAA7owdGoZeI0Woold92YVWzt+wahKlHDSWI/4vd9EcWctaxiSr7JTzXuczKgQk8aokCm/ogQi+nhi2AohK3aAAmTiaNPFNy0g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtLqO/ZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtLqO/ZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F0C1F00898;
	Thu, 10 Sep 2026 23:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084714;
	bh=XV6Vp4nIRn3BHuavub3R6KPxG0t8mEr8xXw5CAYgCAk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NtLqO/ZFzDtK0jqsrt2VHXnCFF4PPQsV40B7fjvk6D5JGXeTo7tOE/77EAb9IIQfJ
	 6fqEERweIqN+wHQ9zRhE71c10aHWfYCYR8nlMZU0D0VM748vP9mZpOosWGscOh763p
	 taBMvxxFnLEILlBcJyY8eeXWJnhucHV+5t5tuX0ZbdxXKdR54ludAE56+Kt9plKHy/
	 OZThkYeyVFCZM1YuEixx8MyXzJZWiJdCtsl17XWU6pKQI491mG72AmBJryXR62uwEd
	 aQ71t0b9Vk9Lf+CIGcOCRLiw7Dn7TjDIT2M7OtSicjsJHC/5PpQhyNLSyJGveaoe0B
	 8jjCvMl26JPiQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 10/10] vfio: selftests: mlx5 driver - add send_msi
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <10-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References: <10-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 23:58:33 +0000
Message-Id: <20260910235833.E4F0C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Invalid hardware initialization and teardown ordering with MSI-X v=
ectors causes firmware command failures and IOMMU faults.
--

commit a10ddcc560d82fed1bf7785eb0d238998106b1d7
Author: Jason Gunthorpe <jgg@ziepe.ca>

vfio: selftests: mlx5 driver - add send_msi support

Wire an MSI-X vector to a dedicated EQ so the mlx5 driver supports
send_msi(). Each EQ can be linked to an MSI-X vector, and the CQ can be
set up to deliver an event to the EQ.

> diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c b/tools=
/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
> index e5e75adb25316..c8388aabb8c67 100644
> --- a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
> +++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
[ ... ]
> @@ -1721,8 +1869,13 @@ static void mlx5st_init(struct vfio_pci_device *de=
vice)
>  	mlx5st_alloc_pd(dev);
>  	mlx5st_create_mkey(dev);
> =20
> +	/* MSI EQ must be created before CQ so CQ can reference its eqn */
> +	mlx5st_create_msi_eq(dev);
>  	mlx5st_setup_datapath(dev);
> =20
> +	vfio_pci_msix_enable(device, MSI_VECTOR, 1);
> +	device->driver.msi =3D MSI_VECTOR;
> +

[Severity: High]
Does this sequence result in the firmware rejecting the CREATE_EQ command?

In mlx5st_init(), mlx5st_create_msi_eq() sends the CREATE_EQ command with
intr =3D MSI_VECTOR. Because vfio_pci_msix_enable() hasn't been called yet,
the MSI-X vectors aren't allocated on the device via VFIO. Will the Mellanox
firmware validate the interrupt vector index against currently allocated
MSI-X vectors and reject this command?

[ ... ]
> @@ -1733,8 +1886,14 @@ static void mlx5st_remove(struct vfio_pci_device *=
device)
>  {
>  	struct mlx5st_device *dev =3D to_mlx5st(device);
> =20
> +	vfio_pci_msix_disable(device);
>  	mlx5st_teardown_datapath(dev);
> =20
> +	if (dev->have_msi_eq) {
> +		mlx5st_destroy_msi_eq(dev);
> +		dev->have_msi_eq =3D false;
> +	}
> +

[Severity: High]
Can disabling MSI-X before tearing down the datapath and MSI EQ lead to host
IOMMU faults?

In mlx5st_remove(), vfio_pci_msix_disable() is called while the queues are
still active in hardware. If delayed CQE or EQE completions attempt MSI-X
memory writes after the host IRTE is torn down, will this result in DMAR
faults on the host system? Should the datapath and MSI EQ be destroyed
before disabling MSI-X?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v5-4cacb99249f6+1=
b4-mlx5st_jgg@nvidia.com?part=3D10
