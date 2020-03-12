Return-Path: <SRS0=gJYK=45=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42E7C2BB1D
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 06:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BEE420663
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 06:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387889AbgCLG2o (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Mar 2020 02:28:44 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:45052 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387831AbgCLG2o (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 12 Mar 2020 02:28:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id B623C182CED34;
        Thu, 12 Mar 2020 06:28:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: force01_4c0870e44a755
X-Filterd-Recvd-Size: 1322
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Thu, 12 Mar 2020 06:28:42 +0000 (UTC)
Message-ID: <cf74e8fdd3ee99aec86cec4abfdb1ce84b7fd90a.camel@perches.com>
Subject: Re: [PATCH -next 001/491] MELLANOX ETHERNET INNOVA DRIVERS: Use
 fallthrough;
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>
Cc:     borisp@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 11 Mar 2020 23:26:59 -0700
In-Reply-To: <20200311.232302.1442236068172575398.davem@davemloft.net>
References: <cover.1583896344.git.joe@perches.com>
         <605f5d4954fcb254fe6fc5c22dc707f29b3b7405.1583896347.git.joe@perches.com>
         <20200311.232302.1442236068172575398.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, 2020-03-11 at 23:23 -0700, David Miller wrote:
> Joe, please use Subject line subsystem prefixes consistent with what would
> be used for other changes to these drivers.

Not easy to do for scripted patches.
There's no mechanism that scriptable.

I'm not going to hand-edit 500 patches.


