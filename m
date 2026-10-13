Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E834FD260
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904283; cv=none; b=uM/PvRyluiNqWZBFdKQwmK2XYSIGDe8d47gMK1Bky10rkMD6pdk4A+qc4YbTvRm/34GjFoZ0kYr0RhhB+LiR+8dXZ4kRwU52KN/w70i3lBCpDnYzKGf5K2CfIfMaWBDkyigDIiG826N2hYAl1fE5pxF/h5UtFRwf9msqLFA3ot0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904283; c=relaxed/simple;
	bh=vnlMf9Jk+33aB1ozPyFN72DsA6LAh/mex0Tc/JnLPyc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=N16+mlm2F5khog8G0EggT26lATlG2LJc8+3QSlRN7uzK7l3lJoyXtEhyV3ZlXlSBF6FkbqHdCpVugm82bz1ndA4kGE1rpHyPGhMrz8Cmjm3LcH3AlyccA4g2zMjGAXSxIuwVE+wUWqUFuRo0q8VJrq+jaknhKZyk9Sf5f1Bhm9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7hGhX0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7hGhX0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482271F00893;
	Tue, 13 Oct 2026 15:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904282;
	bh=6Z4vDFy2g2E3hg35AYxGjfiovuZtC1koQLjnggPix+A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=V7hGhX0kXLFKNsFZOzLNnbBdrCCfpwAVMHHWsgeMxxljj8Z/fGzLD5uyqGGSoog2p
	 aL/+LEmGNaEXZWGd1N3spuK3p+n9S4qA547lgeDuRepFsZogddjyydQjkHwb+N+uHQ
	 njA9ND0oE68fiVMCIwkXiHGRy7cTlRpVSacW4PIsTayTMOCV+fr63PpvwQYqqyuhgX
	 Spx+bKj/K4ZUfZfuPvVGv2rVm0ISKzYgnhWkLcMvv2owXONAoChgFz25N3nFgCwoiq
	 16orwM6zx4qHTEpTGvqcZ63XsD8CPj0SF72hW09AI0TQoQj+IbE8N/kTRLN4Z45VuG
	 UdKkckbqytLGQ==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Selvin Xavier <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
 kalesh-anakkur.purayil@broadcom.com
In-Reply-To: <20261013140427.256612-1-selvin.xavier@broadcom.com>
References: <20261013140427.256612-1-selvin.xavier@broadcom.com>
Subject: Re: [PATCH for-rc 0/2] RDMA/bnxt_re: Fix QP table fixes
Message-Id: <179190427976.2663571.14600069805639517297.b4-ty@kernel.org>
Date: Tue, 13 Oct 2026 11:11:19 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 13 Oct 2026 07:04:25 -0700, Selvin Xavier wrote:
> This series fixes couple issues with the QP table
> allocation/teardown.
> 
> Please review and apply
> 
> Thanks,
> Selvin Xavier
> 
> [...]

Applied, thanks!

[1/2] RDMA/bnxt_re: Use kvzalloc for QP table allocation
      https://git.kernel.org/rdma/rdma/c/724a39b36af947
[2/2] RDMA/bnxt_re: Unpublish QP table before freeing it
      https://git.kernel.org/rdma/rdma/c/978361dd2ccff3

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

