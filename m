Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5921F39AD3B
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 22:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786400703; cv=none; b=h3Jw/ua2xHD+18M+aJSv2e0ovTVbeltSPbHwtTsxPpneVIRNPQR7hCkDhexmYl/Y07KDZSkSd0o4JGMUyQcNFpMYu8IYXBicYbEBSlPvQcm252wIeACBDKIrFQcKSXKEOkNuE8MGz1CMD6DhedpYRb5XQC9keKgxnf6USOq4i+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786400703; c=relaxed/simple;
	bh=qQg6wwmgDKJLev97DPSosvqGZziifMCa/r0MbeTlQt4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Ydpm1K0zNVu0QOiZs2SRCkVweTuTdu3GZnukGguw6Bp+TYBcgLGcX3FEywcibIpoEy6ieEPJ1XcLPb7llGwks/aV0BLVLBLVvxZinUHWHoUniPND/mxtiqYVZDP2KD6bnp5uCmjYi+yNn5f8OTv2wROC3piF69gVsUGJ5OoqEXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IJzzMmMm; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IJzzMmMm"
Message-ID: <e1b573dc-8b98-47c0-a997-c4f0cc3f926e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786400699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qQg6wwmgDKJLev97DPSosvqGZziifMCa/r0MbeTlQt4=;
	b=IJzzMmMmc8eqy27dNqhOtaQmJbBwhS+ZOc/3aZMjkAqfWt502pxTrYlZUTOLnCi9ndx6iX
	OrtGFbjRCHLowDJ9NZsCm5v9dfFv1z0x3TZoQP0US6DQ4SheUfa1M0z4tOk3eG0M/F3JLv
	t3cO00K8YM+e0CE4qr+RYM9+KuyCf1U=
Date: Mon, 10 Aug 2026 15:24:45 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [syzbot] [rdma?] WARNING in res_to_rt
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: syzbot <syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com>,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6a778cc0.01d0871a.3a0d52.006e.GAE@google.com>
 <fee053e9-35ac-486a-b72f-d6539f16ffae@linux.dev>
In-Reply-To: <fee053e9-35ac-486a-b72f-d6539f16ffae@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

#syz test: https://github.com/zhuyj/linux.git warning_res_to_rt
