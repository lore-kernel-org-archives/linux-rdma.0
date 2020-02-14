Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229E7C2BA83
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 18:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02ADA222C2
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 18:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389352AbgBNSN5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:13:57 -0500
Received: from mga12.intel.com ([192.55.52.136]:42242 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404252AbgBNSN4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 14 Feb 2020 13:13:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 10:13:56 -0800
X-IronPort-AV: E=Sophos;i="5.70,441,1574150400"; 
   d="scan'208";a="223094698"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.204.146]) ([10.254.204.146])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 14 Feb 2020 10:13:55 -0800
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: RDMA device renames and node description
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Honggang LI <honli@redhat.com>,
        Gal Pressman <galpress@amazon.com>
Message-ID: <5ae69feb-5543-b203-2f1b-df5fe3bdab2b@intel.com>
Date:   Fri, 14 Feb 2020 13:13:53 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Was there any discussion on the upgrade scenario for existing 
deployments as far as device-rename changing node descriptions?

If someone is running an older version of rdma-core they are going to 
have a certain set of node descriptions for each node. This could be in 
logs, or configuration databases, who knows what. Now if they upgrade to 
a new version of rdma-core their node descriptions all automatically 
change out from under them by default.

Of course the admin could disable the rename prior to upgrade and as 
Leon pointed out previously the upgrade won't remove the disablement 
file. The problem is they would have to know to do that ahead of time.

-Denny
