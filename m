Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A4438E8C1;
	Thu, 16 Jul 2026 07:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784185918; cv=none; b=qfB+5SzLKb1BSCYaKlSs22wjzK7sE9fICOOJoDY5FGcVyim2mQwP+r2+QYGJDSI5k9M8rxs4xh8yr54X+0FpjoZNuXJhLszoLBqCDIOzwjWCbVw2ZlDZVU6DxJmyTj6172Pq3IF/b9QopxM+HSQEU9VHOcRl+zgBeyEkWLa8gnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784185918; c=relaxed/simple;
	bh=gHB4cwjWuw4RQO9MWL538HI4Gp5/Ea1AiDWgZ/nJlxk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JFqJDkiPpQmDoxXs4KgYZDxyF/YsdJnsEmpKbjvRijQQBBxxQVwRSjYB5DGtSh92H2f1kqxkqJTdJCA21byhipOaK38Bz0AxttOt10H85NaTihMFEqx8OHSTsOnmr1aNnVBwo0Su12KobeVjkHgo8NoJYiEW0FFf6SWhQ9YuvKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OyjjPz1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyjjPz1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CC41F000E9;
	Thu, 16 Jul 2026 07:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784185905;
	bh=bxibVpQCVwq1RhtAWgGQrp2hj35CKJEIEEXNEqUoUl4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OyjjPz1r1hSYgETc4lN1y8XmEK7GEiHpn8JXxJXpPll7bzWJQyE3f1PvSw64VmEr6
	 xRSCCaDTH2MBpesV7SPi29jfCNLSPZFkM0BAbiiPdAiGhPW2EA3gEhqF8qOTmtOXDB
	 KtcPP3k7I8YdDaYNWH6zUoZcZLVY6D0J/k3eNdgB7qgSXDaTYmKdGYz9g9GGYhAxfX
	 5U5rtlAFnGNwUUV7KhuZWWlIIvkJll9qOSRW3v+M4sGDzK81F6g6hZqLP6dexQEhYW
	 a0qK7WOCWdVHgtcimh978wz5ItUbB2O9NmylIsuAUreA3g7+bOcMH1cqlh7HNwzjiS
	 fGue25HM+lpiw==
From: Leon Romanovsky <leon@kernel.org>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Danila Chernetsov <listdansp@mail.ru>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
In-Reply-To: <20260708162252.936634-1-listdansp@mail.ru>
References: <20260708162252.936634-1-listdansp@mail.ru>
Subject: Re: [PATCH] RDMA/hfi1: Propagate sdma_txinit_ahg() errors
Message-Id: <178418590247.277990.12835722376225260643.b4-ty@kernel.org>
Date: Thu, 16 Jul 2026 03:11:42 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 08 Jul 2026 16:22:52 +0000, Danila Chernetsov wrote:
> set_txreq_header_ahg() ignores the return value of sdma_txinit_ahg().
> 
> If sdma_txinit_ahg() fails, it returns before initializing tx->txreq.
> However, set_txreq_header_ahg() ignores the error and returns the AHG
> change count, causing the caller to continue processing the request as
> though initialization had succeeded.
> 
> [...]

Applied, thanks!

[1/1] RDMA/hfi1: Propagate sdma_txinit_ahg() errors
      https://git.kernel.org/rdma/rdma/c/56037b376fdb2c

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

