Received: from sender-op-o18.zoho.eu (sender-op-o18.zoho.eu [136.143.169.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0C43A785A
	for <linux-rdma@vger.kernel.org>; Fri, 24 Jul 2026 07:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784877723; cv=pass; b=F9LeGj5IiZIAaHnFAHVLBgw9HGkpqmIXqdyt0ZBqMSREzEqkjOMGjLz4Km06wubYKjdQoeAxVDcJAgp9BOyfK58mZWJJezgQoo7sVdrlJbOoelqto+hwwDNWQKtUZzcBGmdLw9Qq8U2eEk0af6Dt8XIGt7hnkuvx2jFGe0/r0wc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784877723; c=relaxed/simple;
	bh=vdFbwDzfIG/+VeTlPkValVFNo8EhGWuBH5PqrMKItmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLp12C3X5ntnHufZNpUx+Mhz2K+10tO3M20tZJNeTGYkP48faxGw98MqxKibFTNm1REyEKBK90jPU21ZfiRvsyVvjSwTUypVWQtpFr+78fZkb5hsZXA7hL72HFDSUJqg+IZH5MBsTot/u7MA7KGbFbsKERpN+DqpS+me0Zw7M3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=cgM2bzO4; arc=pass smtp.client-ip=136.143.169.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="cgM2bzO4"
ARC-Seal: i=1; a=rsa-sha256; t=1784877686; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=PBabhCW8EadIna8APdGN2/uEzY4HyOOlHYeTxvzqlnSyEJW6QQ1/fiv1VDeOqRKQ/29jXV0ySiciRT8dX+LlJ1zJex4R3j0KOg3RhsAUVMtrspzJ3qufhMREVmJwygz0h8YaiugSIQ5Siq7CvIMNcwV5zvRKEorVGD0ywrWaq8w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1784877686; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yIZl7S9SIcidyW9IQWtVIrd8c51ONJX47pUN0klN0d0=; 
	b=WD4oi9ZU47GM+OaqaodO3WfP6oBZM8lGtwrkUMUK0lAKb0+bOSpGKGqofmlCIqqF7GpxYsnnRm6fqTBKl+9vL6uxgSFM0NN53Tucfm/7W8nKnIenottqGX3lwc1+Ih1TscYli1EF5whE0U4j/oKJ8Iu79XZGxv1tKx1gw8kezpw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784877686;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=yIZl7S9SIcidyW9IQWtVIrd8c51ONJX47pUN0klN0d0=;
	b=cgM2bzO4So8QbU+jznahh0DbajOt8nwSfAUiWpmnAD5MVAkn642LXAYkxXBJa2Di
	q3uRh4mScZl3QdaRXJjvVwYDIBan8NKO+WDOMjcY81f0BkG7dEOcCbkrdAg1DSGmpKa
	f+CuUqTnaOyZy3MoeOE2xwKEHk1DNV96cRc21Wmg=
Received: by mx.zoho.eu with SMTPS id 178487768122574.5123130490988;
	Fri, 24 Jul 2026 09:21:21 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: hexlabsecurity@proton.me
Cc: dust.li@linux.alibaba.com,
	alibuda@linux.alibaba.com,
	wenjia@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: validate peer CDC cursor against RMBE size before accepting it
Date: Fri, 24 Jul 2026 09:21:17 +0200
Message-ID: <20260724072117.73038-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260723230647.138311-1-hexlabsecurity@proton.me>
References: <20260723230647.138311-1-hexlabsecurity@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

> The insight is yours either way -- may I add your Suggested-by (or
> Co-developed-by)?

Please do, and thanks for running it end to end. Suggested-by is the
honest one -- I pointed at the gap and the advance-bound, you did the
series. If you carry the

	if (smc_curs_diff(size, &old, &temp) > size)
		return;

verbatim, Co-developed-by is fine too, your call. Either way:

	Ibrahim Hashimov <security@auditcode.ai>

And your split is right -- advance-bound as the early catch, bytes_to_rcv
after the atomic_add for the accumulation the per-cursor check can't see.

Thanks,
Ibrahim
