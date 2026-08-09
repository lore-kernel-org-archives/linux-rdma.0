Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467E2CA6B
	for <linux-rdma@vger.kernel.org>; Sun,  9 Aug 2026 23:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786319224; cv=none; b=i1tLL/063/p2J7nh1jhmidAQvr5oJPnSRv/wpyxLFQv9BeNq7MNDFOfrERg49J/TPfZX0Vzo50MOueGEcOBHcbqjO+XPKEeFLyia22zQ+zQ/EnSN0qupW6f5Uk4k+rDy/RlRP+gfgmtj/z6IB2XOVTMHXeQFOCwo2tsgw8v9rgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786319224; c=relaxed/simple;
	bh=qQg6wwmgDKJLev97DPSosvqGZziifMCa/r0MbeTlQt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YTv6fYcB3e0UbTVhcx+5s+yfBIuALPmne3YidsYWhYbvPueXMemNFANfKb/b6+tljdQ2Q10a0Tml/Po4GTDFXS9kGsShNryyvtM774gJqyNYEC0wO0QipUXwkgzWsu9KHMzYh2JJ0QF9iJ2SRve4O7YPJWq3j3gjYO8MyKonATo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y1EzVBre; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y1EzVBre"
Message-ID: <fee053e9-35ac-486a-b72f-d6539f16ffae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786319219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qQg6wwmgDKJLev97DPSosvqGZziifMCa/r0MbeTlQt4=;
	b=Y1EzVBreZFZVW5sLg3ZWX3FjZw7VFZw/S8PUohsBDRNO1RGaEZQqrNugPFdrocp99KCFRf
	Wk7e+FRRj7rvYuehftJIBom7x7S/0GgaOXXpVOHfNuv0iuunSIroZhxFHp/PoFZS54fHDN
	jcPMCDsGEYxajYj3e0r3mk0z9ZUEARQ=
Date: Sun, 9 Aug 2026 16:46:44 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [syzbot] [rdma?] WARNING in res_to_rt
To: syzbot <syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com>,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6a778cc0.01d0871a.3a0d52.006e.GAE@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <6a778cc0.01d0871a.3a0d52.006e.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

#syz test: https://github.com/zhuyj/linux.git warning_res_to_rt
