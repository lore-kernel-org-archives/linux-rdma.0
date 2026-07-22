Received: from sender-op-o18.zoho.eu (sender-op-o18.zoho.eu [136.143.169.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8376040F732;
	Wed, 22 Jul 2026 10:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784716190; cv=pass; b=RVYKQVB8SThTdURBNvuPcTM2i1c84HKNHBaVvuoQOxDApdIcAQbGDDTQNHj3YSZJwDocQ+ienAf2jlqhtdFxpbkq8PXZXdlMiyihIPRP9HHvNbdpfJikok24xHXJvMB61w/JBuvoBs+MDp3CXzUipaWPN7Qjk7pDnAoQLf/fIHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784716190; c=relaxed/simple;
	bh=BjTQ6LbMIsNzxzj3qAH9dmwVXf0/+TXX0H3zspEqLqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJCz9KsHeuzjE/lcKuguMpDcrL924DmRoHhR6/7i4xnkgQXzbBj243SSw3UKxfxusyA2ZrHTu9p6mGpI5lUcqSMLFpfR2OxN5GzUEUpmG3GPiLu7KDjVAw31ZJjWXWZWHT/cIlMgPj1CNkc11VfJdmTpuBf5cki5zU5qgNSAn1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=b3B0IcsG; arc=pass smtp.client-ip=136.143.169.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="b3B0IcsG"
ARC-Seal: i=1; a=rsa-sha256; t=1784716174; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=CxQ7+hTgMHl04hBUnbZBMgI6acQJDRJGCIvd2WFRbOzCrlvQS1HbR8kV1zRfjIFxBelb5jnuzgquiWCxU64fmP2CsbnQWIgoFm8blT22a4LD5tbo+OIZx7fgsg2H31o3aCvoL6xbcse9/ueWxXEAYehSqmHOCh1wxcSMxUxJfTI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1784716174; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=21eE4TMdsHumlVIr5NEeQTIKwYbirLS+Zh61QurW1Io=; 
	b=O1OV16ofK1KMGye2+Lq/SlmTYeylTakf9n+Jeg0BviE/02E0UT+BNky5FkUJjnzoBKA8dM997vZKWs31eBpZ8i9IukOfa1RmLm5Mborxd7I3NfEeSyktQpnDJvtCoQXNEYS4UaKAUOFA1FphXLPR6MfNnZYw5Eq5jnnnLnoEc2E=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784716174;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=21eE4TMdsHumlVIr5NEeQTIKwYbirLS+Zh61QurW1Io=;
	b=b3B0IcsGxjPgNqZrP/qjS6p8ywD5VzXu8HIlFeLPPFCE6FgfLBUtoEh2sfYSmTxg
	BIPKKcUs2gJS+kc7EE1ShiMMQI8dk2DbxwCdZzBcx90i4nQkrddAckgYNPFS0wUpDJI
	1v4LGJAxTCleePQLEDEK2u0Jnb291SC39C8J2Kzs=
Received: by mx.zoho.eu with SMTPS id 178471617232845.97435197187474;
	Wed, 22 Jul 2026 12:29:32 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: dust.li@linux.alibaba.com
Cc: alibuda@linux.alibaba.com,
	wenjia@linux.ibm.com,
	hexlabsecurity@proton.me,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: validate peer CDC cursor against RMBE size before accepting it
Date: Wed, 22 Jul 2026 12:29:29 +0200
Message-ID: <20260722102929.38218-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <amA9XGOWH3z4Z1fu@linux.alibaba.com>
References: <amA9XGOWH3z4Z1fu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

> I believe Bryam already sent a similar patch to the mailist and I have
> already reviewed it.
> https://lore.kernel.org/netdev/20260705-b4-disp-28a1bbca-v4-1-be089b98acc6@proton.me/

Thanks Dust -- yes, that fixes the same bug, so please drop mine. (I sent
a v2 earlier today, before I saw your note, in reply to a sashiko review;
please disregard it as a competing patch.)

One thing worth checking on Bryam's series, though: bounding only the cursor
count (clamping temp.count to rmb_desc->len) still leaves the advance
unbounded. smc_curs_diff() on a wrap increment returns
(size - old.count) + new.count, so a peer that sends prod (wrap=W, count=0)
then prod (wrap=W+1, count=size) makes diff_prod ~= 2*size even though both
counts are in range. smc_cdc_msg_recv_action() then atomic_add()s that into
bytes_to_rcv without clamping (despite the "0 <= bytes_to_rcv <=
rmb_desc->len" comment) -- which is exactly what smc_rx_recvmsg()'s second
copy chunk trusts.

A sashiko review of my patch flagged the same gap; I bounded the advance
too, with:

	if (smc_curs_diff(size, &old, &temp) > size)
		return;

Might be worth folding into Bryam's version. Happy to send it as a
follow-up if that helps.

Thanks,
Ibrahim
