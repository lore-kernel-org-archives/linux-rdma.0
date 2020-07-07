Return-Path: <SRS0=ppJa=AS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2AAC433DF
	for <linux-rdma@archiver.kernel.org>; Tue,  7 Jul 2020 13:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8761A20771
	for <linux-rdma@archiver.kernel.org>; Tue,  7 Jul 2020 13:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LG3Hwvg8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgGGNJq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 7 Jul 2020 09:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGGNJq (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 7 Jul 2020 09:09:46 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF59C061755
        for <linux-rdma@vger.kernel.org>; Tue,  7 Jul 2020 06:09:46 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z13so45076198wrw.5
        for <linux-rdma@vger.kernel.org>; Tue, 07 Jul 2020 06:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ecfWyONlEDs9k0M6+TT9u76Wc/nr2pVhj2iAIsymiGw=;
        b=LG3Hwvg89M4BxcOHQG4lSAhu0k0CVWdS46iJDO0BGGgrSQlRcCZ+p3uDyCemzJtytW
         7zwRGMHc4c5qq+YvJBXiTOz8pvfxwREACUe/nFQC9BiDqaFYgBsm/z/Nd2sHhFx4R+55
         RZrgkykuTMQZvFlEom/Yz6oF86hs+wvcyN+jwCoBwVzGos7bvCwVOkOPf33j9ouTrHmp
         ilAB2DRpnsq+mGCdDsDhcFPQuBSU8fGrWytoLmj9IvlCv2g6LkZ4GqNfmfH7sMypuz+c
         VuGGjs5A/i8KWHxCQcoAn8cPtCWIe3e6RTVDiCafRcv3pdtYohWYqUgoVQmJj+7LGB/7
         FGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ecfWyONlEDs9k0M6+TT9u76Wc/nr2pVhj2iAIsymiGw=;
        b=mDL0af9V+UhMprTFB1DZiRdcRiCu5lrMcFGXRr7NN8YjqfG42/S2fXaFYOduN2yJyx
         /z8ndBQSgOMnCi7eBk0eRhfHxeDirJALwXUQ0hMyPZxTzvBvB9pW+Kb6LWCliDGTGLdg
         DvkZQY+vkIkvTApKuyCNGV6Jt0jjSGOzelep3OJWkanQ3Iw+nu+MBG8681+HoKWg5ouQ
         8q/jlwy3gQzpXWXRlis5B7qhP0hl/O5ySfQHQuK7cKnS3ve0FKho+OOAfxDo7qmwJ0kQ
         0kjQC/IuqFGYAj3HKesV1Nchr5sZunXIyK+0E03OR9Dx+eq/IFZOP/Lcad+md/nd4Y+R
         6yNQ==
X-Gm-Message-State: AOAM533TmnlgCVcNYq0pzTur25ieTNI9JYQ1QFCuioNlajA8aaBU9CUG
        QiXKbl6/bT624O+4eXVvFptfr5WV35c=
X-Google-Smtp-Source: ABdhPJxSFS88qIkr+VR3dSI6LcXRIy5qaJKOaTXn/Fu+oqcx08+ufQDNhTnqxn1sl24UCEDFyg2NzQ==
X-Received: by 2002:a5d:504b:: with SMTP id h11mr52599317wrt.160.1594127384165;
        Tue, 07 Jul 2020 06:09:44 -0700 (PDT)
Received: from localhost.localdomain ([37.142.6.100])
        by smtp.gmail.com with ESMTPSA id r8sm941599wrp.40.2020.07.07.06.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 06:09:43 -0700 (PDT)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     linux-rdma@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATCH for-rc] RDMA/siw: Fix reporting vendor_part_id
Date:   Tue,  7 Jul 2020 16:09:31 +0300
Message-Id: <20200707130931.444724-1-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Move the initialization of the vendor_part_id to be before calling
ib_register_device(), this is needed because the query_device() callback
is called from the context of ib_register_device() before initializing
the vendor_part_id, so the reported value is wrong.

Fixes: bdcf26bf9b3a ("rdma/siw: network and RDMA core interface")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 drivers/infiniband/sw/siw/siw_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index a0b8cc643c5c..ed60c9e4643e 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -67,12 +67,13 @@ static int siw_device_register(struct siw_device *sdev, const char *name)
 	static int dev_id = 1;
 	int rv;
 
+	sdev->vendor_part_id = dev_id++;
+
 	rv = ib_register_device(base_dev, name);
 	if (rv) {
 		pr_warn("siw: device registration error %d\n", rv);
 		return rv;
 	}
-	sdev->vendor_part_id = dev_id++;
 
 	siw_dbg(base_dev, "HWaddr=%pM\n", sdev->netdev->dev_addr);
 
-- 
2.25.4

