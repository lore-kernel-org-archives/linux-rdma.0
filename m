Return-Path: <SRS0=Q14g=5C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B40C10F29
	for <linux-rdma@archiver.kernel.org>; Tue, 17 Mar 2020 14:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D034120724
	for <linux-rdma@archiver.kernel.org>; Tue, 17 Mar 2020 14:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584456887;
	bh=ngm8KfEWZ1w1B8xThy9DYpYXuh5kAXswdWClIoD/HIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WDDlPrr2JFOtp3UZwbsNOlvCbu6+23nq42Cn3h+deKThBN9i/ulmJOVOfij983660
	 rj+ppS/7ai3vaNxvaYtieQ3VmJcJn12+DzCpWVf6sSILoSKp8NZxDeQirGfX9iIXH8
	 aaFHv8znrst2AniETQednIBU0s5jyJE+/A/jWlA8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCQOyc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 17 Mar 2020 10:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgCQOyc (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 17 Mar 2020 10:54:32 -0400
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D12D520777;
        Tue, 17 Mar 2020 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584456871;
        bh=ngm8KfEWZ1w1B8xThy9DYpYXuh5kAXswdWClIoD/HIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcOYly3Lf5sMWTt1SHqcQCOJ2be+l+7v1x0lR+oNLOJZnoULSXxqC+d66FN1D4ruH
         78PPoWLcuYlSFhXtouM3t1+NbSltrOM0gVu0GRxGxNhfQcLJVW9Zf3qZelH8QFjXDL
         0xe9Zj3ptq5C4DCqEQjZXx3Prb9vnUaWp95ZTNE8=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jEDbw-000ANF-T2; Tue, 17 Mar 2020 15:54:28 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: [PATCH 14/17] infiniband: pa_vnic_encap.h: get rid of a warning
Date:   Tue, 17 Mar 2020 15:54:23 +0100
Message-Id: <9dce702510505556d75a13d9641e09218a4b4a65.1584456635.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1584456635.git.mchehab+huawei@kernel.org>
References: <cover.1584456635.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The right markup for a variable is @foo, and not @foo[].

Using a wrong markup caused this warning:

	./drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:243: WARNING: Inline strong start-string without end-string.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
index 0b3570dc606d..d324312a373c 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
@@ -239,7 +239,7 @@ struct opa_veswport_mactable_entry {
  * @offset: mac table starting offset
  * @num_entries: Number of entries to get or set
  * @mac_tbl_digest: mac table digest
- * @tbl_entries[]: Array of table entries
+ * @tbl_entries: Array of table entries
  *
  * The EM sends down this structure in a MAD indicating
  * the starting offset in the forwarding table that this
-- 
2.24.1

