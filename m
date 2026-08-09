Received: from out-182.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7AE239E9B
	for <linux-rdma@vger.kernel.org>; Sun,  9 Aug 2026 22:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786314450; cv=none; b=IRAJfYQ+z+8vb2uMnb5tZlj4mMNhyT9nhq/yo76i/QXh/af7ncHCWrhEpl3OrQ8sq84eBQjNnWSeFyK9qq+GdFfLmwC5GiFmToKBA7pyuE/FhrkE1R81i+tCMrR0ZSdLZW87DffD7T3xJXNrpvPsxIubo95+ZTnALCQrG80TLIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786314450; c=relaxed/simple;
	bh=i/0R5X0c96Qpok/iZfmgTN7QuGJ51tYhbiLV/7UYWEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rZtj1NDyR3xLyHqNNsWWXJxk886gK7hXOpdqLeiUhTdrxT10LEsLC9wEVo5fxpf+IpEhJvZ8bKB8BYk3YkL1IT1G4Bhed5BGFce1+2V64GtSI2jN+cLY/bAg2q2vcffkp1rpe3UIjn4iW1L5i4urABvZdvq8cu6FKXs8rHfF9Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ezxSmbjC; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ezxSmbjC"
Message-ID: <e878b0e0-a375-4bad-ba85-2b3a24ac060d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786314436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TEwxkyGa//+oqnn6bar/BumRsiUINpidJ60P4TKu3Ow=;
	b=ezxSmbjC/oIvgUrQIg3bYJop5FNcuU8S9WVN5Mb2x0z97nwN9F8eYEIAXyHHYxeHVFelRv
	KgJMYzlyFPgLIOqRkChozmMqD7ULDrimHHmdNI5d7t/lMiQQ8ExbhFHFKdD3/AFM5tHnIG
	py9agGqr+lnvoAXJ55p3uoeQmc/eGVc=
Date: Sun, 9 Aug 2026 15:27:04 -0700
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

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index cc24fddf9aaa..35e463a20ade 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3531,7 +3531,8 @@ static void addr_handler(int status, struct 
sockaddr *src_addr,
                 if (status)
                         pr_debug_ratelimited("RDMA CM: ADDR_ERROR: 
failed to acquire device. status %d\n",
                                              status);
-               rdma_restrack_add(&id_priv->res);
+               if (id_priv->id.device)
+                       rdma_restrack_add(&id_priv->res);
         } else if (status) {
                 pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to 
resolve IP. status %d\n", status);
         }
