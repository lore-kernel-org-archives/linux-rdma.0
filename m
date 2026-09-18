Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F358949B47F
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789743574; cv=pass; b=BWnLBz8+6tEJQMWEoC0Cd1vKfgDGa7XZTnW4Q981uNGrN/84U+A5rFDucSeAOBUor7ywfcSN9l1BJTV3Wv1nn+oIsEeRIxbr17igyVG03pe5/cEt2jy6Zbn9MrGw/TbFWepWKRsOU8zJBPl9sNRgFJBxlH5BKLHP1tAklyrpRmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789743574; c=relaxed/simple;
	bh=9/KuOEAUccINW8RzQoPd+Ke7JmL5bSGUt4d83wOmGis=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fKztR1wEkckzOAfdpM1Oe6PDjChXosy1OJpSMsnkDAihslX3cvz4vQUX+U6G12GL50zU0FNnIviY51kePXiaXCBg3R5+Lz4YMihs37t3KZmFj3oV7vPpA8qxCf0hwU2npp2Kb8WtyFbZnMct+VeFLnIWafjY1gsFl8/BcDWgGzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wUbT/9JM; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wUbT/9JM"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c20ce3c118aso124368966b.0
        for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:59:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789743569; cv=none;
        d=google.com; s=arc-20260327;
        b=hmctWNXNbjECPq8Q6pr8VPgNAaZCWHEuIuPW/+7Ur8FTMMetjJoJ5uS1ZIDXN1m0uD
         vO+zEqfDvB8qgwTU9r2GTY+l0yk0eMxQSg4y9k3Kdk3Wuui4+irNQNsFLyGar0KPyifO
         ll6vLdVWMP9Uke70OtaRupFDT26biAXJFdjVj+82I+q8x/u6N5Sl1HsR/PPc1/tOLCTt
         JwxLs51hpQtLSNDSpa3F1HN3ywVPR6raQ4JxKCWerXTQAEfC4jTUssxFVVbcnmUF0yUt
         +S0z04xPbRyHjAmw6RnaSwy+w8vGD83lS6UENEZQARovVPdrnf7OqoMIlxjQ38PRymAw
         pNvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YC0PefwLkxVBXTBsKzjOWy/17vdgqLJp4+m26mDaKG8=;
        fh=wJPTFeDZCdDlPCJYgT8ZTG54UtmUHyuqkOEhHfCNrpU=;
        b=eXZpGeQ1IuEKI/e0F6ltZCjIGKMAfZ/EJB1AiRdBuv66S34SUX1dUc9JCDdprs/KvS
         Sx4t6GsYKyd0zU7g6bMi1Lwdc3iGWqIIEwjbgiHaQcfFNght1sjRdPyxd+aWcK7wNHnd
         6TBq3c5U53M8xl/CLLNlWg3E4DEzh35lVoACvucFjvt7EazwigKff10zr6TFtYhuuSGS
         0VlN3cpt/OLsxgPueC/q0CvQwkFWF4ap/xeVHKC/I9Rck+NYAWTXnm0J44u4zKav3W2M
         aT804r1MswXsnvg8wOHm0y6Q41byXKDXVHrLtkbt2XHbzhUpoHblJHvi85Nwc5thUqnK
         L0bg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789743569; x=1790348369; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YC0PefwLkxVBXTBsKzjOWy/17vdgqLJp4+m26mDaKG8=;
        b=wUbT/9JM5hL1fagbQzV4/7jP1wqJbD2L9Azs+HO4vU4UJ57uHCGo2NYm6HyRdTYpbp
         TCYXG3bh1O+OVrRV7zfa7UmszO5I/vaAZ58R7+mNyBKuSuCqme6mUxpI0DJ9Pfsd5oyL
         0lBtlDiw9adzJbNUu12jp5faSKDi+OuHRYBDPagmBXJSHFlKrK84jmp6fuMWbPTbTG4f
         JPTw3aceVGDVAyR7o9pRYHJoczSXq5uTFLx0RlBSbRclh74diybb51v0dT1AQfLsqk9i
         ZImA4MxkE1pTVX8gb1xCR9iZmEm9qy2qK5sy7cf0M1wByoHjFxXJbiaIQp52+ViIIuT0
         QZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789743569; x=1790348369;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YC0PefwLkxVBXTBsKzjOWy/17vdgqLJp4+m26mDaKG8=;
        b=T0o8+k3ZtK8IkEBonZ2AXLvvcXiuZZi7vjoSo5GnQFsgiUiLLNRHNRtdMasZY91klx
         c84KwRONUiAv8q0VBgCvj0EQye4UQrzE23RgGX1zx1NRa1BEn+IErwEIJGoTYFllS3R0
         8CBFk17KooeaPo3esXnvOELTbPp13UHlxot7ycpivxHtyCiqaKKyiPhUdUZ7SjLWJz8g
         Pxb2Zs1f2yzLhSnUNEQjmqb5o8CYRTC5MGru4PFSM/bolfVGl/J1cbhhoEtpV9FGmQCN
         i9+iTXW3oIF1+4WL2g/AuYqh/4xooMpHAaw4WMkAImPQAO2qvKJjwWPqTfxHl831/HNS
         60PA==
