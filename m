Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9FE4CCDCB
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 23:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791329584; cv=none; b=XjHdevTIanqco4+Mjocq/W6Upk90VTb25VF/RZyQsTfgIKNogsj0tSveSmrk0VGS0+1e/iBPrLyqsDiAC+1ypRPfESQex27+yAiGCUlHbNq2iSvjwdaxCLBCUMzsArJBEBu8eqrLdH42NVr8bkggw+VgbPac6MDZn2b8Ix/ebds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791329584; c=relaxed/simple;
	bh=ZtHLyeAPqU1yHYs1vBBFWc+adSg2cLrvC9gffuT5ipo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yrf4myTCB5OaolBNHAu8eXMFkmZaEhGDh0mbQz9aPuyiL9tVRodx68KU/1VGxeK2F/8a4xcl+KO7UP55Knqaj0iaRTBli42sB/tykGojSf5bfOFNqJ7By9D3bySQi44C7nRCRkLSXPLnyq+PXPpulGmqrQRtnfIYiCF2KjbLKps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VBJAQMao; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VBJAQMao"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-88629a452e0so2754987b3a.2
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 16:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791329581; x=1791934381; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oDIRoPL3xIeLWskd284eyk1joUNAp3MKwra/NHSENJ0=;
        b=VBJAQMaoejSKaabmORkpQLYdTjhpspoWiNbGYpgqphHi7O7IqB8ipOYjKABdOml6K1
         URmkhzhLpOuTQIyxLq2C0bIFGe6s2y+GtLndg/DlViFQvuC5PmoXK3cvwoOgIc2+lS0a
         QWTY1LNUx//qYyUrLtrkqbox02YdSWTYhbkHXK8hIQIIJO210mvFvj/Kbkgo4eECV26J
         iICFfXDp9U5fLRL+zbbN/+8RJYVpl9H34uDtuUmpQNF0D5wz/Kc9pGHJXHSL42wqxndu
         QOKHeNEOqaWqRSXypxfUIucjTbT8LczgyQXlxcfy9FrtyJlfWQp3DaaXvGEUEZm7xfpI
         WnwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791329581; x=1791934381;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oDIRoPL3xIeLWskd284eyk1joUNAp3MKwra/NHSENJ0=;
        b=gyR+eLGG+cbOeE26D7KrnYkf+cjxA1XUaPm1kzfvyizTPHlLv2TeGju4Bmh2JZhc+z
         qP6QAafh/3WTYmWt8xWH7ZJdigrJEF/HHaQ1qvBaqsf0fwpgGBfPjP9i2OwezwIAUGpI
         /CHKYAte0sByPzXMr7h11660jcTfgt1pmnCGIPy/8X5kdRaTlxHtQNuQvZ5XOZZ2oxKq
         8lAXLHI8DIbRhmHYigWkeKTt1AYXnjqPqLyDNdush24eRbzTXIjGAVMJj9UGBYWWEooU
         zr660vQWvivu4UaAc6Io72MqqHY8oB8xpLXj+MPkL+SIQl1UL8OxYwRgMiEvh5XjWoHN
         qMOw==
X-Forwarded-Encrypted: i=1; AKwUvBymqklhhNz0UFQlTJvdNOyyi07RuQIJx89w9YoBTRl+DC2748fzfUIG0FRg/tyqNDjXjzeostXqAAZS@vger.kernel.org
X-Gm-Message-State: AFq9FYImo6GNGgq0GG83A3yjyBSg5I7wJs4oC7LxHiwSq5CqP0Ak80Uy
	D+ZK8AFbZHDIsvQNEqtin2dHGnlu9SAjgmK96PTxi5VIhG/h711owbeUQBT8QVHjnFwU7YSdU9h
	SIw==
X-Received: from pfpk15.prod.google.com ([2002:aa7:9d0f:0:b0:886:455b:1719])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4c94:b0:886:4070:ceb8
 with SMTP id d2e1a72fcca58-891b286bfd0mr475543b3a.56.1791329580752; Tue, 06
 Oct 2026 16:33:00 -0700 (PDT)
Date: Tue,  6 Oct 2026 23:32:42 +0000
In-Reply-To: <20261006233248.705086-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261006233248.705086-1-praan@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261006233248.705086-3-praan@google.com>
Subject: [RFC PATCH v1 2/8] sunrpc: fail only the RPC a transport refuses
From: Pranjal Shrivastava <praan@google.com>
To: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
	Shivaji Kant <shivajikant@google.com>, Tom Talpey <tom@talpey.com>, 
	Leon Romanovsky <leon@kernel.org>, Unnati Sachan <unnatisachan@google.com>, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"

A transport returns -EREMOTEIO from ->send_request() for a request
whose P2PDMA pages it cannot move. Retrying doesn't help, but today
the error stops xprt_transmit(), finds whichever task is draining
the transmit queue, and leaves the refused request queued.

Dequeue the request, on -EREMOTEIO, cancel only its own task with
rpc_task_try_cancel(), and keep draining. Setting tk_status instead
would not work, a dequeued task looks transmitted and would wait for
a reply that never comes.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 net/sunrpc/xprt.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 48a3618cbb29..084d5a508357 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1579,6 +1579,15 @@ xprt_request_transmit(struct rpc_rqst *req, struct rpc_task *snd_task)
 	if (status != 0) {
 		req->rq_ntrans--;
 		trace_xprt_transmit(req, status);
+		if (status == -EREMOTEIO) {
+			/*
+			 * This transport will never send req. Fail only
+			 * its task, and let the caller keep draining.
+			 */
+			xprt_request_dequeue_transmit(task);
+			rpc_task_try_cancel(task, status);
+			return 0;
+		}
 		return status;
 	}
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

