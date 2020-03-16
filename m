Return-Path: <SRS0=9EqX=5B=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AECC18E5B
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Mar 2020 16:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E40120658
	for <linux-rdma@archiver.kernel.org>; Mon, 16 Mar 2020 16:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbgCPQUi (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 16 Mar 2020 12:20:38 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:36012 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732065AbgCPQUi (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 16 Mar 2020 12:20:38 -0400
Received: from localhost (pvp1.blr.asicdesigners.com [10.193.80.26])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02GGKANd004594;
        Mon, 16 Mar 2020 09:20:11 -0700
Date:   Mon, 16 Mar 2020 21:50:10 +0530
From:   Krishnamraju Eraparaju <krishna2@chelsio.com>
To:     Bernard Metzler <BMT@zurich.ibm.com>, sagi@grimberg.me, hch@lst.de
Cc:     linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>
Subject: broken CRCs at NVMeF target with SIW & NVMe/TCP transports
Message-ID: <20200316162008.GA7001@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


I'm seeing broken CRCs at NVMeF target while running the below program
at host. Here RDMA transport is SoftiWARP, but I'm also seeing the
same issue with NVMe/TCP aswell.

It appears to me that the same buffer is being rewritten by the
application/ULP before getting the completion for the previous requests.
getting the completion for the previous requests. HW based
HW based trasports(like iw_cxgb4) are not showing this issue because
they copy/DMA and then compute the CRC on copied buffer.

Please share your thoughts/comments/suggestions on this.

Commands used:
--------------
#nvme connect -t tcp -G -a 102.1.1.6 -s 4420 -n nvme-ram0  ==> for
NVMe/TCP
#nvme connect -t rdma -a 102.1.1.6 -s 4420 -n nvme-ram0 ==> for
SoftiWARP
#mkfs.ext3 -F /dev/nvme0n1 (issue occuring frequency is more with ext3
than ext4)
#mount /dev/nvme0n1 /mnt
#Then run the below program:
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main() {
	int i;
	char* line1 = "123";
	FILE* fp;
	while(1) {
		fp = fopen("/mnt/tmp.txt", "w");
		setvbuf(fp, NULL, _IONBF, 0);
		for (i=0; i<100000; i++)
		     if ((fwrite(line1, 1, strlen(line1), fp) !=
strlen(line1)))
			exit(1);

		if (fclose(fp) != 0)
			exit(1);
	}
return 0;
}

DMESG at NVMe/TCP Target:
[  +5.119267] nvmet_tcp: queue 2: cmd 83 pdu (6) data digest error: recv
0xb1acaf93 expected 0xcd0b877d
[  +0.000017] nvmet: ctrl 1 fatal error occurred!


Thanks,
Krishna.
