Return-Path: <SRS0=ZuZ5=V5=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CEDC19759
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Aug 2019 17:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E5C820838
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Aug 2019 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564680996;
	bh=GvenivdjQym4RJWmpfBAeFzGEPyGTpgh8taXB3X6VzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CDwfXotKdaPC1Ni9Q6aboY4NVCjp4cHXgfTgZCUfU568sQRm6b7tWg6jolkjjeHtp
	 xMqtxdCPGQNra/OI9Vd+46+xv9Tqp8t+feOsM5rNo5zKbufzLCGKd4QuYHnNuY0zoC
	 BTN8B4LOtQRiea/343RoP3k5h1yX5aGXbBbDUHMI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731456AbfHARgf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 1 Aug 2019 13:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728964AbfHARgf (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 1 Aug 2019 13:36:35 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C4720838;
        Thu,  1 Aug 2019 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564680994;
        bh=GvenivdjQym4RJWmpfBAeFzGEPyGTpgh8taXB3X6VzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tL36zo4LuOs15FmE7yrN8bWYbCjNj7JTMrXm+QcKlXAKM3xiDNG48oE0btVQm+Omc
         9SgPoU7Of9l2WuP0hJAOG8qrCBZ+T5SMELhnUTpZ8+h+uJ9m6LWlJiDRgyn7i+Wcfh
         wDP/c4eESIZmhkL/+eVU/uLgBcPcxv2KZovpvUWE=
Date:   Thu, 1 Aug 2019 20:36:23 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH for-next v2 1/2] RDMA/core: Introduce ratelimited ibdev
 printk functions
Message-ID: <20190801173623.GA4832@mtr-leonro.mtl.com>
References: <20190801171447.54440-1-galpress@amazon.com>
 <20190801171447.54440-2-galpress@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801171447.54440-2-galpress@amazon.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Aug 01, 2019 at 08:14:46PM +0300, Gal Pressman wrote:
> Add ratelimited helpers to the ibdev_* printk functions.
> Implementation inspired by counterpart dev_*_ratelimited functions.
>
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
>  include/rdma/ib_verbs.h | 42 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
