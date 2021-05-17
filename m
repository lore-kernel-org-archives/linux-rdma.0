Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815B1C433B4
	for <linux-rdma@archiver.kernel.org>; Mon, 17 May 2021 10:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67E1D60249
	for <linux-rdma@archiver.kernel.org>; Mon, 17 May 2021 10:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhEQKH7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 17 May 2021 06:07:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230157AbhEQKH6 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 17 May 2021 06:07:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621246002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=fDWgu7zRqU5OscEqboB6UJSY5/QjkXjxVlct7KnWcQQ=;
        b=XY7JfhCc1c149OvDsu+xk+fSRBTxxRT77r1wkd2O/8ArQKXoDVmPsXzmxsIF1dG9SNdRTX
        YPIkoawRB2DEFYSOkOFZ4lfu8TEeHB+pSky6cwINou+qS14zawSXQyX3GpyOOmu2tbts8J
        ppCtRV6inXrbKZbO0Hf3qEjrqLpzN5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-XuG-Wlh_OaiivpTOzYYZyQ-1; Mon, 17 May 2021 06:06:40 -0400
X-MC-Unique: XuG-Wlh_OaiivpTOzYYZyQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11D1A8018A1;
        Mon, 17 May 2021 10:06:39 +0000 (UTC)
Received: from work-vm (ovpn-114-233.ams2.redhat.com [10.36.114.233])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62F26100EBAF;
        Mon, 17 May 2021 10:06:38 +0000 (UTC)
Date:   Mon, 17 May 2021 11:06:35 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     linux-rdma@vger.kernel.org
Cc:     lizhijian@fujitsu.com
Subject: rdma_get_cm_event error behaviour defined?
Message-ID: <YKJAKy1oNcTd7sRn@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.0.6 (2021-03-06)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi,
  Is 'rdma_get_cm_event's behaviour in initialising **event
defined in the error case?
  We don't see anything in the manual page, my reading of the
code is it's not set/changed in the case of failure - but is
that defined?
  It would be good if the manpage could explicitly state it.

Dave
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

