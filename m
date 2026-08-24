Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B285368D79;
	Mon, 24 Aug 2026 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787567427; cv=none; b=YNkTOnGhnZTRq1kXOph9SA3eMV3PtTncC4pNpO/2QQwHcWH1a7XgmL4AMyJCt/agOUVKMaF1K1q9Xj226Tep4rgqSDQwYAuKPxq2+CZnOSUXFTBNiifRQe20qdIav2+HQr8l5+ISuQtvWiMbKx6P1JLMIPCo5/tx2yYiVDj41DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787567427; c=relaxed/simple;
	bh=wycIIvwXZRxYCgpRVJZz3RmffOZL//Gi0OydGD24uMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DY2Dm6nwM7WAYnawkFFyi5O6fKe2h+yykUiQMdufbAFlCs/u2NrGTSm290LciyPozvkUqz5m9cyIx1mFpluZU+w848SUGodNY5HKO7M0IZc2xw/SdwfVU0N0safZsxUuPWlo0uuhxd5/hhUDww5YUYehahOj977lTyxLJ0dZwEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXNXJE30; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXNXJE30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D36F1F000E9;
	Mon, 24 Aug 2026 10:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787567425;
	bh=YTJx4dBRZAybNR3HI9pgVr2GlnnH8dp6QvB0gcnDMNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MXNXJE30qWUtcm1NT8yEay24jDlVuNDHRTUdAj5/W9cVv41rPFfmbAxom10H4mxdt
	 P6kZsPEFe26zd3EhXOSOMXtRElSohFaOu2q74SzHUGIq//2PrtlaVfNzRLR7p8eRc1
	 vJYYEsit0BTmM+PYbc6/ZLLH2/guLaWEHbv4/LduGpwS8NF/lp2nuzeQKGPCkvGe+t
	 HnD4AdNDUYsXXz/tqwLOn/Jz7Eo1M/grJNEny0kYXZKLk8deUUo/1OemVnX1xO2pBk
	 72C7xQkOebsUoITNaW8B0LpYQpygVlp9FBGIBzkQQDBNR2xKhqlyGmfbx0FzVyMFpQ
	 CJBtDxWoLnqmA==
Date: Mon, 24 Aug 2026 11:30:20 +0100
From: Simon Horman <horms@kernel.org>
To: Hidayath Khan <hidayath@linux.ibm.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com, mjambigi@linux.ibm.com,
	andrew+netdev@lunn.ch, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, pasic@linux.ibm.com,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net/smc: fix use-after-free in
 smc_rx_pipe_buf_release()
Message-ID: <20260824103020.GN265046@horms.kernel.org>
References: <20260820074642.966856-1-hidayath@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820074642.966856-1-hidayath@linux.ibm.com>

On Thu, Aug 20, 2026 at 09:46:40AM +0200, Hidayath Khan wrote:
> smc_rx_pipe_buf_release() tests sk_state before taking the socket lock
> and then dereferences conn->rmb_desc and conn->lgr. A concurrent close
> runs smc_conn_free() in between, which releases those structures. On the
> is_reg_err path smcr_buf_unuse() frees the descriptor outright, so this
> is a use-after-free.
> 
> Patch 2/2 fixes this by taking the socket lock first and testing
> conn->freed instead. smc_conn_free() sets that flag before releasing
> anything, under the same lock, so the two paths exclude each other.
> 
> Patch 1/2 is a prerequisite. conn->freed shares a byte with killed and
> out_of_sync as single-bit bitfields. out_of_sync is written from the
> receive tasklet without the socket lock, so a concurrent store to freed
> from process context can be lost in the read-modify-write. Patch 1/2
> gives each flag its own byte so stores do not interfere.
> 
> Hidayath Khan (2):
>   net/smc: stop killed, freed and out_of_sync sharing a byte
>   net/smc: fix use-after-free in smc_rx_pipe_buf_release()
> 
>  net/smc/smc.h    |  6 +++---
>  net/smc/smc_rx.c | 11 +++++------
>  2 files changed, 8 insertions(+), 9 deletions(-)
> 
> ---
> v2:
> - Patch 1/2 is new. It is a prerequisite for 2/2.
> - Patch 2/2 replaces the conn->rmb_desc = NULL approach from v1 with a
>   conn->freed check. The NULL store exposed smc_cdc_msg_recv_action()
>   and the sock_diag dump to NULL dereferences on paths that do not take
>   the socket lock.

Thanks for the updates.

The AI-generated reviews provided by sashiko-bot elsewhere in this
thread appear to relate to pre-existing issues that I don't believe
should impact the progress of this patch.

For the series:
Reviewed-by: Simon Horman <horms@kernel.org>

