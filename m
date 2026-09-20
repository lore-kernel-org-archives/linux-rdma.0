Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E26339394;
	Sun, 20 Sep 2026 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789926650; cv=none; b=b9eZKfY3gA3fCxZTKP4+6izDc/69Mr2YK6Nb2Dsr9SeY1x5rMPdQSqXtbKzNgpp8ELmXAhoZHX9tSRscMiIbKlVK5gIWKwNLrSC1ShaP/A2uqxUdbQMzicK3o5rm4qCp6X9URPuod+uNfGMMbtYeuxOF8oRYB24dzarjJ3m7kVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789926650; c=relaxed/simple;
	bh=mj59ENKXR5KWA3PJzdz+69sO1iolJTr2B45za6877GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXSRk4zq0U0x5glI5uEqpkF5s0/L3vk0d+tlwa3M/omTXl7nQmt6Gs00kbec7Ha6PdexEevR54osNNzlLYGrx+ajHAf+275kW5Q2FaOJgGv9V1qSIqrwliH9YZWU20uyokGWtLW+OG0Ac9Gq7aH1CW5vF30yqnDsMptfMhJUfHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UhogGrzW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UhogGrzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70051F000FF;
	Sun, 20 Sep 2026 17:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789926649;
	bh=9tmW/ucMwvEZiXV2cfgvcFzWlrbstD2E6UjaQ8h/DIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhogGrzWxfTiTIDnLn9BRFI/e8jc53mXzu9/bCtgaHarF1BYCvovl3Bm2P1hapdK2
	 Wx8vgizmfdcLYMOWJl/7nBot+SQvjWFiw7dk1tqKUR8nk8N2tIBQfWjfTmGkInCX7M
	 srY5ujrU3zsYWBc7IaGdgjX8qyGKjHiy0SNSiTO/9h8gN/YxYoW7lgFX0q6P+l20yK
	 X+skf1vpURr4vy2eKA//lHLOiGVX06U6GghdJqVoqZCQ7ju8SGXFLWcUJ9Qc/0wzmg
	 0psmL3953uoEErnAu4H9aGiKG/ZupYgE8yoA8u8HwPflxMnPTVjySv9XXYi92L8h94
	 0yoNoetu12qsQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	guangguan.wang@linux.alibaba.com,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Junjie Cao <junjie.cao@intel.com>
Subject: Re: [PATCH 5.15.y] net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg
Date: Sun, 20 Sep 2026 13:50:33 -0400
Message-ID: <2026-09-20-daily-reply-0001-re-net-smc-clc-proposal-5-15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920051336.712097-1-junjie.cao@intel.com>
References: <20260920051336.712097-1-junjie.cao@intel.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> 5.15.y backport of the CVE-2024-49568 fix, requested in the 6.1.y
> thread:

Queued for 5.15, thanks.

-- 
Thanks,
Sasha
