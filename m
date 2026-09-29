Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967E447989C
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 08:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790671378; cv=none; b=BN5Jjmscnnm1udIHKF0ZS1IggFUar21Q+5UGKVAiSLZWpn9uV5MONrXJ5BQuzHwC6njwB5tr5pML5PKkSsBnr2jtFzlOfmVGk98I9JT/y61zHQ5pjKU9/YkQuByv7zEMPOpn86e3D7ZXsYiakZ51XrlDgP5Glkm2r1cnxe3B2mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790671378; c=relaxed/simple;
	bh=thCyARqgvKnSpcwE9gYWJ2U8hG2fNz7fC4aoTjbiwzw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=spARqli4bFwnvKEtXy3WYrO+TK4ADdoRgHpgX3jjXdWHQ9x/2qRVPHbbJca1aHKZRFUZzSCFnxrmgyj3JBSyPmLDmZdd/smnfx2XV91IHO67IPZvaotPjPkTFOHV1dowMFezrqpKNDk1nrfGrksyms8OxZ8ymanpZ8c6HmZTyJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DyR7G3Eg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyR7G3Eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F691F00893;
	Tue, 29 Sep 2026 08:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790671377;
	bh=FqsrMWbejy7D0Jled24tyEmQbh79LqvIj9rWTmJKJV0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DyR7G3EgGXMnmgvy/hoiAWWm5KxovFgBdFSMcfcKPvi6dlJqQg3hmRxt9OPZxiG++
	 PykZ8EVCBIPSKzIBxlbPdC5TYszQvJwfetO5IhwQXZ8la5nl4BNnxVnuCG3Q7IMwXi
	 TBzL7YGimBvBf7rt5QFlU+xLo9yj1aASatrNU4RjhJ/GkLpCNgZl92p0Lv4zfkWFFK
	 GENRNdeocZz00bLC9oTLc4W//7QATb79CRmTZ0PUKtuJ1dcsPH1gvpeQwT+K6FlZp1
	 Mkxuzhx+v3bJ/6GSKJQ/GViEqUfCoJWmzuSnYaLHAQzV8PIpZk6MshSefU39SNqOFL
	 e/8IIKWAq3+7Q==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Selvin Xavier <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
 kalesh-anakkur.purayil@broadcom.com
In-Reply-To: <20260922061230.7909-1-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
Subject: Re: (subset) [PATCH for-rc v3 0/8] RDMA/bnxt_re: Fix input
 validation and
Message-Id: <179067137429.3959946.13780719533408568536.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 04:42:54 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 21 Sep 2026 23:12:22 -0700, Selvin Xavier wrote:
> This series fixes some of the bugs found while auditing bnxt_re's
> handling of user-supplied values and some generic bug fixes
> 
> Please review and apply the series.
> 
> Thanks,
> Selvin Xavier
> 
> [...]

Applied, thanks!

[1/8] RDMA/bnxt_re: Fix integer overflow in send payload size computation
      https://git.kernel.org/rdma/rdma/c/3483cbbd748716
[2/8] RDMA/bnxt_re: Detect wrong sge_len passed for inline
      https://git.kernel.org/rdma/rdma/c/81551ece0864c3
[3/8] RDMA/bnxt_re: Validate SRQ max_sge at create time
      https://git.kernel.org/rdma/rdma/c/1894ed9a664d19
[4/8] RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
      https://git.kernel.org/rdma/rdma/c/4d8168a3b7c933
[6/8] RDMA/bnxt_re: Serialize dcb_wq access against async notifier
      https://git.kernel.org/rdma/rdma/c/81caf9240dfb08
[7/8] RDMA/bnxt_re: Fix the PD and DPI table size
      https://git.kernel.org/rdma/rdma/c/aa6c2ef821a6ba
[8/8] RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
      https://git.kernel.org/rdma/rdma/c/7cc8ccb157a476

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

