Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFB347CC79;
	Thu, 10 Sep 2026 11:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789041503; cv=none; b=h8V1Ycfp25+MA/kcvYJd4IqLx28vZ8dTr0amuiWLkMGXk2awo2Z/iVvHT/OZXxnkVQ1VOVz5WPoEmT2gmxB9BS21X+sXPlxCFvuwPJhLXyUZT4LJCahnmsk4SX08NaJaviAZoS6LETraWNbIU+wTE+WJB1LHX3BiNRlVjLUr+Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789041503; c=relaxed/simple;
	bh=YTFGlPlrDECiGTAWFeOmQn02vNSNP3ERwjFC+0jkU0o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CPPfDAg8RUacTmTd7W+GGfZur22QqnH3Umkg0twu8XqLoNmWMsrl1msJPcbu/cT9eGvRwAKEciKULUswUfPvaPclHRHU5NvhQz+gJuO8DV3xN2deKKS/G3BYvO0IaWPth3uWKFJq15NR+XlDRSkzk+OfDqHpCcPY7oqwavRFUF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovC5jRBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovC5jRBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741681F000FF;
	Thu, 10 Sep 2026 11:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789041502;
	bh=J9KODXrzVn+q5+zeDgQ2UJV+1E8E2Vt0KzbTJaiEqZo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ovC5jRBAlgkmRSYCaTYR4kohZF9yn9mDNWZPWJwslJRMGN02GM2u02XO+rfpjbiDY
	 ZO4lLPJ+8eEsGQNGYnlqq/mshRIRy0W1ea+6VLkdABXTjFxQAFZaZ4Q1+fXJSXSEjA
	 xHINAVpX+yxLLEEWjJgNqn0qvutEI0yYQbTIgkKwB+PyVAPGtUMX8kvNk5KhfWtWcQ
	 Hj5OgNe92sfcAafcizpRZ2do3fJZFVzFgkD6Afs/pPn362IQfUs6E9E+8cDTkIRvQd
	 Z2lGYUV3cc1rCcuZRMXtMj26ORDYG5A3y9KLeoIbW32JNk2peRAjmlCDxSZz5l8J04
	 EjYBGrOH5dyEw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Potnuri Bharat Teja <bharat@chelsio.com>, 
 Cheng Xu <chengyou@linux.alibaba.com>, Kai Shen <kaishen@linux.alibaba.com>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Yishai Hadas <yishaih@nvidia.com>, Michal Kalderon <mkalderon@marvell.com>, 
 Nelson Escobar <neescoba@cisco.com>, Satish Kharat <satishkh@cisco.com>, 
 Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>, 
 Bart Van Assche <bvanassche@acm.org>, 
 Hemanth Selam <hemanth.selam@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 target-devel@vger.kernel.org
In-Reply-To: <20260907065047.26773-1-hemanth.selam@gmail.com>
References: <20260907065047.26773-1-hemanth.selam@gmail.com>
Subject: Re: [PATCH 0/2] RDMA: fix typos and repeated words in comments
Message-Id: <178904149905.248658.18345796995321363381.b4-ty@kernel.org>
Date: Thu, 10 Sep 2026 07:58:19 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 07 Sep 2026 12:20:45 +0530, Hemanth Selam wrote:
> This corrects 2 misspellings and repeated words in comments.  Each is a
> separate patch so that any one of them can be dropped without touching
> the rest.
> 
> Nothing outside comments changes.  Every touched C file was checked by
> dropping its comments, replacing each string literal with a placeholder
> and collapsing whitespace; what remained was identical before and after,
> so the compiled code cannot differ.
> 
> [...]

Applied, thanks!

[1/2] RDMA: fix typos in comments
      https://git.kernel.org/rdma/rdma/c/ea42dc09368112
[2/2] RDMA: fix repeated words in comments
      https://git.kernel.org/rdma/rdma/c/3e1de7f906ab16

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

