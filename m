Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32CA3C279D;
	Tue, 21 Jul 2026 09:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625070; cv=none; b=sVQHWZUziXNYz1EWTLTuyR28GlrHRg8Oemqved3OKpY/VnbwJ1P+mSFo9FcfE7wQU+3GvpA2jAr3gBLdh0Vguf4J3okJONdnUWI6Z+7fvzkvrxMe/Srif3R2mgka5/eZqPOK0hqQ3J9ID17cha6YAmYVdEqSGS/Gos75anVIMcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625070; c=relaxed/simple;
	bh=xjdvPKcGuDJRbbrAc8WYU9dnfXqJ7SVjfK6nL2EtLrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dCt5WXPE6Mecq0/+Kcy8l/z7xpBB8imfm3tnlBclQdmtEs/d9VoKvxergOPm14rfgE49g1WJ6cBWcMeIYaSVYBgMTjf4Iek8159lsPectDUxr8AWBTsWRWBtf9mGdinPmLHpeznx3zfeX/ayAXiwOrzS4257KmAcQdx5tDoF6NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1Ei5ThY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1Ei5ThY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAFE1F00A3A;
	Tue, 21 Jul 2026 09:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784625069;
	bh=60d4Oqs/2mF3SmCHf+UxWUkrfVdhCdGHkXPvR6HVL/w=;
	h=From:To:Cc:Subject:Date;
	b=L1Ei5ThY6FpxXFhVxOme42PFcUp4GF2UHNsywKm3DhY/H/d90jt9N93znwlk+GP8d
	 8okD8iFww8MWv6PKPfG29gnKNDehz6Q37cZ9cqGFvS/XDYPYEeRm8sAgNWf0fcCMaj
	 lkHV6eyh5xVf5ld4j7vwnp5I6QRQQkJiQRXo7E3Hv8uUHDzyfZUo7X4N84A81bDQMn
	 ZPp2urU03jHunIy1TUiH6+/Vs4nsTgEdvgHPESOyavKFuU6Qi0BXYo3AKhtuxKkTIQ
	 aEUkSXgtfQ4TYml0mmYcKB+Hquh5tC0KN3nT9jsD6dFTCoefkX/hsIdhsxUgI9/hEu
	 89i904U3XU9FA==
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/srpt: Pass the mapped task attribute to target_init_cmd()
Date: Tue, 21 Jul 2026 12:10:56 +0300
Message-ID: <20260721-b4-scsi-ordering-violation-due-to-hardc-v1-1-07205aab71bb@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260721-b4-scsi-ordering-violation-due-to-hardc-42a3335bd169
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

srpt_handle_cmd() maps the initiator-supplied srp_cmd->task_attr into
cmd->sam_task_attr, but then hands a hardcoded TCM_SIMPLE_TAG to
target_init_cmd().

Pass the already mapped cmd->sam_task_attr instead, so target core sees the
attribute the initiator requested.

Fixes: 9474b043132f ("ib_srpt: Convert I/O path to target_submit_cmd + drop legacy ioctx->kref")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Bart,

I found this during code review, but I'm not sure what the
original intention was.

The Fixes line references the addition of MSG_SIMPLE_TAG as a
hardcoded value. MSG_SIMPLE_TAG was later renamed to TCM_SIMPLE_TAG.

Thanks
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index a22ee4fc1e4c..7197d95f2216 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1602,7 +1602,7 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 
 	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
 			     scsilun_to_int(&srp_cmd->lun), data_len,
-			     TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
+			     cmd->sam_task_attr, dir, TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
 			 srp_cmd->tag);

---
base-commit: 28a06de7318fad1d0dec9bf54fe04243cc0635ff
change-id: 20260721-b4-scsi-ordering-violation-due-to-hardc-42a3335bd169

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

