Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5252949CF27;
	Wed,  2 Sep 2026 13:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788354512; cv=none; b=fUHUF9Ts17ULYuo8CgB1wIw2zT8Su+/3dO1SBINLm+F72hUdqoOS1Ud4iJjbUopf9CHj6Oh6Hb+VnBySrsDVUXAxiImZ9a2KTa/lOT05eFrQUu2EfVjlrQzYbaoieY2BjTj6KIM04edexMOXdcFgHQM7It38EZ0s05dsIbrGKLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788354512; c=relaxed/simple;
	bh=hDfw++Yhn0BDbmpuPVrGaSwYu+O34nwiRlNy8JPAQOs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JoJp8x2Ku+yu+bTGrHlgUyN6cEcxBhDH0lng73wMRbhbCI/RaZ0Fw/G0n9AmwNjiwk5AdZIt+yPC+MZn5q4TmtFUR64UqZNnUoMK4p+jtPWiLXCtYVOyT+OGf8yrZB6H5R7iVvRkdaYf4ygVpdL2PAcMKVz7t2vd3eMcMi8JULo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QsCCYU+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QsCCYU+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5026F1F00A3A;
	Wed,  2 Sep 2026 13:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788354510;
	bh=j8jVCcfHhRtnvpyntKncOoP28nizl/2B7K7wsFDmLTI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=QsCCYU+KXi/ewerc29BuAQgwxCN3K7GsjZ7VOvbqVKd7xZK63eWbUWVnRWRHcfqcY
	 mifeTzBq9/lsaG1JKRWDuh101LhJTc+7SO5lICg7CxMNsT8RnsVgVcthxHkX0P6T8P
	 l6CBoYOApCEMJUHxbz2CBSWBrHAcEsm4a90YelfWzvgKRGFX3Zu2IUVRM+7RduRSMx
	 hibmhmN3BjS9o4I3c5JhrUO47ViIUyA2xazRR4fZCFXJVKcAn23jIKOEYqN2tPbmKP
	 Wm+0mKDvzpEtgNXNW01g9Rd53cCiQtnfXfvjXb3ehI5tb8Rof8KFkwuXFfHSuo2DbR
	 ADlqVtYKlRHBQ==
From: Leon Romanovsky <leon@kernel.org>
To: sagi@grimberg.me, Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: mgurtovoy@nvidia.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dledford@redhat.com, stable@vger.kernel.org
In-Reply-To: <20260819010804.641772-1-yhlee@isslab.korea.ac.kr>
References: <20260819010804.641772-1-yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v2] IB/iser: reject a remote invalidation of an
 unregistered direction
Message-Id: <178835450799.2446246.11189014413093899123.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 09:08:27 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 19 Aug 2026 10:08:04 +0900, Yehyeong Lee wrote:
> A write command whose data is sent entirely as immediate data is not
> registered.  iser_reg_mem_fastreg() takes the DMA key path and leaves
> rdma_reg[ISER_DIR_OUT].desc at NULL, while iser_dma_map_task_data() has
> already set dir[ISER_DIR_OUT].
> 
> iser_check_remote_inv() looks at dir[] alone and hands the descriptor to
> iser_inv_desc(), which reads desc->sig_protected.  A target that answers
> such a command with IB_WR_SEND_WITH_INV faults the initiator.
> Leaving those commands unregistered is deliberate.
> 
> [...]

Applied, thanks!

[1/1] IB/iser: reject a remote invalidation of an unregistered direction
      https://git.kernel.org/rdma/rdma/c/d85f0f0a7c8575

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

