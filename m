Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3737AC4361B
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Dec 2020 09:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E397D2076A
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Dec 2020 09:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439532AbgLNJCk (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 14 Dec 2020 04:02:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgLNJCj (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 14 Dec 2020 04:02:39 -0500
Date:   Mon, 14 Dec 2020 11:01:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607936518;
        bh=GcOhNVdQmrgHVf4XeQtTaOB2sUBRIMVjsT+3deKcxlQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=CSjf1INxcPCeWJVLVpGnZQ3DrOsPizWU4IT0nzdIwzqOQWEFagN/Pi2YSbWcS0l+b
         a0VkYKy1hThpTm6MbggpXUvmsbHSjKiJSkYQ6/GXeTo+EM0S+aybhhTpG2rPyk4XVh
         XFa87HE66YM11otM2/+S1A7nJVPJJe5Aw/7X5HRTtqFktTYxMddjEZi05pCeE/R3yb
         nJ9WmCIRnRFefvc7i/p4YNtyBvkwii6fwSSkBP5YCs7pk2aTs0yLkztReEMsS27BlG
         eKXsEbj5IiZxmUh91eBGVA5XRy67ltLGZccSzw7rkX+Q1JkqXEvC7SYfN9EXBggnYH
         kUZzmd/NFRCbQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-core] rdma_server: Add '-s' option in rdma_server's
 manual
Message-ID: <20201214090154.GD5005@unreal>
References: <20201211065910.1473270-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211065910.1473270-1-yangx.jy@cn.fujitsu.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Dec 11, 2020 at 02:59:10PM +0800, Xiao Yang wrote:
> Fixes: 519d8d7aa965 ("librdmacm: Add command line option to specify server")
> Fixes: cdea72a1e7e6 ("librdmacm: Change server default address to any address.")
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---
>  librdmacm/man/rdma_server.1 | 4 ++++
>  1 file changed, 4 insertions(+)
>

Thanks, applied to rdma-core.
