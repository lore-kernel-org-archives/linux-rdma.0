Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E14381E96;
	Thu, 24 Sep 2026 12:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790254613; cv=none; b=GnX8DZeoa3LvCxlbOG2/nHQ/Iot7kq1lBxzCHPeuZzEsmPkSxeT75GnGkBYglueM6Fp3gLR6+LK17XKRpU1FfQr3PEwrLDXa3ynd/tUNsVo5GT7c3bg8HM2t/Ex8gdpujkcPSJdB0fJjY19HHVNMftnmgWeZlQxPeJmR/X6sF+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790254613; c=relaxed/simple;
	bh=9KFP333nBL3cE3MWpAffOS+SZ2NE4xEC9rmyuPBFGBs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fDxoHGukgIgvBTNTbIwOV8GiSgYlI6DKA53Lg0rHLa37EVGsTwoQiEbD+gcj14Cv2md43tOBLSrhFCS1xiKnnRNqi1nvLrYEdNv+4kg1KxteCywHRvs/QrjxAG9A7T4vApt4VVze7Qap2odvuVRpIDlGbn/C+i6WcgtHv4n6uCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=SfDv2A2m; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hPDQhnza; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="SfDv2A2m";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hPDQhnza"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 8A2C1EC006C;
	Thu, 24 Sep 2026 08:56:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Thu, 24 Sep 2026 08:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1790254609;
	 x=1790341009; bh=nh5lY07F/XdtpzZWisBcou4EdetqWlxWEhSWH7F4qoU=; b=
	SfDv2A2mrCaoAZJYIg+Gdd5VA7VdxBZbvuu2ggT9DdEBxG9zdV7rTuHSEkdp2muC
	RrKs1Ca7dVpiS45RImV8oYv+FoCsLmwQD3kkyb+4+C2iNKThGf9SWJoIu2b6PgYv
	vZcIM/pQOrPURQUUMWcywq/mJv9M4Spdmnm5RAAc41f0uhx81mNomQAjmA2nDhxU
	+8LlYteXhm/Pc5N2bEAm1UeTQ8PsFO2uox+rLk1WibktQi656HxEJ62wXfUGdKdk
	WWgGVzAQbQxDrbUjTkHDEoJ3QDP8hcpdgbfVbUWumn5d2XbwRUz6GiB5EYFMuKPQ
	brbE8PDidMo+hX1w+fZA/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790254609; x=
	1790341009; bh=nh5lY07F/XdtpzZWisBcou4EdetqWlxWEhSWH7F4qoU=; b=h
	PDQhnza67R40uz4KVjCagCuK/1ooUwva9Er/NXECJ0FHEjMoMBoke2aHuIF2ssXJ
	QsG6/RCqtJNK/IZzLbY0mngXIEhP7YJdFnZEgu44m0ROGyqO4yEL8LA0oeg6hdiv
	g+4BV8T2xgDx+1+sH6oOz7vY0K9damZ4tMI7KMy/1EJCGdwDy7HOLikaDy+JfnLX
	6ceMFdyezhDzCrzOLqL6xFG+ahmA+HuwZgt1Quxl3FtMB7QbzKyIolhlTc3W51ft
	1HO6VkDpAhH89/pvPW98PePu5IgoTQb8T4nDUYoG+ICHwCQxGQCVMj+gRn/fkw6q
	oDCYZqON4IQ53LirsjKSQ==
X-ME-Sender: <xms:EB61ag6hannoEnoGHm6M8Td2p4HPwBZaXj4x4b9wNZ05UmtIGoWlIg>
    <xme:EB61ajnCXa8dcuv_zjPzBiXZBLBc6SilmBzOljFoB43fww6ABJ517VLYOPGLIdCA0
    EfKyxUGve3geURx3lvzvz7lryK1DCOfJ2dyFr_G9eIdujkUFOKC8vA>
