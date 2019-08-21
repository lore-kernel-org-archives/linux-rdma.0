Return-Path: <SRS0=E+a+=WR=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DD1C3A59E
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Aug 2019 12:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20E0122D6D
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Aug 2019 12:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfHUMQB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 21 Aug 2019 08:16:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:12626 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbfHUMQB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 21 Aug 2019 08:16:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 05:15:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="378119052"
Received: from jerryopenix.sh.intel.com (HELO jerryopenix) ([10.239.158.171])
  by fmsmga005.fm.intel.com with ESMTP; 21 Aug 2019 05:16:00 -0700
Date:   Wed, 21 Aug 2019 20:14:36 +0800
From:   "Liu, Changcheng" <changcheng.liu@intel.com>
To:     linux-rdma@vger.kernel.org
Subject: why ibv_wc src_qp is zero
Message-ID: <20190821121436.GA1834@jerryopenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi all,
   Does anyone know the usage of the src_qp field in struct ibv_wc?

   I’m using RC transport type with only Send Operation on Send Queue.
     On the requester side, when SQ WR is finished, there’s one WCE is on CQ. ibv_wc::src_qp is checked with zero value.
     On the responder side, when RQ WR is finished, there’s one WCE is on CQ. ibv_wc::src_qp is checked with zero value too.
   Why the ibv_wc::src_qp field is zero instead of recording the peer's qp number?

--Thanks
Changcheng
