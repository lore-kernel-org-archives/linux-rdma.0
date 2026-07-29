Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF06476060;
	Wed, 29 Jul 2026 11:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325648; cv=none; b=iF4uk4ihT3XlBxWJqfyzA1GrvFqmexrwGo6GIVkRNcHlg6zqnvKOrQEpcLW4u3ceikK3xjdVD6DnCOjSgDG5j9TaK/I6nmhAJ9uSpMXAWjbEqUxDTiOAyYeZSUGNUfzoxBCdWCtaVogeocIeIJgqTHenRJr5YpmWlycIAiws6PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325648; c=relaxed/simple;
	bh=dgDlhzKgsCkF9KIIC9LYNQ1ck2PSjVTujvwa/3BkexA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GuCX3YorSPLDLeiLW993aweTbXgIqUXnGyqkvmP7wNSL0PgpStD1xVSd8FZoFa4YkXflL9prEQW9HwxQ+srUaqOrAwmCeoXdsJgqDmtJB8d7spkpGpt8+rQyvlIS9AkTETR1PFJaweAMLxtmm1l1Qef5ptMYWEn0eIVl52gu0qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B5B1F000E9;
	Wed, 29 Jul 2026 11:47:25 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Potnuri Bharat Teja <bharat@chelsio.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Steve Wise <larrystevenwise@gmail.com>, 
 Roland Dreier <roland@purestorage.com>, Vipul Pandya <vipul@chelsio.com>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260726-leak-of-allocated-stag-idx-in-write-v1-1-72e0c401fc1a@nvidia.com>
References: <20260726-leak-of-allocated-stag-idx-in-write-v1-1-72e0c401fc1a@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/cxgb4: free STAG index when TPT entry
 write fails
Message-Id: <178532564358.1604412.12546416642634388642.b4-ty@nvidia.com>
Date: Wed, 29 Jul 2026 07:47:23 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 26 Jul 2026 15:21:44 +0300, Leon Romanovsky wrote:
> write_tpt_entry() allocates a new STAG index with c4iw_get_resource() and
> bumps stats.stag.cur before programming the entry.  When
> write_adapter_mem() fails, it returns the error without releasing the index
> or reversing the statistic.  No MR is inserted into rhp->mrs, so
> deregistration never reclaims it, leaking the index until device teardown.
> 
> Record whether this call allocated the index and, on a failed write, return
> it to tpt_table and decrement stats.stag.cur.  Key the rollback on both the
> write error and that flag, not the error alone: a non-reset update carries
> a caller-owned STAG that this call did not allocate and must not free.
> 
> [...]

Applied, thanks!

[1/1] RDMA/cxgb4: free STAG index when TPT entry write fails
      https://git.kernel.org/rdma/rdma/c/fdfb5cea4bf070

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

