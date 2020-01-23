Return-Path: <SRS0=WZnQ=3M=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97D6C2D0DB
	for <linux-rdma@archiver.kernel.org>; Thu, 23 Jan 2020 14:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A54FD20663
	for <linux-rdma@archiver.kernel.org>; Thu, 23 Jan 2020 14:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fx8ICKuq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgAWOVp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 23 Jan 2020 09:21:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726729AbgAWOVp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 23 Jan 2020 09:21:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579789304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6tvgV6jKeZKUrbbq5PcayldOx0aVLnrvrrvKpMHcZsA=;
        b=Fx8ICKuqjOs1iVZ4dwMULrlupE6MffVwivbj2KG1yt31tJT0mudDWpJoYE7+WpcJ4R9DEQ
        lbOh29DB2QyX/gAzV/QXZplnOIR1jGO6fMjE4i+KU8YWJPX0i0ZsQKnitGWIJ+I5k/U8ee
        3hFjQtGhrqPPQXd2hdsuPjVvBOa2JqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-LcQJ2pJuM_qBEIvfMVWmcw-1; Thu, 23 Jan 2020 09:21:39 -0500
X-MC-Unique: LcQJ2pJuM_qBEIvfMVWmcw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A01FBDB60;
        Thu, 23 Jan 2020 14:21:38 +0000 (UTC)
Received: from localhost (unknown [10.66.128.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C8E25DA87;
        Thu, 23 Jan 2020 14:21:37 +0000 (UTC)
Date:   Thu, 23 Jan 2020 22:21:35 +0800
From:   Honggang LI <honli@redhat.com>
To:     "Hefty, Sean" <sean.hefty@intel.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: resource leak in librdmacm
Message-ID: <20200123142135.GA171304@dhcp-128-72.nay.redhat.com>
References: <20200121122133.GA105701@dhcp-128-72.nay.redhat.com>
 <BYAPR11MB3272F4913688AE9B3BFF815C9E0D0@BYAPR11MB3272.namprd11.prod.outlook.com>
 <20200122085655.GA126224@dhcp-128-72.nay.redhat.com>
 <20200122152258.GA142196@dhcp-128-72.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122152258.GA142196@dhcp-128-72.nay.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Jan 22, 2020 at 11:23:02PM +0800, Honggang LI wrote:

> void test_fini(void)
> {


> 	if (handle)
> 		dlclose(handle);
                ^^^^^^^
> 	handle = NULL;

In case we did not call dlclose, there will be only one file descriptor
leak. It will reduce the file descriptor leak.

Does that imply librdamcm was designed to load once and only unload when
process exit?

thanks


