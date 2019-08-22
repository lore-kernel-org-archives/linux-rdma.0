Return-Path: <SRS0=XaP6=WS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81462C3A5A1
	for <linux-rdma@archiver.kernel.org>; Thu, 22 Aug 2019 13:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 502C2233FE
	for <linux-rdma@archiver.kernel.org>; Thu, 22 Aug 2019 13:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566479312;
	bh=4IviL14auycRDJWpnfwLkOCo4p6BfOorEeJOXicEO8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LUhwMH77uf/w7lkVb3qCOHX1/APt3uO2x2F4W5tWmQGi42bm8PAyGbcPuvRdSvIIe
	 7lr9AYKLto3QxOMXjhY/DAdYFKPDfkF6RO+TuHJ5dcc4LzqD2utE7y1mtMewDNA7yh
	 CnUb4+QFdA4Me/Ujbr3FlW2nHZD22YsCNcwfkTMc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388852AbfHVNIb (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387491AbfHVNIb (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 22 Aug 2019 09:08:31 -0400
Received: from localhost (unknown [12.235.16.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C870C2173E;
        Thu, 22 Aug 2019 13:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566479310;
        bh=4IviL14auycRDJWpnfwLkOCo4p6BfOorEeJOXicEO8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IJuAdDRsUjttCTtoVc0SDomhxTIvvN8h+WTZhdu8jzXtMIIYelaWDA0gteB46FHvc
         0yldd3EG1VClT5J8tRVjeWOzp1CXt42pZTZ/uK8VXCZIpwJ+MG1ESx/xSLzym2WEe8
         kwpdhFFyZw57f8jloFbxUOYgKR26GXuBPnaJcC2I=
Date:   Thu, 22 Aug 2019 16:08:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bernard Metzler <bmt@zurich.ibm.com>
Cc:     linux-rdma@vger.kernel.org, jgg@ziepe.ca, geert@linux-m68k.org
Subject: Re: [PATCH v2] RDMA/siw: fix 64/32bit pointer inconsistency
Message-ID: <20190822130829.GE29433@mtr-leonro.mtl.com>
References: <20190820172221.6274-1-bmt@zurich.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820172221.6274-1-bmt@zurich.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Aug 20, 2019 at 07:22:21PM +0200, Bernard Metzler wrote:
> Fixes improper casting between addresses and unsigned types.
> Changes siw_pbl_get_buffer() function to return appropriate
> dma_addr_t, and not u64.
>
> In debug prints, all potentially kernel private variables
> are printed as void * to allow keeping that information
> secret.

It is done by using %pK and not by strange casting.
https://elixir.bootlin.com/linux/v5.3-rc5/source/Documentation/core-api/printk-formats.rst#L113

Thanks
