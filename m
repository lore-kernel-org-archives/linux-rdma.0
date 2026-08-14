Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7A0473C8F;
	Fri, 14 Aug 2026 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786728658; cv=none; b=EhuqflQNrU+6m2g5QNpieB0dazlT1oJDANaDSibJiPTweX8a9PB8CtblHCx5fhXHpGeSiFW0GQzy3DbC5yXphfJJVo6zDqL7XQXi88hDXJSg4qb+n1FLZjVOFKRlKhizt4VjCDZeDb6BU0OB9t+IO4tI7PO89k7FMmi48RepO2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786728658; c=relaxed/simple;
	bh=+NJ5r11kSiUl2kjBObC+8dR8eBfT5qxxzdS3eyifBgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aByz1FYxSHrz5XYX/nqsqiusqqfQzz+ejaaBcxzfn5ufOBaPsT71fr3VEkl94/3c8jkqpCGOwf4dVxoMQ+hdFFbpLB9uqUbCM4ZYrIeQ75GK12dgLzyP4YP365pHg2cqrYPmU0alv+oB4ON7a0C8dsmR/xJGA6S88WoyB9ko0Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ynpumc3j; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ynpumc3j"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hM8QJ6rvdzlfvq4;
	Fri, 14 Aug 2026 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786728644; x=1789320645; bh=ATo8cIzohXY6aaPsj2WsiOTE
	nmQzSMu7k5voVaiOROk=; b=ynpumc3j84yo/d/CdqxM8IJHFqLIFb6lYVmTb2tp
	pDxB+LUSrJl2zSeLSfgXgwJrdeRIEgqatRRQGPogHypU9BhCQKw3JNzXNICRwph1
	4Zcr90K2FqreKnbzQQO0ZqYCWePMnOIh9A1uagNVXpXzoO6UjN/netxxZC30rRj4
	Hr2pf3Zk6AqXNeunf5IUt9F9AtpLxY7X4SmWDfRaNVt/jEzf7p9f/6hSXB8ZTmFx
	UGp8pXiIcyJLVpRiL9G2dnl8hyEfIGvCOn7C1OXYTaBxr9/vKj85N+/bbLnomb1N
	fcB1dPaP3MIbjMTeAOz3Ld6nIblkIS8XPpxI+4snjWyNSQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8iKtpF2GOqTB; Fri, 14 Aug 2026 17:30:44 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hM8QC3jS4zlfvpG;
	Fri, 14 Aug 2026 17:30:43 +0000 (UTC)
Message-ID: <4462dcb4-acae-4f70-bc65-a9557ce20181@acm.org>
Date: Fri, 14 Aug 2026 10:30:42 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srp: fix use-after-free of a request in
 srp_destroy_qp()
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260812190418.200337-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260812190418.200337-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/26 12:04 PM, Yehyeong Lee wrote:
> srp_destroy_qp() drains the send queue before destroying the queue pair.
> For the fast registration and invalidation work requests, the wr_cqe it
> finds there is &req->reg_cqe, which lives in the blk-mq request pool.
> srp_remove_target() frees that pool first, through scsi_remove_host():
> page_owner records the page freed by blk_mq_free_tags_callback() while
> that call is running.  __ib_process_cq() then calls wc->wr_cqe->done on
> it.

Can this crash also be fixed by modifying srp_remove_target() as shown
below?

Thanks,

Bart.


From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 14 Aug 2026 17:00:55 +0000
Subject: [PATCH] RDMA/srp: Fix srp_remove_target()

Remove all logical units before disconnecting the transport because one or
more SCSI commands may be submitted while removing logical units. Remove
the SCSI host after the transport has been disconnected because the code
that disconnects the transport needs resources that are freed by the code
that removes the SCSI host (SCSI host tag set). Remove the srp_rport_get()
and srp_rport_put() calls because the purpose of these calls was to keep
the rport until tl_err_work is cancelled.

Reported-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/infiniband/ulp/srp/ib_srp.c | 14 ++++++++++----
  1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c 
b/drivers/infiniband/ulp/srp/ib_srp.c
index acbd787de265..0b296b5715a8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1038,15 +1038,20 @@ static void srp_del_scsi_host_attr(struct 
Scsi_Host *shost)

  static void srp_remove_target(struct srp_target_port *target)
  {
+	struct scsi_device *sdev;
  	struct srp_rdma_ch *ch;
  	int i;

  	WARN_ON_ONCE(target->state != SRP_TARGET_REMOVED);

  	srp_del_scsi_host_attr(target->scsi_host);
-	srp_rport_get(target->rport);
-	srp_remove_host(target->scsi_host);
-	scsi_remove_host(target->scsi_host);
+	/*
+	 * Remove all logical units. This must happen before the
+	 * srp_disconnect_target() call because scsi_remove_device() may trigger
+	 * submission of SCSI commands. See also sd_shutdown().
+	 */
+	shost_for_each_device(sdev, target->scsi_host)
+		scsi_remove_device(sdev);
  	srp_stop_rport_timers(target->rport);
  	srp_disconnect_target(target);
  	kobj_ns_drop(KOBJ_NS_TYPE_NET, to_ns_common(target->net));
@@ -1055,7 +1060,8 @@ static void srp_remove_target(struct 
srp_target_port *target)
  		srp_free_ch_ib(target, ch);
  	}
  	cancel_work_sync(&target->tl_err_work);
-	srp_rport_put(target->rport);
+	srp_remove_host(target->scsi_host);
+	scsi_remove_host(target->scsi_host);
  	kfree(target->ch);
  	target->ch = NULL;

