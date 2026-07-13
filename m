Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BD83D25A6;
	Mon, 13 Jul 2026 11:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783943268; cv=none; b=NqzGtfsLGww3+x7YAsLUZ7z97AOe5P5dBK0I2A9uVcrR+tjetfz9+sXOclqMmQtQXsYUBGW2nzvsJKEWTBzS0mtMHXHl9TXVSVIu4znBxqKa0tCjCmp+Zz42extdlcUCZmXkOf+xroGSgnbuLzMBH9ga9eE41ncvgWfsElz2BZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783943268; c=relaxed/simple;
	bh=KNTdMzPJoS1a0KZptLeVMG73JxnVvViaOd4eSzzzVS0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ex5I/YLmphAbjXD3MLKGpIvPA4tTOzhq8/AzslVKc7HNdy9XRwZ3diik4RTpbzNEVj4Sj74E933UOeJrnUXLNvW4QdibKZDB394kvjLDzBpUazHorI6HBaaCZiCB0DFrrdIK3W3SJtdoTpdNua7Wp+/yi05K6HyAZrcz6KYnDwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4A41F00A3A;
	Mon, 13 Jul 2026 11:47:46 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Ira Weiny <iweiny@kernel.org>, 
 Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
 Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, 
 Mike Marciniszyn <mike.marciniszyn@intel.com>, 
 Sadanand Warrier <sadanand.warrier@intel.com>, 
 "Michael J. Ruhl" <michael.j.ruhl@intel.com>, 
 Dean Luick <dean.luick@intel.com>, 
 Sebastian Sanchez <sebastian.sanchez@intel.com>, 
 Jubin John <jubin.john@intel.com>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Dennis Dalessandro <dennis.dalessandro@intel.com>, 
 Dawei Feng <dawei.feng@seu.edu.cn>
In-Reply-To: <20260708-clean-init-one-hfi1-v1-0-b9e9641268a5@nvidia.com>
References: <20260708-clean-init-one-hfi1-v1-0-b9e9641268a5@nvidia.com>
Subject: Re: [PATCH rdma-next 00/13] RDMA/hfi1: Make init_one() a sane
 counterpart of remove_one()
Message-Id: <178394326416.1700515.8921906634161250041.b4-ty@nvidia.com>
Date: Mon, 13 Jul 2026 07:47:44 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 08 Jul 2026 13:45:38 +0300, Leon Romanovsky wrote:
> The hfi1 PCI probe path, init_one(), has accumulated years of ad-hoc
> error handling that no longer matches how a driver probe is expected to
> look. Rather than unwinding each initialization step as it fails, it
> allocated hfi1_devdata up front, ran every stage, and then funneled two
> unrelated failure values (initfail and ret) into one combined cleanup
> block. That block kept the device half-alive "so diags can be used",
> created the character device only to remove it again, flushed a global
> workqueue the driver never queues onto, and diverged from the teardown
> in remove_one() even though both release the same resources.
> 
> [...]

Applied, thanks!

[01/13] RDMA/rvt: Return NULL after port allocation failure
        https://git.kernel.org/rdma/rdma/c/2982eaf3b9d2d9
[02/13] RDMA/hfi1: Preserve unit 0 on allocation failure
        https://git.kernel.org/rdma/rdma/c/2e3809ad8911f5
[03/13] RDMA/hfi1: Remove redundant PCI device ID validation
        https://git.kernel.org/rdma/rdma/c/af9117d02f5051
[04/13] RDMA/hfi1: Pass PCI device to hfi1_pcie_init()
        https://git.kernel.org/rdma/rdma/c/b9cb5e81f7d90f
[05/13] RDMA/hfi1: Drop device data from hfi1_validate_rcvhdrcnt()
        https://git.kernel.org/rdma/rdma/c/4ebd241071af81
[06/13] RDMA/hfi1: Create workqueues before device initialization
        https://git.kernel.org/rdma/rdma/c/0d5618c1b2fc9d
[07/13] RDMA/hfi1: Free RX data on late probe failure
        https://git.kernel.org/rdma/rdma/c/8e17e101e04a3d
[08/13] RDMA/hfi1: Allocate device data after PCI initialization
        https://git.kernel.org/rdma/rdma/c/9f674ba674a0d1
[09/13] RDMA/hfi1: Remove redundant NULL checks in create_workqueues()
        https://git.kernel.org/rdma/rdma/c/22113f3f55a1f4
[10/13] RDMA/hfi1: Stop flushing the global IB workqueue
        https://git.kernel.org/rdma/rdma/c/d43b1c17f9e1b9
[11/13] RDMA/hfi1: Defer device creation until probe succeeds
        https://git.kernel.org/rdma/rdma/c/9bab31776ae60a
[12/13] RDMA/hfi1: Initialize debugfs after probe completes
        https://git.kernel.org/rdma/rdma/c/bb18740b302f6f
[13/13] RDMA/hfi1: Align probe error unwinding with device removal
        https://git.kernel.org/rdma/rdma/c/e26c48cf23a494

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

