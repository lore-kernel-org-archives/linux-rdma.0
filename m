Return-Path: <SRS0=baGF=AU=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5283EC433E0
	for <linux-rdma@archiver.kernel.org>; Thu,  9 Jul 2020 23:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D7A6206DF
	for <linux-rdma@archiver.kernel.org>; Thu,  9 Jul 2020 23:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594337453;
	bh=Bv/ub4CQqHwvYCfl+YYJjzybFA59mDcgMIlvajDLMI4=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=vIbkasaTuuUTT3bFFM96vT9Jou1YjLz1UYx3NXWoIPE+2ZWMja01pl0kEyqs0nl5B
	 u7B2631XAgD7a4A1V8Q7Rgw4RP1L1vr8P2F+39mycE0CtJe7xhb6eOfdiIEG2o71bm
	 V4z24obxlXPPPLLUc6COZnoumeImRjb2d3gse4ME=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGIXaw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 9 Jul 2020 19:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgGIXaw (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 9 Jul 2020 19:30:52 -0400
Received: from embeddedor (unknown [201.162.245.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A172064B;
        Thu,  9 Jul 2020 23:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594337451;
        bh=Bv/ub4CQqHwvYCfl+YYJjzybFA59mDcgMIlvajDLMI4=;
        h=Date:From:To:Cc:Subject:From;
        b=TovEyNTrcUkiwQ8FzBnAzVv3mTlzmedw6jUKrgrjKJZiS82whlgAyFBh4AX5WtACH
         m23su+pUhI9nmju/CyONCbYFZ1YwJIldT1MjeM1GZkNj1mMLUKHQyboEzH2NC216W7
         S9QSkvjSymBGiQZ7CeYfj6rTe5U3VRTFM2dBzha8=
Date:   Thu, 9 Jul 2020 18:36:23 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] IB/hfi1: Remove unnecessary fall-through markings
Message-ID: <20200709233623.GA21949@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Reorganize the code a bit in a more standard way[1] and remove
unnecessary fall-through markings.

[1] https://lore.kernel.org/lkml/20200708054703.GR207186@unreal/

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 15f9c635f292..674c07590af8 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -7317,11 +7317,11 @@ static u16 link_width_to_bits(struct hfi1_devdata *dd, u16 width)
 	case 1: return OPA_LINK_WIDTH_1X;
 	case 2: return OPA_LINK_WIDTH_2X;
 	case 3: return OPA_LINK_WIDTH_3X;
+	case 4: return OPA_LINK_WIDTH_4X;
 	default:
 		dd_dev_info(dd, "%s: invalid width %d, using 4\n",
 			    __func__, width);
-		/* fall through */
-	case 4: return OPA_LINK_WIDTH_4X;
+		return OPA_LINK_WIDTH_4X;
 	}
 }
 
@@ -12898,10 +12898,6 @@ u32 chip_to_opa_pstate(struct hfi1_devdata *dd, u32 chip_pstate)
 {
 	/* look at the HFI meta-states only */
 	switch (chip_pstate & 0xf0) {
-	default:
-		dd_dev_err(dd, "Unexpected chip physical state of 0x%x\n",
-			   chip_pstate);
-		/* fall through */
 	case PLS_DISABLED:
 		return IB_PORTPHYSSTATE_DISABLED;
 	case PLS_OFFLINE:
@@ -12914,6 +12910,10 @@ u32 chip_to_opa_pstate(struct hfi1_devdata *dd, u32 chip_pstate)
 		return IB_PORTPHYSSTATE_LINKUP;
 	case PLS_PHYTEST:
 		return IB_PORTPHYSSTATE_PHY_TEST;
+	default:
+		dd_dev_err(dd, "Unexpected chip physical state of 0x%x\n",
+			   chip_pstate);
+		return IB_PORTPHYSSTATE_DISABLED;
 	}
 }
 
-- 
2.27.0

