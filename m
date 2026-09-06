Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3D43909A6;
	Sun,  6 Sep 2026 13:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788701629; cv=none; b=DWWdLiDNjYKJP2cQLQtA3b8Xs5Cb2xzwKUtN4NBLDTMQ/RV7TyYYF3NE7PqlTxp4oTTcPSnXKq6dhMS9ohPh8bG92ll2eZjsxFI2XHAN5PRyPy8jSt6MsApZdLKOAvzJb5anAKaArHXPbHYqZ6+4W958lBBlKRFrrFWCsHZ237Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788701629; c=relaxed/simple;
	bh=2WZhZB57d1K2m9gVWJn0KEO59icTlgE+t2afXV1VAAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mp2F4QDc4LcJrAmWk0ppx+WI15+gC3Up3QGrYIOCfQHF9CEu2xMwZr9R9n2WcsHSoFfmRgI8DZFv4h9MwYJAZmzhpmdaoq+UWOIisxbNDFlWr+R5/NpwQhwUm3N3u5ylB3/SDe8ZuoOrvlZYzxr5W5PJEZLGd+Ne9nleHeVyER0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTHi0ooh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTHi0ooh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FD71F00A3E;
	Sun,  6 Sep 2026 13:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788701626;
	bh=Tj7Jl3ZxLT0+qioAQIpvJRIzuFJ8fgK+JWb5INk1ybY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTHi0oohBLuCRTc7pgUrMrp0QdPn9JTtjqeuA7z9mwa137MlcpWmTn1sIAZRJx7Sb
	 oh7nEId/Uj40Cv8hIvTZ2roYVyI4KHguytP1uERptjtxtoFK8aloqANhNQ8dDzXfkt
	 asnHSzjAxESZt62esuM8ShsCkw2tbxVwbttgFFLUrkBVA5EYQpU44OlCf87js6+7pS
	 PNXxHGYNJ6dEdvJW/kI6MnamYI3ZTJcrKUQZRQNMFgbJGOu+AUZqS8ad/XbuafNCU4
	 nDm2a05aTN581urqGPyLvAji17oZTTFwKYHiucOv5T7Wysl0MORNHwrqveQ0dypkf4
	 9jtB+WN2wJIRg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	linux-rdma@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	doebel@amazon.de
Subject: Re: [PATCH 5.15.y] RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
Date: Sun,  6 Sep 2026 09:32:52 -0400
Message-ID: <2026-09-05-daily-reply-0022-rdma-rxe-srq-toctou-5-15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903200645.561393-1-doebel@amazon.de>
References: <20260903200645.561393-1-doebel@amazon.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> get_srq_wqe() reads wqe->dma.num_sge from the shared receive queue
> buffer, which is mapped into userspace. It validates num_sge against
> max_sge, but then re-reads the same field to calculate the memcpy
> size. A concurrent userspace thread can modify num_sge between
> validation and use, causing a heap buffer overflow when copying the

Queued for 5.15, thanks.

-- 
Thanks,
Sasha
