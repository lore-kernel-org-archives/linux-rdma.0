Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E06A3C5552
	for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 08:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104877; cv=none; b=cAjfPpm1w3NgR4ltJikuWcJSAxmGsrxSQsY/rLl0esKDRSp0p3jSBijCS6PxWH+aCNw+AV8S0Trw5rBa4tLnht9g6OjgxaaILAzlvMyXtpJ5HLJ1+c+SxaPy4lePjw/XgMi9RvSHMCZb2N1dXpUrsP7z/+2fg84UKx5y93fCxhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104877; c=relaxed/simple;
	bh=ccCCmlK/3XMCUipwXR6/Bjo1pCrl333P5WWuqCqM+5M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=V3GZu2v0y5RwPEwIGm9jM0sU5+SjVb/jhEBs0Q5L6KjC9qncOsk1R92SB/U7dzvDcaCoOgMuL5S/Z2Q0SzAJqAHtS558KKOGyk9KIHJc3eAwD2UNLDlJYtbhPnRNpxFKPOlPyPgH7sYUV8b10MCe3QBviZHjONMc9WXYhZsW/x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YH7veHY5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YH7veHY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8641F1F000E9;
	Wed, 15 Jul 2026 08:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784104875;
	bh=QlI5Gge9cXOPSCp8EEvtBsmxoyswpIxAlbJ1kgGzSZI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=YH7veHY5KPTbsSUL2NIpcyg6nQJYGLh4zg4pW8/BmLgBPdXtT1qIyDBhdr4cjnwaM
	 kud60APyYkiJo3/rLI2sFuBd0PHt/Jc9cDVPSWc3R8+mwmCzsJrtJEJIaf4+u2JzMd
	 lqbRE5IAMWHZhtgJKJLxq/ToYRVSQhfL5wx0H0OAWV2u7QL+xofEDDe4eFCwOPUeFb
	 5QPIlNhZpl1uF8gu5JrHjyChlyDzDsP3TgEtLoF6u/sZ+5YsME9XJu5JiMzsVM97Tv
	 5mywyvKp1er5/1XG9GW4kdGeVBurH2wbRCIDbqNCqQOoCYEupZp6avp7Vw+f5sdHnn
	 u6X3jkIFJvMqA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, weimin xiong <15927021679@163.com>
Cc: jgg@ziepe.ca, xiongweimin <xiongweimin@kylinos.cn>
In-Reply-To: <20260714024429.188276-1-15927021679@163.com>
References: <20260714024429.188276-1-15927021679@163.com>
Subject: Re: [PATCH] RDMA/addr: fix spelling of guarantees in comment
Message-Id: <178410487316.139394.7960269642151273540.b4-ty@kernel.org>
Date: Wed, 15 Jul 2026 04:41:13 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 14 Jul 2026 10:44:29 +0800, weimin xiong wrote:
> Correct "guarentees" to "guarantees" when describing work cancel.

Applied, thanks!

[1/1] RDMA/addr: fix spelling of guarantees in comment
      https://git.kernel.org/rdma/rdma/c/21680554a8d1c5

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

