Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8053D390991;
	Tue,  1 Sep 2026 10:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788257272; cv=none; b=DhScd1jx6eC0shz8sKKzplkfkxgEJmmSh0lwkauCWQ/BMJ7XQZMPGrCn51PaP0MZHStNeluaDYaINgwO42GYPxECoeM078PLcOd7xnBhPUSB5EGMcMCazSlk2tCorGsGQC2k9COk5Cx37fNARoLqpZeUxNFGhjRSBs+ZsNuGXJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788257272; c=relaxed/simple;
	bh=AVAxjRXT/Oy2zbDACIouUK9OdY5+CAhx5iFIEV2zNz8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DTJ/QT0Dn4HP8Nrq3qIU0PKCLrkim+xeVyy72kA7ZfHdwDuEod3O8ex4k1an4oWbc3Pm5QO6Srzl+nNKx79s/tLyK3LplXiHcSVJXbnsVZ5MFz3hbO6bbkAuCJGRusPRB5SEnkPaFLRotLyyvYg7P0w1vRrrfIkuX5AQAQegzGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ADTqWGDa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADTqWGDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11AA1F000E9;
	Tue,  1 Sep 2026 10:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788257271;
	bh=PoK3LpUQD7xnXiZoA+/eWJWA3Z/fW24lxnC+mG9Dc6c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ADTqWGDasqn7azaBYvHz9MneKZQYxxHfj7mOquB8BT29vR0mlwWeQPP6Ad3Zf6RV+
	 SUmmUaK+xIcasihOWi98D+9ovMVTM4M5RkhxrczDTAQ1R5lbmEn7s1yebbhfB2N/Qw
	 7MYqxi6CT66O/VCLk9ZUDn4TBcgux+opyrojY1IQ81wZYx1maI9BC3Rg/Uk5KIle0P
	 0xX/tkxRySthpiFKM22zzoV68WUmpPpqECgEr+J3NrkqorQZ8Eqvlg+cTCr+KqzB4R
	 sdkOdvFcY2/FxoClUVhHUYKwZT5o5KbDatsWXrdR9VTYwxiVoSiv5waXduUf+PRp+t
	 VoRzaUDhd9bJA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Norbert Szetei <norbert@doyensec.com>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org
In-Reply-To: <46E1D5C0-24BE-4D01-BDB3-634FE09B22C5@doyensec.com>
References: <46E1D5C0-24BE-4D01-BDB3-634FE09B22C5@doyensec.com>
Subject: Re: [PATCH] RDMA/rxe: validate access flags before swapping the
 MR's PD
Message-Id: <178825726861.1143543.16023047492405321671.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 06:07:48 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 27 Aug 2026 19:18:07 +0200, Norbert Szetei wrote:
> rxe_rereg_user_mr() reassigns mr->ibmr.pd first and only then
> validates the IB_MR_REREG_ACCESS argument:
> 
> 	if (flags & IB_MR_REREG_PD) {
> 		rxe_put(old_pd);
> 		rxe_get(pd);
> 		mr->ibmr.pd = ibpd;
> 	}
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: validate access flags before swapping the MR's PD
      https://git.kernel.org/rdma/rdma/c/ae36a5b609ae79

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

