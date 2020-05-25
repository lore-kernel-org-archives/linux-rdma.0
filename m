Return-Path: <SRS0=ECiD=7H=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269C6C433E0
	for <linux-rdma@archiver.kernel.org>; Mon, 25 May 2020 17:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CCF12070A
	for <linux-rdma@archiver.kernel.org>; Mon, 25 May 2020 17:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391259AbgEYRWZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 25 May 2020 13:22:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34199 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388230AbgEYRWZ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 25 May 2020 13:22:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id m1so2638820pgk.1
        for <linux-rdma@vger.kernel.org>; Mon, 25 May 2020 10:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lxyYgGy8bZKy6u6XlBysmEGOtyPVXAN2sAVOR27dyiU=;
        b=qIGKQJE8NGhnf9Y6/Ym/YLy/HSou104NZT1rz8+I+S0C2q4fRQyDPC/rFYSNncx3rT
         wIX9E1jE2hWpjuVSJb9FG1nJIabzaHPFfW+0wvVc1hlSVd3RZqzuGdDC7d26PDhuJ4qm
         CnpU9838jpQFmFOCT3QRKd2cpIzd7vKqv3pwolk1oWvBSEre+/aCnGzbTdgZB3p6hwNT
         Dypd77YFHXBWvN8SN+fVPXNnLn8HbabC1jXpszhgEXUT9cuB04H99EAEvY6FRETKTG6y
         oD1572LksmbTQfiRWRRZCqQ6/AcfW74H2yoH773pAIKYgFra2ZKtL8QIHjzpQC4/r7au
         XQ9g==
X-Gm-Message-State: AOAM5326wBsZ7OjiO0Al5VgbmEOejxc0eOzXrNl5V/t332ulG5u9VSjO
        n4547cl0IwLgld21ydnCL1hD5ckX
X-Google-Smtp-Source: ABdhPJzXyDu6BhFYh06Gp7MtUwBbV5pivHv2GOdDdUe8aPeYSyBJjfK7gOqv+jyAZtp5yMWl6fReGA==
X-Received: by 2002:a62:5f84:: with SMTP id t126mr837095pfb.124.1590427344356;
        Mon, 25 May 2020 10:22:24 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:2590:9462:ff8a:101f])
        by smtp.gmail.com with ESMTPSA id p9sm3213238pff.71.2020.05.25.10.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 10:22:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] Four SRP initiator and target patches
Date:   Mon, 25 May 2020 10:22:08 -0700
Message-Id: <20200525172212.14413-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi Jason,

Please consider these four patches for kernel v5.8 or v5.9 (not sure if it is
still possible to include these in v5.8).

Thanks,

Bart.

Changes compared to v1:
- Changed %d into %u in the SRP patch as requested by Leon.
- Simplified patch "RDMA/srpt: Increase max_send_sge".

Bart Van Assche (4):
  RDMA/srp: Make the channel count configurable per target
  RDMA/srpt: Make debug output more detailed
  RDMA/srpt: Reduce max_recv_sge to 1
  RDMA/srpt: Increase max_send_sge

 drivers/infiniband/ulp/srp/ib_srp.c   | 21 ++++++++++++++++-----
 drivers/infiniband/ulp/srpt/ib_srpt.c | 22 +++++++++-------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  5 -----
 3 files changed, 25 insertions(+), 23 deletions(-)

