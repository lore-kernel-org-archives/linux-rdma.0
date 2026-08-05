Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A943D9DB3
	for <linux-rdma@vger.kernel.org>; Wed,  5 Aug 2026 07:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785916052; cv=none; b=J39Kr5O39orxwIqMJicMAGMfHg0PiBU8O2mmrtfUY0rmoHyCGQ2VCrcPrLU6QJsIk+MNfSAEmX15sg4gkqkCy0PMANyE57gaWTFUqFSWi4+Q9FZny2ZOD9/SDPGHtxzQV+9BJVNVRcbOLfPNxrHqOGAFRgS57Q0mskA/KcEojrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785916052; c=relaxed/simple;
	bh=S3jlvnsBqaConZP/b7upiR48OelHL1hvQqhaBQSRliw=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=ddl1lqVxaXU+GpKS2lQ0z2ODV/4o15mQqbffb1TmqCiNOhTK391WFhC6TEBwp9SGLZ8aPtcDR86ZnoQnUU/pnK0KtPGn/hZX8o5+f+yRPJAqHQknzJ3+ZeAykKUjVpNrW4jLpt8F8ncYWRk36enwyvEpeFNU5fZWDq1fMbGnBAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aPWhL6L2; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aPWhL6L2"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3jlvnsBqaConZP/b7upiR48OelHL1hvQqhaBQSRliw=;
	b=aPWhL6L25w40l2m5faURchf8QQfVg+f03dwu5eq5GSoh65wEvqmqGKM/NV8Fv0RSCDaop7
	V/Ypg1Hho6HwTulIL0+MJJ7GrQjd9tg2+gWjSXwsK2a7YNWCpkgKPVe+hianT9BDlZflAv
	E4KWAu+vZdIkDUXDPgdu55r77201Xtw=
Date: Wed, 05 Aug 2026 07:47:25 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: gang.yan@linux.dev
Message-ID: <9e00be256dee0ad1d163ed0e26d2c15b238efc68@linux.dev>
TLS-Required: No
Subject: Re: [PATCH net 2/2] DO-NOT-MERGE: selftest: add rxe mr_check_range()
 overflow reproducer
To: "Zhu Yanjun" <yanjun.zhu@linux.dev>, zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, "Gang Yan" <yangang@kylinos.cn>
In-Reply-To: <9daf85d5-e12d-4498-86e6-aa6180a91df5@linux.dev>
References: <20260728091128.9116-1-gang.yan@linux.dev>
 <20260728091128.9116-3-gang.yan@linux.dev>
 <c93089b8-bb9f-4aac-a644-36b6cc9b5d59@linux.dev>
 <36d31c1e-aebe-4a48-ab44-4447c0a75a33@linux.dev>
 <393f97fc5e5c042d5bd62231f96fae0b527a58d0@linux.dev>
 <9daf85d5-e12d-4498-86e6-aa6180a91df5@linux.dev>
X-Migadu-Flow: FLOW_OUT

> Thank you for the clarification.
>=20
>=20I agree that we can drop the selftest patch. My original suggestion w=
as mainly to make sure we have proper coverage for this issue, but after =
considering your explanation, I think adding a standalone selftest for th=
is particular case may not be necessary.
>=20
>=20The bug fix itself is the important part, and keeping the selftest ou=
t will also avoid adding a test case that may not provide much long-term =
value.

Hi Yanjun,

Thank you for your feedback.

No offense at all.

Regarding Patch 1 (the actual fix), I noticed that it hasn't received a R=
eviewed-by
or any further comments yet. As a newcomer to the RDMA community, I just =
want to
make sure I'm following the right process. Should I proactively send a v2=
 with only
the fix (now that the selftest is removed), or is it preferable to wait f=
or more
reviews on the current version before resending?

Please don't take this as a nudge =E2=80=94 I'm genuinely asking because =
I want to avoid
missing any step that I should be taking on my side. I'm happy to wait if
that's the usual practice.

Thanks
Gang