X-ME-Received: <xmr:EB61ai6Z9V5eFqttc2Xvt_ymbI2pa28pxkVrhI-YoRi6duOZ1uWRfDQBgIn8MA>
X-ME-Proxy-Cause: dmFkZTF32quzzh7iukCEspo2//2/EETePHBVgKSDjotfiMLGFMKMi36qp1G2l6m0603LrJ
    etTQuK4n5psitazgA7NI8ZNAj7Boz3Iz2PTvtSHc4YlI+thZ+g9AxqEWr6smXP4eTxr12L
    j4iqpnH1GtJD2uV9oEuEdNTFWS+cbDLo5wkX85Q/VxLJ3pJBv3fDm5p4L0ICSGL2DRf+46
    Zml5juxNyzXgitBUARzy5Q+nGWTe5JIDB908ZQufVLIQOoOBXqBBTkAU9StkEDBWH3HPm1
    ntYntvDmBSd8joOmDn8RlxUIhT6RE2mlz7OAGRk1ORprL1NHSpdJ4EtNFWlP7TEPEI2LL+
    pYpBOVi8BAwOPzs8KcdsKkIryA6tKwcjIx9YbxHEmrYndho1FvpUUtTEwlPkk7X/dQD9Ri
    ojMeInjDm3Qf5JrK4MBzkNA7Dt3NJ6cqbP3mXwlxY66VM1OQkoplQn+y8dqGjimJQChM0H
    X/OWXCexHTyaKnsGcaXBBz4P6OIry6aIZOK+2kHFAjj6C2QgTN1cKSnEM8fuIS6PcDd0+W
    qERUKkVymlRMm2x+LmGNo26NcGSU5Ypn9oOO6KRxrdQT6g4w9CrjoWNMiED9/ya8srtUMd
    ZvrlCrWUre43Cm5+vQfUS0dE4wk7Jh2khI5DPdNo3cIJyUXSXDtSlgOb28sw
X-ME-Proxy: <xmx:EB61ak-CCIp6-CYCczNih1SN9_54-HNNmAHQY0ICnnl0s8AO4EmszA>
    <xmx:EB61aqjS8hEqWBBS_8_EGr-7wJVSDCuh5GhtYl6xKl0pHw9uD66TrA>
    <xmx:EB61aq4gadEPI3rZSlrTz5wkDYHf32dqAFu2Lg2_LiD0KyoCtx3ypw>
    <xmx:EB61avZEX_jEZucgTShjdxZtDWzWj6mznxYhBi5hg5Z0SqiIAAABXg>
    <xmx:ER61aii1kJ3fAXJc8Rp40Kh9XAv9uxpj6Ga3ZpCPvgjzzFsOuVxOhPuQ>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Sep 2026 08:56:45 -0400 (EDT)
Date: Thu, 24 Sep 2026 06:56:42 -0600
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, David Matlack <dmatlack@google.com>,
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, netdev@vger.kernel.org, Oliver Upton
 <oupton@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Sean Christopherson <seanjc@google.com>, Steffen Eiden
 <seiden@linux.ibm.com>, Shuah Khan <shuah@kernel.org>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Tariq Toukan <tariqt@nvidia.com>, Zenghui Yu
 <yuzenghui@huawei.com>, patches@lists.linux.dev, alex@shazbot.org
Subject: Re: [PATCH v7 00/10] mlx5 support for VFIO self test
Message-ID: <20260924065642.125986a4@shazbot.org>
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Leon, can we get your ack on 1-4?  I'll publish an rc1-based branch for
any conflict management.  Thanks,

Alex

