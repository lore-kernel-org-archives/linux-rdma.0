Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7790F3812E9;
	Sun,  5 Jul 2026 14:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783260063; cv=none; b=WhxRzSAHn+29fLwNHOXky6pXxsgCeRvV9UAGCPhOMS2daMDjjNovvRfITmhrxqHQwiNVUbuz5VkhByVhlXWdYWq3inRj2gdQ+pPyQBW+WkXh7lkcy2+H19GFL8Th0+fafZrO1R0CfXb0P3Ws58vDbvtSeja3ISsXFhbVV+fN3X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783260063; c=relaxed/simple;
	bh=DlyPBYJlINz7Lg8Mbj8wUArRC1mmNai5tqxowcuOqns=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sV3zfsm5QfbSeRuXLeio4eLseFQWBnJm8Iwn+RfM+/AsXe2icUzXrsyyHrEJfc/GXZIR9ebNeJLq3TuvI0ZakShZ5ubaDJmDUj0Bm/BFARuk5VldVGEDrbnZ8dJlIiQEYbycyHyon7RjE9WjF00ZUQ04gq8epzVY/Cc1sfbdhYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwZYOmD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwZYOmD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916881F00A3A;
	Sun,  5 Jul 2026 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783260062;
	bh=GWH+Yuzy5R/1k2JotQRq7MsLt5R4bYQCbLWOzloCGcE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=lwZYOmD0cEb/0TQOHtKZrhldnCB2QsQvNvWOzO6q1MhPzaHvddiYwrfzCmaqRiKXG
	 /BA3aVMJ702ll3D+nu2cg9KzyR5LtAY/XVomFv1G36sLu8SFahtzEaEKsukimF17Cs
	 EMYI9OEF0M0wo9vxOE2GrpH49ci/D6W0yp3QzwyKsbdMBsH3ya3LpQy3zqdgTtHf1L
	 Iei+nQIqk+2JBko3nUadLzLg0W//mFeCAwva9qjKVJC2JRThVQXp3/nH15uADCYGAx
	 pkSYw53IxxAh1vK/MEIs3cYnkXlU4J5QuuOmKuR/acEmMG9ECvBHJm57NP+XAJdD6d
	 L4pte16R3JtEQ==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Zhiwei Zhang <202275009@qq.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <tencent_FD4FB25AA4FFA845E63F5AC36CF4A46CDC0A@qq.com>
References: <tencent_FD4FB25AA4FFA845E63F5AC36CF4A46CDC0A@qq.com>
Subject: Re: [PATCH v2] RDMA/rxe: Check PDs for memory window binds
Message-Id: <178325047028.908624.4141497133410727183.b4-ty@kernel.org>
Date: Sun, 05 Jul 2026 07:21:10 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 26 Jun 2026 09:59:20 +0800, Zhiwei Zhang wrote:
> The IBTA Software Transport Verbs specification requires the QP,
> Memory Window and Memory Region for a Bind Memory Window operation
> to belong to the same HCA and protection domain.
> 
> rxe only checked the QP and MW protection domain for type 2 MWs.
> Move the QP/MW PD check to the common bind path and also reject
> binding an MW to an MR from a different PD.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Check PDs for memory window binds
      https://git.kernel.org/rdma/rdma/c/f58ea84a3584d1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

