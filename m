Return-Path: <SRS0=Y9Cu=4A=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A902EC2BA83
	for <linux-rdma@archiver.kernel.org>; Wed, 12 Feb 2020 07:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75BB92082F
	for <linux-rdma@archiver.kernel.org>; Wed, 12 Feb 2020 07:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581492418;
	bh=XlAENc0E0pLUTZ/yhAWuOgrGGVihRqX+/++2+MgG4CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LV1DF5iLoe8PH0Txjg5GDKnxZz/DiAJXwgjEpvO+vH+td/GsNgNymD5kuRdTj3OI4
	 yVss2gUvNj/BrS3SiqQd2zbIHMIcxBlosP5/GQZPru6swOAyPGsDCWwkRWcVjA0kov
	 J9sP3YTXwko0tnCfW10CIJLajD33f9AYGhVViVu4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgBLH05 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 12 Feb 2020 02:26:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728242AbgBLH05 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 12 Feb 2020 02:26:57 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B10572073C;
        Wed, 12 Feb 2020 07:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581492416;
        bh=XlAENc0E0pLUTZ/yhAWuOgrGGVihRqX+/++2+MgG4CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDOKQ7Wp4bBgOO5hYaMavl0gpABJBXZbBEmR8PIZ/39yZOWWADd1r6GFT6BVLY6e7
         wEkJ1D+E+2UngGjKBV7CS9pdzzNY0g98SYlhpI2xp6OKwJms25mMBgopBQUU0exdm+
         kZD059cRjyUiZWUspJxVgPlMUFam4t1jhdyztsGs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Maor Gottlieb <maorg@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Valentine Fatiev <valentinef@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Yonatan Cohen <yonatanc@mellanox.com>,
        Zhu Yanjun <yanjunz@mellanox.com>
Subject: [PATCH rdma-rc 5/9] RDMA/core: Add missing list deletion on freeing event queue
Date:   Wed, 12 Feb 2020 09:26:31 +0200
Message-Id: <20200212072635.682689-6-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212072635.682689-1-leon@kernel.org>
References: <20200212072635.682689-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Fix a bug on disassociate flow while deleting the event queues.
Current code has a race between ib_uverbs_free_event_queue() and
ib_uverbs_event_read() which might leave entries in the list and bring
double free.

Fixes: f7c8416ccea5 ("RDMA/core: Simplify destruction of FD uobjects")
Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_std_types.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 994d8744b246..3abfc63225cb 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -220,6 +220,7 @@ void ib_uverbs_free_event_queue(struct ib_uverbs_event_queue *event_queue)
 	list_for_each_entry_safe(entry, tmp, &event_queue->event_list, list) {
 		if (entry->counter)
 			list_del(&entry->obj_list);
+		list_del(&entry->list);
 		kfree(entry);
 	}
 	spin_unlock_irq(&event_queue->lock);
-- 
2.24.1