On Mon, 21 Sep 2026 19:35:40 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Add an mlx5 driver to VFIO self test. This is largely a remix of the
> existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
> to issue RDMA WRITE operations which effectively perform memory
> copies using DMA. Since mlx5 has a stable programming ABI this
> should work on devices from CX5 to current HW. The device FW must
> support the QP loopback configuration.
> 
> Also support send_msi by arming completion events of the RDMA WRITE
> to trigger MSI delivery.
> 
> mlx5 device startup is very complex and most of this code is just
> booting the device, with a smaller amount for operating the QP.
> 
> This entire series was coded by Claude Code in about 4 days. It
> used about 4.5M output tokens, 30 individual sessions and 5600 lines
> of AI-generated .md files. I spent an annoying amount of time
> de-slopping and cleaning its work product to make it presentable.
> However, previous VFIO drivers have taken on the order of 1-2
> months to write, so getting one in a week is pretty remarkable.
> 
> For those interested, the flow I used was broadly a prompt sequence
> sort of like:
> 
>  - Hey Claude, go look at the falcon series, VFIO self test, the
>    mlx5 driver, rdma-core and some PDF documentation and make a
>    plan to put mlx5 under the selftest.
>  - Write an rdma-core application using the built-in VFIO provider
>    that can do the required memcpy operations that vfio selftests
>    wants.
>    (This resulted in a 1k loc C file that compiled and ran the
>     first time but had a few bugs related to device programming
>     that the AI resolved.)
>  - Replace the rdma-core components with open-coded versions to
>    create a fully stand-alone program that does the DMA memcpy.
>  - Review and audit the thing.
>  [Pause and de-slop it]
>  - Make it work on a PF too (this is surprisingly hard!).
>  [Move to a kernel tree and copy all the .md files and .c program
>   it made]
>  - Hey Claude, look at all this stuff and make a broad plan to
>    actually build a VFIO self test.
>  - Here is my 1 sentence advice on what each patch should look
>    like, make a detailed plan to make a patch for every one.
>  [Pause and polish the patch plans]
>  - Execute plan X then commit it [pause and de-slop each patch,
>    repeat].
>  [Review and final polish]
> 
> v7:
>  - Fix some compilation problems, kvm and the igb
> v6: https://patch.msgid.link/r/0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com
>  - Rebase on v7.3-rc3
>  - Correct some minor sashiko remarks
> v5: https://patch.msgid.link/r/0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com
>  - Rebase on v7.3-rc1
>  - Adjust how region_size is computed to min it to getpagesize()
> v4: https://patch.msgid.link/r/0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com
>  - Rebase on vfio next, update igb and falcon
>  - Move rounding to iova_allocator_alloc()
>  - Remove arm barrier changes
> v3: https://patch.msgid.link/r/0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com
>  - Move max into vfio_pci_driver_probe()
>  - Rebase on v7.2-rc3
> v2: https://patch.msgid.link/r/0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com
>  - Rebase on v7.1-rc3, drop falcon patches
>  - dev_dbg checks the format string even in non debug builds
>  - Sort includes
>  - Adjust comments/commit messageas
>  - Use linux/pci_ids.h
>  - Compute the driver.max_memcpy_size the same as mlx5 kernel driver, it
>    should be GBs now on most devices
>  - Put region_size into all drivers instead of allowing 0
> v1: https://patch.msgid.link/r/0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com
> 
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
> 
>  include/linux/mlx5/cq.h                       |   10 -
>  include/linux/mlx5/device.h                   |  231 +-
>  include/linux/mlx5/mlx5_ifc.h                 |  178 ++
>  include/linux/mlx5/mlx5_ifc_macros.h          |  185 ++
>  tools/arch/arm64/include/asm/barrier.h        |    4 +
>  tools/arch/x86/include/asm/barrier.h          |    5 +
>  tools/include/asm-generic/io.h                |   28 +
>  tools/include/asm/barrier.h                   |    8 +
>  tools/include/linux/stddef.h                  |   10 +
>  .../selftests/kvm/include/arm64/processor.h   |    4 +-
>  tools/testing/selftests/kvm/irq_test.c        |    2 -
>  .../selftests/vfio/lib/drivers/dsa/dsa.c      |    1 +
>  .../selftests/vfio/lib/drivers/igb/igb.c      |    1 +
>  .../selftests/vfio/lib/drivers/ioat/ioat.c    |    1 +
>  .../selftests/vfio/lib/drivers/mlx5/mlx5.c    | 1928 +++++++++++++++++
>  .../selftests/vfio/lib/drivers/mlx5/mlx5_hw.h |  114 +
>  .../vfio/lib/drivers/mlx5/mlx5_ifc.h          |    1 +
>  .../vfio/lib/drivers/mlx5/mlx5_ifc_fpga.h     |    1 +
>  .../vfio/lib/drivers/mlx5/mlx5_ifc_macros.h   |    1 +
>  .../vfio/lib/drivers/nv_falcon/nv_falcon.c    |    1 +
>  .../lib/include/libvfio/vfio_pci_device.h     |   11 +
>  .../lib/include/libvfio/vfio_pci_driver.h     |    6 +
>  .../selftests/vfio/lib/iova_allocator.c       |    7 +-
>  tools/testing/selftests/vfio/lib/libvfio.mk   |    1 +
>  .../selftests/vfio/lib/vfio_pci_driver.c      |    6 +
>  .../selftests/vfio/vfio_pci_driver_test.c     |    3 +-
>  26 files changed, 2502 insertions(+), 246 deletions(-)
>  create mode 100644 include/linux/mlx5/mlx5_ifc_macros.h
>  create mode 100644 tools/include/linux/stddef.h
>  create mode 100644 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
>  create mode 100644 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
>  create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc.h
>  create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc_fpga.h
>  create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc_macros.h
> 
> 
> base-commit: fd73f4a6659897191fa0d40695fe370925dd3780