X-Forwarded-Encrypted: i=1; AKwUvByi9Puo4TvQVW8sCtDnHhLvF4Xbza5RV+AIc9nPLAOQqX43lNZkxaUJtSJEoDwooEgFntPL7l489VBi@vger.kernel.org
X-Gm-Message-State: AFuF++mApRkUJuwHsPvyseIsH04+1zNVVADmXIWt3iGdJcdKMVHGylPU
	/tSSwRUDAY+ZxVFytlxk3lmVdqnt8a+PkwAwtN2DwDmAiivZ8LIsmjH1KZoGdz+QLtu65HBX0Qy
	JQbw2bB+FLmHgeEgMd4xl4xrhA7eVcPT4v+/lH97UnY+rgvV0GN4jYoymC2k=
X-Gm-Gg: AYBFou2MDbr50YIS9pAZcVqvIlbd8gnmzaVvFqypDqqpR7VH6D7FgGymptavv/c2FJL
	LqA9tV8HW9w8/jAb+JExuDEkwVS/KQN8ooNmfLCCYsUiK0hRuRKfrWNBGMjb/QCEt6rxv4ysD1T
	HJ/uR6c2wITQWZXpHYNXDKPtjDAHoQ88zDLx487cn9EAde9i8sc4yRIjSNtdftXizo+ipitdnEi
	dlBWf3h4R7mX1Sox7H9l7e2lbR79X3av2DTChqDdjBAdt/ktNpZmJFrAnVeqUAKJJtG8aq09r5S
	XtLMPx9Jthn1EgcYqjdFwewXwchKAEEm8VB3El/kGX+1JTUwaPUfIcpb
X-Received: by 2002:a17:906:ba88:b0:c25:f7dc:2da with SMTP id
 a640c23a62f3a-c29f5473df2mr602164866b.27.1789743568771; Fri, 18 Sep 2026
 07:59:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com> <20260917235245.CAAE41F00898@smtp.kernel.org>
 <20260918115217.GA11142@nvidia.com>
In-Reply-To: <20260918115217.GA11142@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 18 Sep 2026 07:58:58 -0700
X-Gm-Features: AcwNN1X4V2ednysXTROsIDMbW8yLdztMha6mDhRxWrhyVFhdILawxuBGR-T7aI0
Message-ID: <CALzav=f4NTb4Csn2BoK5kk=MckFRvbVnOdO9yiCz8MLXdRMPOg@mail.gmail.com>
Subject: Re: [PATCH v6 06/10] vfio: selftests: Allow drivers to specify
 required region size
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org, 
	linux-rdma@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2026 at 4:52=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Sep 17, 2026 at 11:52:45PM +0000, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential is=
sue(s) to consider:
> > - [Medium] selftests: kvm/irq_test overwrites dynamic driver region siz=
e
> > --
> >
> > commit 97ad8ed7fec97be65848236fd1c8afab2ff66a54
> > Author: Jason Gunthorpe <jgg@ziepe.ca>
> >
> > vfio: selftests: Allow drivers to specify required region size
> >
> > This commit adds a region_size field to struct vfio_pci_driver_ops to l=
et
> > drivers declare their required DMA-mapped region size. It updates the c=
ore
> > driver probe and the vfio_pci_driver_test to use this dynamically probe=
d
> > size instead of hardcoding 2MB.
> >
> > > diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/to=
ols/testing/selftests/vfio/vfio_pci_driver_test.c
> > > index 761bf117d624f..2bd949aafd731 100644
> > > --- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> > > +++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> > > @@ -87,7 +87,8 @@ FIXTURE_SETUP(vfio_pci_driver_test)
> > >     driver =3D &self->device->driver;
> > >
> > >     region_setup(self->iommu, self->iova_allocator, &self->memcpy_reg=
ion, SZ_1G);
> > > -   region_setup(self->iommu, self->iova_allocator, &driver->region, =
SZ_2M);
> > > +   region_setup(self->iommu, self->iova_allocator, &driver->region,
> > > +                driver->region.size);
> >
> > [Severity: Medium]
> > Since this changes the vfio test to use the dynamic driver->region.size
> > instead of SZ_2M, should tools/testing/selftests/kvm/irq_test.c be upda=
ted
> > as well?
> >
> > It looks like vfio_setup_msi() in kvm/irq_test.c still forcefully overw=
rites
> > the dynamically probed size back to 2MB:
> >
> > tools/testing/selftests/kvm/irq_test.c:vfio_setup_msi() {
> >       ...
> >       region =3D &device->driver.region;
> >       region->size =3D SZ_2M;
> >       region->iova =3D iova_allocator_alloc(allocator, region->size);
> >       ...
> > }
> >
> > Will this cause the KVM irq_test to fail with a VFIO_ASSERT_GE during d=
river
> > initialization via vfio_pci_driver_init() when tested with a driver tha=
t
> > requires a larger region, such as the mlx5 driver mentioned in the comm=
it
> > message?
>
> I have no idea, Dave? Did kvm start using this stuff?

Yes, KVM started linking in the VFIO selftests library in 7.3 and
irq_test.c is the first test using it.

Looks like that is also causing the dma_rmb/wmb() redefinition
compiler warning from the kernel-test-robot.
