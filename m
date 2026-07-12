Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CDA36AB57;
	Sun, 12 Jul 2026 08:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783845999; cv=none; b=eB9kGpkzsN03u5rYaeFeAusAwZcriS2hOVxXATYABaxBVq6IH/9DNEn5hRvrIoMMFQo636kRF7AT8e138egs7Kg8XSdza0KT81kjvMzJ14DTTHFDk4I/vgWvx1RvutwCnxryosdRs31JIhxEka86Ok93BXFht34CQnC5Y2ebweI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783845999; c=relaxed/simple;
	bh=s/D5ODUCcEVFL7Mv0J9bDQXbSLS8gri2bhQa0Sii7OQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EsjkLRXFdn8TcX4PSfERP5QHwu7pEGnEIJbIKnoiKAEyPswWEuPfedpphbtrjqSSCFCEHAIYv5/7tXz2NBCCyZ37qw72E3MbeTxFZUdytwH8WSfIJ064tc/ODyFUhN0GMTR8KPJyCoqCrNGo6JAwvVj8FkgNigI8AXgrCDFeV9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUV+uqrx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUV+uqrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5571F000E9;
	Sun, 12 Jul 2026 08:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783845997;
	bh=Skc1WU+sxzEwPxc4ZKXCXZ76mJvgp8T0D9xNMu6R2Q8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=QUV+uqrxLx4KakZkC00niXBxE4pXe6KUfkG0m9GDlQYlckDPk4zRwcD+fr65MtUi2
	 ArQ8+EQiM1OCoAjDV0heYV7WVB+UP3ZQzomyQerOAI6XksGFJjHzJV4htWsxdIkz63
	 UauWBteMB9y6032pXziMrfiD2jjenlbGvbEWyqyQjkWNPMVPGifOHce3Hkmy9k3CDy
	 7uRz9Qyx9/JNMRypa8Al8T6dbSdiDinwpkunZq1WHFdEXljVE+lF1NHgG+/1tbdyxe
	 tuXaUtw6pekdc55BQpFYlYTJaaq/OSmpu4HwPoCbuFetr6liQDSFWJ326meUb2T+/n
	 p77Ewe91uGHiA==
From: Leon Romanovsky <leon@kernel.org>
To: xuhaoyue1@hisilicon.com, Alexander.Chesnokov@kaspersky.com
Cc: David Laight <david.laight.linux@gmail.com>, 
 lvc-project@linuxtesting.org, Oleg.Kazakov@kaspersky.com, 
 Pavel.Zhigulin@kaspersky.com, Wenpeng Liang <liangwenpeng@huawei.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Xi Wang <wangxi11@huawei.com>, 
 Weihang Li <liweihang@huawei.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260709050327.3547237-1-Alexander.Chesnokov@kaspersky.com>
References: <20260709050327.3547237-1-Alexander.Chesnokov@kaspersky.com>
Subject: Re: [PATCH v3] RDMA/hns: Compute HEM index in 64-bit in
 hns_roce_v2_set_hem()
Message-Id: <178384599488.1550388.5775639238568762415.b4-ty@kernel.org>
Date: Sun, 12 Jul 2026 04:46:34 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 09 Jul 2026 08:03:27 +0300, Alexander.Chesnokov@kaspersky.com wrote:
> In hns_roce_v2_set_hem() the HEM address indices are computed from
> i, j and k (the base-chunk_ba_num decomposition of the 32-bit
> table_idx) in 32-bit arithmetic and then assigned to u64 fields.
> The recombined value always equals table_idx and cannot exceed
> U32_MAX, so this is not a reachable overflow and has no user-visible
> impact. Declare i, j and k as u64 so the calculation is done in
> 64-bit and the pattern no longer trips static analyzers.
> 
> [...]

Applied, thanks!

[1/1] RDMA/hns: Compute HEM index in 64-bit in hns_roce_v2_set_hem()
      https://git.kernel.org/rdma/rdma/c/923e1cb4e525bb

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

