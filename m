Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BABC433E6
	for <linux-rdma@archiver.kernel.org>; Thu, 14 Jan 2021 07:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F79123A34
	for <linux-rdma@archiver.kernel.org>; Thu, 14 Jan 2021 07:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbhANHxs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 14 Jan 2021 02:53:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbhANHxr (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 14 Jan 2021 02:53:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FEC0233FD;
        Thu, 14 Jan 2021 07:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610610787;
        bh=0F42U0eZeDZGaae+KfK3OGJANQenBCHUU8rDIk0xLdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fmXfOt4csLXCahy6nXz2wEKYB9Arb7yGNfdFwYuBBJzXKFsDf2c3SnjS8HBlDXBsO
         otdENtyDk21AJGUiocwySQel9VqErFBeyy8ZWxROGNaeIoQL+smVuuhP2s9HkdFis8
         C2i+1z3hFBKqEUWq2f1fk6IVmWdE8Y/IiFtMH1c+EFO+LgmcMHyIq+uS3dgzUhBXAT
         y8s4crSAGU7hCxm28uLjyDXZiE/KSdnQGc7HTq1NDL0D3p1I8SCvygUqydtrkJh/XF
         j5BbZMRJWd/I5vIHqGaGXORNldVE4EeNPBHd+60gujIbzW65m39Xb0MGBSOP9AZxcI
         jzPTUzq1GMghQ==
Date:   Thu, 14 Jan 2021 09:53:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-core] verbs: Replace SQ with RQ in max_recv_sge's
 documents
Message-ID: <20210114075303.GN4678@unreal>
References: <20210114052337.32316-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114052337.32316-1-yangx.jy@cn.fujitsu.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Jan 14, 2021 at 01:23:37PM +0800, Xiao Yang wrote:
> Fixes: 9845a77c8812 ("Add remaining libibverbs manpages")
> Fixes: 058c67977dad ("XRC man pages")
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---
>  libibverbs/man/ibv_create_qp.3    | 2 +-
>  libibverbs/man/ibv_create_qp_ex.3 | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>

Thanks, merged.
