Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B494CC433E6
	for <linux-rdma@archiver.kernel.org>; Sat, 16 Jan 2021 00:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83A0C23382
	for <linux-rdma@archiver.kernel.org>; Sat, 16 Jan 2021 00:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbhAPAhe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 15 Jan 2021 19:37:34 -0500
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:43020 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726065AbhAPAhd (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 15 Jan 2021 19:37:33 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id BFD1A100E7B42;
        Sat, 16 Jan 2021 00:36:52 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: day57_5c1857427533
X-Filterd-Recvd-Size: 3101
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Sat, 16 Jan 2021 00:36:51 +0000 (UTC)
Message-ID: <5eb794b9c9bca0494d94b2b209f1627fa4e7b555.camel@perches.com>
Subject: [PATCH V2] RDMA: usnic: Fix misuse of sysfs_emit_at
From:   Joe Perches <joe@perches.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Date:   Fri, 15 Jan 2021 16:36:50 -0800
In-Reply-To: <6af0a6562b67a24e6233ed360189ba8071243035.camel@HansenPartnership.com>
References: <f4ce30f297be4678634b5be4917401767ee6ebc5.camel@perches.com>
         <6af0a6562b67a24e6233ed360189ba8071243035.camel@HansenPartnership.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

In commit e28bf1f03b01 ("RDMA: Convert various random sprintf sysfs _show
uses to sysfs_emit") I mistakenly used len = sysfs_emit_at to overwrite
the last trailing space of potentially multiple entry output.

Instead use a more common style by removing the trailing space from the
output formats and adding a prefixing space to the contination formats and
converting the final terminating output newline from the defective
	len = sysfs_emit_at(buf, len, "\n");
to the now appropriate and typical
	len += sysfs_emit_at(buf, len, "\n");

Fixes: e28bf1f03b01 ("RDMA: Convert various random sprintf sysfs _show uses to sysfs_emit")

Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
index e59615a4c9d9..586b0e52ba7f 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
@@ -214,7 +214,7 @@ static ssize_t summary_show(struct usnic_ib_qp_grp *qp_grp, char *buf)
 	struct usnic_vnic_res *vnic_res;
 	int len;
 
-	len = sysfs_emit(buf, "QPN: %d State: (%s) PID: %u VF Idx: %hu ",
+	len = sysfs_emit(buf, "QPN: %d State: (%s) PID: %u VF Idx: %hu",
 			 qp_grp->ibqp.qp_num,
 			 usnic_ib_qp_grp_state_to_string(qp_grp->state),
 			 qp_grp->owner_pid,
@@ -224,14 +224,13 @@ static ssize_t summary_show(struct usnic_ib_qp_grp *qp_grp, char *buf)
 		res_chunk = qp_grp->res_chunk_list[i];
 		for (j = 0; j < res_chunk->cnt; j++) {
 			vnic_res = res_chunk->res[j];
-			len += sysfs_emit_at(
-				buf, len, "%s[%d] ",
+			len += sysfs_emit_at(buf, len, " %s[%d]",
 				usnic_vnic_res_type_to_str(vnic_res->type),
 				vnic_res->vnic_idx);
 		}
 	}
 
-	len = sysfs_emit_at(buf, len, "\n");
+	len += sysfs_emit_at(buf, len, "\n");
 
 	return len;
 }

