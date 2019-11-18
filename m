Return-Path: <SRS0=0J7V=ZK=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1E6C432C0
	for <linux-rdma@archiver.kernel.org>; Mon, 18 Nov 2019 19:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7C9E22300
	for <linux-rdma@archiver.kernel.org>; Mon, 18 Nov 2019 19:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfKRTB5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 18 Nov 2019 14:01:57 -0500
Received: from mga05.intel.com ([192.55.52.43]:15449 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfKRTB4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 18 Nov 2019 14:01:56 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Nov 2019 11:01:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,321,1569308400"; 
   d="scan'208";a="407489833"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga006.fm.intel.com with ESMTP; 18 Nov 2019 11:01:56 -0800
Date:   Mon, 18 Nov 2019 11:01:56 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     oulijun <oulijun@huawei.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
Subject: Re: =?utf-8?B?44CQaW5maW5pYmFuZF9kaWFncyB0?=
 =?utf-8?B?b29sIHF1ZXN0aW9u44CR?=
Message-ID: <20191118190155.GA22418@iweiny-DESK2.sc.intel.com>
References: <eca1607e-5c25-f816-9325-281b6a2d0069@huawei.com>
 <20191118172144.GD2149@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118172144.GD2149@ziepe.ca>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Nov 18, 2019 at 01:21:44PM -0400, Jason Gunthorpe wrote:
> On Sat, Nov 16, 2019 at 10:20:19AM +0800, oulijun wrote:
> > Hi, Jason Gunthorpe
> >     I have noticed that you have integrated infiniband_diags in the new rdma-core repo.
> > I want to try to using it in RoCE. it is fail. the print as flows:
> > roo
> > root@(none)# ./ibaddr -g 0
> >  ibwarn: [1054] mad_rpc_open_port: client_register for mgmt 1 failed
> >   Failed to open (null) port 0
> > 
> > I found through process analysis that it needs ca to support IB_QPT_SMI.
> > I understand that if hca does not support SMI, then we will not be able to use infiniband_diags tool?
> 
> I didn't think diags were really relevant for roce? The only thing
> that should work is perfquery

This is correct.   infiniband-diags are not really relevant to RoCE or OPA.
While some tools will work.  They are not specifically designed for nor
intended to support anything other than InfiniBand.

Ira
