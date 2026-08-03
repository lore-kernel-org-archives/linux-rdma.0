Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BA41CAA92
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 01:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785721785; cv=none; b=sdFwZqSd0ZSKU2vKzF2N3mB4zLkgDru9zZqpoSkDAV3p4wenUbF9+DWU1YauN5tSkSVVC+ReHFnzjlu3Cn3lc7l2p5xmMTPMwb/7u8tYRjb1rk4Mbc6wYxslZKWfP3fyOOwvGh2Wl2CHJhO0dIThEloM0/qWHn5KtBs+0kfPuu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785721785; c=relaxed/simple;
	bh=enMlENWeZAZtu8vs4JjjYMfkLRAbrbD07oRoHkP1UHY=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=AH0PBLiZmUtEV97FQW8EXs3Dh7Bsc/yKRruLFki5uCJd3clFqgXJcnvo27dfZdso94pWVYOTOHYe/2LbkWqhDZsYO1kGirAnbs6ECAefmkbPtTHuiUHp/dUVJQeKX0hi2LUGRkGSQQt7BsvuJ6wy1aQ537Kbvcm1gj8vwWR/kLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LlhdX8Vg; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LlhdX8Vg"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785721781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4N+o+F4lC33fLe3y4fqcfQgAbZbw0QW2nYHoW8EPlg=;
	b=LlhdX8VgMbQdZvml/i2y4+7YwqcrWXdDnzMIInzG1PPTr22XSk6xi0CZrkYi1bsr71nDC8
	sMJc46OA37bZ+MnWV3Qwc4wKHnnle9TJfwFisgC48HFzhbYJwML6JHYUr/CcLPS4K+rUfH
	UQi5bisJwzdOso7Eq7vSy+jHBjLX57g=
Date: Mon, 03 Aug 2026 01:49:39 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: gang.yan@linux.dev
Message-ID: <393f97fc5e5c042d5bd62231f96fae0b527a58d0@linux.dev>
TLS-Required: No
Subject: Re: [PATCH net 2/2] DO-NOT-MERGE: selftest: add rxe mr_check_range()
 overflow reproducer
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, "Gang Yan" <yangang@kylinos.cn>
In-Reply-To: <36d31c1e-aebe-4a48-ab44-4447c0a75a33@linux.dev>
References: <20260728091128.9116-1-gang.yan@linux.dev>
 <20260728091128.9116-3-gang.yan@linux.dev>
 <c93089b8-bb9f-4aac-a644-36b6cc9b5d59@linux.dev>
 <36d31c1e-aebe-4a48-ab44-4447c0a75a33@linux.dev>
X-Migadu-Flow: FLOW_OUT

August 3, 2026 at 6:28 AM, "Zhu Yanjun" <yanjun.zhu@linux.dev mailto:yanj=
un.zhu@linux.dev?to=3D%22Zhu%20Yanjun%22%20%3Cyanjun.zhu%40linux.dev%3E >=
 wrote:


> >  Thanks a lot. When I run rdma selftests. I got the following:
> >  "
> >  # Warning: file rxe_mr_overflow.sh is not executable
> >  "
> >  You need to make rxe_mr_overflow.sh executable.
> >=20
>=20After this testcase is run, please remove this bin file rxe_mr_overfl=
ow in tools/testing/selftests/rdma.
>=20
>=20Thanks a lot.

Hi Yanjun,

Thank you for your reply.

Regarding the selftest patch, my initial thought was that the selftest do=
es not need to cover this particular
issue separately, which is why I added the DO-NOT-MERGE tag.

However, after reading your feedback, I would like to clarify your sugges=
tion: do you mean that I should
integrate the attached rxe_mr_overflow.c into the selftest suite? Or is t=
here a different way you would
recommend?  If you fell OK, I would prefer to drop this selftest patch en=
tirely.

Please let me know your preferred approach. I'm happy to adjust it. Thank=
s again for your guidance!

Best regards,
Gang

>=20
>=20Zhu Yanjun
>
