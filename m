Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F312C3B19B7;
	Thu, 16 Jul 2026 08:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190082; cv=none; b=XKM6Ic9BSHU7D1PHbsM3kYAd445FF18oxmJkt6Tun01SHniQB9RHA4JiQ9DI0C2EsGd0SwVLSXFIsiA5zh1fLln17agKsHtmB4iVsenBNOr123Y/Ss9VkN4A5J0/o6SWyoPfliL98bz/B0i4X4820MrMdd7upMvuLK4NOWPocrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190082; c=relaxed/simple;
	bh=PDfri8wa717gTXI3Hdd3xp/ZmvF6HLJ8rN2mfoj6idc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rGCCUiBdryPvxYrqy9XfsVuEHyQJzkRej0/Z5it9Bibj/VrYMRd26NX0/2Y4v3+A6v+WuW6H8o+l169mKPNhIW+TfoQl8gSmM1SCsB1PsDZs5whJ9lnmSnU+QDqloa9E3qlG0QFjePixSLmXmiScQ5VAHI3tTPHWy57opPDw9f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1795F1F000E9;
	Thu, 16 Jul 2026 08:21:21 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Potnuri Bharat Teja <bharat@chelsio.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Cheng Xu <chengyou@linux.alibaba.com>, 
 Kai Shen <kaishen@linux.alibaba.com>, 
 Chengchang Tang <tangchengchang@huawei.com>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, 
 Abhijit Gangurde <abhijit.gangurde@amd.com>, 
 Allen Hubbe <allen.hubbe@amd.com>, 
 Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
 Long Li <longli@microsoft.com>, 
 Konstantin Taranov <kotaranov@microsoft.com>, 
 Selvin Xavier <selvin.xavier@broadcom.com>, 
 Michal Kalderon <mkalderon@marvell.com>, 
 Nelson Escobar <neescoba@cisco.com>, Satish Kharat <satishkh@cisco.com>, 
 Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Zhu Yanjun <zyjzyj2000@gmail.com>, 
 Bernard Metzler <bernard.metzler@linux.dev>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org
In-Reply-To: <20260714-convert-to-noio-udata-v1-1-f1f6b6c7c988@nvidia.com>
References: <20260714-convert-to-noio-udata-v1-1-f1f6b6c7c988@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA: Use ib_no_udata_io() in query_device
 callbacks
Message-Id: <178419007897.294005.10803717095218159202.b4-ty@nvidia.com>
Date: Thu, 16 Jul 2026 04:21:18 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 14 Jul 2026 14:46:58 +0300, Leon Romanovsky wrote:
> The query_device callbacks that neither accept driver-specific input nor
> return a driver-specific response open-code the empty udata handling as
> ib_is_udata_in_empty() on entry and ib_respond_empty_udata() on exit.
> 
> ib_no_udata_io() already combines both steps, so replace the entry check
> with it and simply return 0 on success.
> 
> [...]

Applied, thanks!

[1/1] RDMA: Use ib_no_udata_io() in query_device callbacks
      https://git.kernel.org/rdma/rdma/c/b12985a0473a2f

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

