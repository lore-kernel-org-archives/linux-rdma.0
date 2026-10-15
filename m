Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBCD305667
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 13:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792071174; cv=none; b=kLPy33nq1jkd0GxoJIA4lBNkiHD2/Le75Qh54LFxbSMlnRGFMdYnjWxU+6s+5HtfZnWkXMruyJWvkZXPZWiGkW3jJKlZ0pCtZVZw8jGhJGlCTbsQ0g4Tk8tUBZSAT+7mwiOkUsY+M7ze0fBub5uJQZGTrZ3Eb08aia5tuMykWjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792071174; c=relaxed/simple;
	bh=EWnEG5EwhcBbwnataeRKWTEGwmi2NElBv+OIfnk0aek=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ivu8mYEvS07YVA9+iVVI7aL6wGgVNK3HUSAXO+PNWuPiRlpQjpoY1Q2QiSlcuMpMWPU9xw9GJ7PL6jc34JjX55FZrXJGSCRHnncpDiy/dysrQOGlkMzIbJYos1Q36hP/FxgiUnQ4i1U/bUmuFGaI2pXUf2PhLDRYQeG7mNyKmJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=FrIc6Wcc; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="FrIc6Wcc"
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 5AFD321713;
	Thu, 15 Oct 2026 16:32:51 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=EWnEG5EwhcBbwnataeRK
	WTEGwmi2NElBv+OIfnk0aek=; b=FrIc6WccYFnZaPoCeLrd7E3N5omc52NZxnNM
	rR+9UCl0DwuGx9+LFL9OoiRSBEVdokVbfc0n+GcNiYtl7c/6vyoGgYvUaVjFJ5TZ
	CRJx4cXGf1cImVwZyARZNTDCsxSPQ7YnSYkV2BXKNaPezMObmWtb/j+urP1d2d96
	RX0G4QjTVKmNmwkqmEDNm14OIFRliO8DMRk5UQBduMRJdb+XDQclMc1J1dJ5niy4
	ZA8AatmITh1wGmCHwAoDsMp28diWMAbzxeIA1El0Yxx/G/rzSbv9DOhy7UqEtsPH
	Uo4H4KX5eotnFPYlh5g5koO0ZE+Lnd8RY6B/tS+kbGgJ9xiOmQ==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id D94BF21692;
	Thu, 15 Oct 2026 16:32:49 +0300 (EEST)
Received: from [10.89.11.73] (10.57.8.14) by VTJ-MX.corp.irix.systems
 (2a02:2f04:1:9c24::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 16:32:49 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: <linux-rdma@vger.kernel.org>
CC: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<sashiko-reviews@lists.linux.dev>
Subject: Re: [PATCH RFC 1/3] IB/iser: Post header-only PDUs inline
Date: Thu, 15 Oct 2026 16:32:43 +0300
Message-ID: <20261015163243.3011667-1-me@andrei-z.com>
In-Reply-To: <sashiko-outbox-172888@kernel.org>
References: <20261015125118.2966247-1-me@andrei-z.com>
 <20261015125118.2966247-2-me@andrei-z.com>
 <sashiko-outbox-172888@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

On Thu, Oct 15, 2026, sashiko-bot@kernel.org wrote:
> Does freeing tx_desc without calling ib_dma_unmap_single() cause a permanent
> leak of the IOMMU DMA mapping?

The error path the review points at predates this patch. The patch
only changes how iser_post_send() fills tx_sg[0] and the send flags;
iser_send_data_out() and iser_initialize_task_headers() are as on
rdma for-next. A Data-Out PDU has two SGEs, so it is never posted
inline, and every unmap uses tx_desc->dma_addr, which the patch does
not touch.

The leak looks real, though: once iser_initialize_task_headers() has
mapped the headers, the offset check and a failed post both free
tx_desc without unmapping it. I can send a separate fix for that.

