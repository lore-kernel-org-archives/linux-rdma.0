Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC1043CE5E
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801188; cv=none; b=ipXKsPMwclI/HLP8/FSADMcUkQ4lWwC5ptO0FuhNEJn6bUZvGRy7BifXUEGCi321HXrUEg7YWZkS2WYxD6zFR2UlF81jJQxmCaQFV+Br5+1zgl+9TdIoomxKSoyPzsyLkLANV/FU+pGI1YCCyD2NyyUqcYoluHrLm+tKQPOjEkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801188; c=relaxed/simple;
	bh=eVDqsfkUE8fJiE6cMM2txmEd7MMMa+xN8Lzbc2XTyvI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZU5fxivSBtyC+TA4BWJAO9kptTjU5BERq0J/WoLrTXgfRWzLiCSfp994bDh5Pr21TzjMsChaGxbs+V+2lfhXh71K0UhDg9nSLizOQ5M9D4hgd3+53UL0r5oQTVAmLPfGvTYoivMfA2DKDAFy21Tg+SFPBPEx03q5kWvecKyf5To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQAVe8YF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQAVe8YF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3B91F00A3A;
	Thu, 23 Jul 2026 10:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784801187;
	bh=5nkjtCsBFUv/xzaGyWSO92wIROTGGiTKdy3uu57jQFI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XQAVe8YFiL/dis+NIXoJ6AONEQNLiXFV6A7kN5V5dmLf86SkralHq63osSfEyBDyD
	 vPXrUXWm282GOa7GtKKAOd7geJiv2Wi7dGC97KdrCn8Zgv9vRCwB5t3BKpspyRq43y
	 YSvUGaVX9NNa8uMF+u1IxBWfD7+F3lU3DkE4QbLpKqmsNcbY2Gf5AITyhWwqXkd/RJ
	 g/Y4l3z+Md81FhucjXmdeLJzMp5UBcWywpjKb7YQTggh+joWZM/Y1PMRDDkgr5J83B
	 PJ7bq7m0gMlBPr43YuJ7epgh8JHt8VUddhlqrRRE4giF+UA6PhOPohE8W2HpuiEw5i
	 OeItbZ9Bk2Yhw==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Dmitry Antipov <dmantipov@yandex.ru>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
In-Reply-To: <20260723071629.568675-1-dmantipov@yandex.ru>
References: <20260723071629.568675-1-dmantipov@yandex.ru>
Subject: Re: [PATCH] RDMA/bnxt_re: simplify bnxt_re_cc_config_set() and
 cq_coal_cfg_write()
Message-Id: <178480117728.3409014.14027580988159322970.b4-ty@kernel.org>
Date: Thu, 23 Jul 2026 06:06:17 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 23 Jul 2026 10:16:29 +0300, Dmitry Antipov wrote:
> Simplify 'bnxt_re_cc_config_set()' and 'cq_coal_cfg_write()'
> by using the convenient 'kstrtou32_from_user()'.

Applied, thanks!

[1/1] RDMA/bnxt_re: simplify bnxt_re_cc_config_set() and cq_coal_cfg_write()
      https://git.kernel.org/rdma/rdma/c/7ddcd75596cf12

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

