Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39010447818
	for <linux-rdma@vger.kernel.org>; Thu, 13 Aug 2026 09:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614281; cv=none; b=M0EYkRLnSCAGRtPpaLZnCqAk+udHpA6QjnBtKluGWXH7EroPoVmzl1ynCWRATD7mrMppN5F7YkRp21lRzrhttYzaL6gsp1UdvoQk66MHK0qLsyKka2tHg3Uv4jN8G4yhJtwOmKDtyz4L01KUAA9vSdROGvwYSKgnQjGRfWJB/r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614281; c=relaxed/simple;
	bh=3KTOKdTl547mjQ0PIdk9eF/gYC+A+z2iu/ylFNzV3rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOjJJwF23NoUkAfsuOY1lN79nEgwq7CMDfINS8qJiLwm08low6O8jKXU50KsqUalw1AB/4Jk9sT7Z8/g61mlOE1dUtEuExSGcwv21RuxJurrDHbCCCYDuQdn2s899BQ/MLYzREWZx0SXG1++CQQWZkIWkAtCVRZzid8M0F5GGSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=idMi7+4f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="idMi7+4f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786614279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dF9v1idLVMGFCs33tHPlRdS0F3gORp7BYOQ7k7a0n1Y=;
	b=idMi7+4fYly7SNrP7b5tymVZ7OrZzi0qWFRJZ0MIwfTET4gflaLAG/iQ2N9u1BFtKTH69s
	pfHTY4KCRjMUirx3R3e3f2G+0XAl5pmsi2aBpXjjpX5xtRrmhK9394jJR8D3imqeTkMlFS
	zmtXCJpKoFGx/M/CvaPxJ91kK4M7NMQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-423-A0SKBaN5M9mIABt8vzepiw-1; Thu,
 13 Aug 2026 05:44:37 -0400
X-MC-Unique: A0SKBaN5M9mIABt8vzepiw-1
X-Mimecast-MFC-AGG-ID: A0SKBaN5M9mIABt8vzepiw_1786614276
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42AFE195604A;
	Thu, 13 Aug 2026 09:44:36 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.48.120])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 84E19195608A;
	Thu, 13 Aug 2026 09:44:33 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: achender@kernel.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org,
	jhubbard@nvidia.com,
	leon@kernel.org
Subject: Re: [PATCH net-next v2 2/2] net/rds: initialize i_conn_path in rds_inc_init()
Date: Thu, 13 Aug 2026 11:44:26 +0200
Message-ID: <20260813094426.120571-1-pabeni@redhat.com>
In-Reply-To: <20260809005103.82371-3-achender@kernel.org>
References: <20260809005103.82371-3-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://netdev-ai.bots.linux.dev/sashiko/
---
net/rds: initialize i_conn_path in rds_inc_init()

This sets inc->i_conn_path to NULL in rds_inc_init() so the field is no
longer left holding stale slab contents, and switches rds_loop_xmit() to
rds_inc_path_init() so the loopback path keeps a live path pointer in the
message's embedded inc.

> diff --git a/net/rds/loop.c b/net/rds/loop.c
> index ac9295a766b1..e6b0750bbeda 100644
> --- a/net/rds/loop.c
> +++ b/net/rds/loop.c
> @@ -89,7 +89,11 @@ static int rds_loop_xmit(struct rds_connection *conn, struct rds_message *rm,
>  
>  	BUG_ON(hdr_off || sg || off);
>  
> -	rds_inc_init(&rm->m_inc, conn, &conn->c_laddr);
> +	/* rds_send_queue_rm() stored the connection path in this embedded
> +	 * inc; use the path init so the re-initialization keeps the field
> +	 * valid instead of discarding it.
> +	 */
> +	rds_inc_path_init(&rm->m_inc, &conn->c_path[0], &conn->c_laddr);

[Severity: Medium]
Does this swap silently drop the i_rx_lat_trace[] zeroing for loopback
incs?  rds_inc_init() in net/rds/recv.c ends with:

	inc->i_usercopy.rx_tstamp = ktime_set(0, 0);

	memset(inc->i_rx_lat_trace, 0, sizeof(inc->i_rx_lat_trace));

while rds_inc_path_init() stops at:

	inc->i_usercopy.rx_tstamp = ktime_set(0, 0);
}
EXPORT_SYMBOL_GPL(rds_inc_path_init);

So after this change nothing in rds_loop_xmit() clears the array, and
the RDS_MSG_RX_HDR and RDS_MSG_RX_START slots (written only by
net/rds/ib_recv.c and net/rds/tcp_recv.c, never on the loopback path)
are left to whatever rds_message_alloc()'s kzalloc() left behind rather
than being explicitly initialized.

The array is handed to userspace as RDS_CMSG_RXPATH_LATENCY deltas in
rds_cmsg_recv():

	inc->i_rx_lat_trace[RDS_MSG_RX_CMSG] = local_clock();
	...
		t.rx_trace[i] = inc->i_rx_lat_trace[j + 1] -
				  inc->i_rx_lat_trace[j];

Would it be preferable to move the memset() into rds_inc_path_init(), or
have rds_inc_path_init() call rds_inc_init() and then assign
i_conn_path?  That would also cover the other rds_inc_path_init() caller
in rds_tcp_data_recv(), where tinc comes from a recycled, non-zeroing
kmem_cache and therefore keeps the same stale-field property this patch
sets out to remove.

>  	/* For the embedded inc. Matching put is in loop_inc_free() */
>  	rds_message_addref(rm);
>  
> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index cf3884d87931..f1513dfb2716 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -47,6 +47,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
>  	refcount_set(&inc->i_refcount, 1);
>  	INIT_LIST_HEAD(&inc->i_item);
>  	inc->i_conn = conn;
> +	inc->i_conn_path = NULL;
>  	inc->i_saddr = *saddr;
>  	inc->i_usercopy.rdma_cookie = 0;
>  	inc->i_usercopy.rx_tstamp = ktime_set(0, 0);

[Severity: Medium]
Related to the above, the commit message says:

    "and so the two init helpers
    (rds_inc_init/rds_inc_path_init) leave the structure in an
    equivalent, fully-initialized state."

Does that hold after this patch?  rds_inc_init() gains i_conn_path = NULL
here, but rds_inc_path_init() still lacks the
memset(inc->i_rx_lat_trace, 0, sizeof(inc->i_rx_lat_trace)) that
rds_inc_init() performs, so the two helpers leave i_rx_lat_trace[] in
different states.  Could the changelog be adjusted, or the missing
memset() added to rds_inc_path_init() so the claim is accurate?
-- 
This is an AI-generated review.

