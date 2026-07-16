Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB8C36A35E;
	Thu, 16 Jul 2026 08:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189693; cv=none; b=ltojfrBncnIvb5104U0GoWYUfTftVuYhrh7SBNhKoT/tZPyqQj/0DYEtslum0Qu5WwHcIKp0/kV/m2vjidlBvdrvMi/KBM2vcglvUFtmTyLUcoVP4Ol76L9fIhqnyqxvftdTOc7S66pYnI3w3L9oYrAoKmFIBfePrxsgKVv4RKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189693; c=relaxed/simple;
	bh=xMKLbxoXbiSMN93OZJREQZWfSoBNVu+2fP1AmmGIPdc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=PCvsmjtzTg8jhqj8NYgHIc4zGxCK49u01PgaFI7EhdUIHTodMM7sxQyl26zychqvLsMECad3PURlCOoplSEF+ACCveqlDwf4bH6Tk5FA5cz9VWqgIccgwL8jYCyiZNbuqji+a9oOohnzuqR8EmLZjQQPQAipfSUgYa1Wd8H2c3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m2qNJD/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m2qNJD/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF351F000E9;
	Thu, 16 Jul 2026 08:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784189691;
	bh=3xvLhZ62q4UBFVJefz5H0ZulY0OWRK1se7WHbBOAJmg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=m2qNJD/AwdKxRarZYYDBDVhu3FW+l9S1mmY+96ztJNi/HzYmTBXlsJ/5dIOLyEu0u
	 4YiHyWxoifr47b0YO6WpsZJTHknJo5Co6XIdthXaF4RSG/uHbmkk+iLmIqCXU+YFCC
	 MVXiwrSSDv2zpy+hq5rJl/cPRr24+Y0oZnFefBZV+VgVrUdGq13VfaF5adem2IX4Ik
	 ORgN8K+UsUIqn9EG1elhhR6f2jRjxRqNq3sI5i0Pym3kYuLjjfYDMn2SryCpjv0XHp
	 TJtnrDSxVeKWPNbePZ8+U15vsvR9RUQtcOdF79Pzl2uCPu8UqHCcHvHHPgbtZqDVWF
	 v2oZI4xjloM8g==
From: Leon Romanovsky <leon@kernel.org>
To: yanjun.zhu@linux.dev, zyjzyj2000@gmail.com, jgg@ziepe.ca, 
 Ibrahim Hashimov <security@auditcode.ai>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260712122149.78142-1-security@auditcode.ai>
References: <20260712122149.78142-1-security@auditcode.ai>
Subject: Re: [PATCH v3] RDMA/rxe: validate num_sge/cur_sge before indexing
 wqe->dma.sge[]
Message-Id: <178418968916.292019.3894446972943123322.b4-ty@kernel.org>
Date: Thu, 16 Jul 2026 04:14:49 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 12 Jul 2026 14:21:49 +0200, Ibrahim Hashimov wrote:
> For a user QP, qp->sq.queue is a ring the application writes directly,
> so rxe_post_send() takes the is_user branch and only schedules send_task
> without validating the WQE. rxe_requester() consumes it in place via
> req_next_wqe() and calls copy_data(), which indexes
> &wqe->dma.sge[cur_sge] with the attacker-controlled num_sge/cur_sge.
> Only the kernel path bounds num_sge (validate_send_wr()); the user WQE
> is never checked, so a local unprivileged user can post a WQE with an
> out-of-range cur_sge or oversized num_sge and force an out-of-bounds
> read of the per-WQE sge array in copy_data() (vmalloc OOB read, local
> DoS).
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: validate num_sge/cur_sge before indexing wqe->dma.sge[]
      https://git.kernel.org/rdma/rdma/c/59d3005eb36f37

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

