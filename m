Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF120C433DB
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Feb 2021 11:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D0EB64DDA
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Feb 2021 11:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhBJL5e (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Feb 2021 06:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231290AbhBJLz1 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 10 Feb 2021 06:55:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF90E64DE1;
        Wed, 10 Feb 2021 11:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612958086;
        bh=NkQ70ZkvxscxckMQ2MwgVwo/psl5l5YG6x9HSB29rec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U7qVZYCWpqcvYKUVg8cfpI/imqspRTM20kIQ1xqdqOG8act6frojOyF26C8Dkpqv1
         ZuXgcUESXS97oS6mvyIgJxOGFS+LGt3toWzPd0Wyr+fZ4CymwEaaO59jGGd3BtiIQa
         YEh2nnmSOJmjuFtYKeGnzc2pF06ytZ//j5hqPA0rcBgxjZb0E4gIVD8zq73fNhuJ6A
         zFsZvaP4BdFH2tjsHQ1gL5zcffBNVhfI8IF5wSOpVMuswxLDDx+n4aj/0sskBreotC
         5TtIFBxlLXO2iAAME9HmDdRke+I8GE5+GVvDrPmQ9scX8Zr3yQBmOEQBEGfTS4WRri
         cSgWqsYZpaaeA==
Date:   Wed, 10 Feb 2021 13:54:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Honggang Li <honli@redhat.com>
Cc:     Itay Aveksis <itayav@nvidia.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Alaa Hleihel <alaa@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>
Subject: Re: rdma-core spec weird behavior on Fedora
Message-ID: <20210210115442.GB741034@unreal>
References: <20210207080649.GB4656@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207080649.GB4656@unreal>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Feb 07, 2021 at 10:06:49AM +0200, Leon Romanovsky wrote:
> Hi Honggang,
>
> Your commit b02de521022a ("redhat: Remove base package dependency from all sub-packages")
> removes protection from rdma-core when user performs "dnf autoremove".
>
> Before your patch, systemd was dependent on libibverbs and latter
> required rdma-core. After your patch, the last link is lost and
> rdma-core marked as orphaned package.
>
> Any attempt to install rdma-core as standalone package will have the
> following errors, due to the library dependency of udevadm.
> [leonro@c rdma-core]$ ldd /sbin/udevadm | grep verbs
> 	libibverbs.so.1 => not found

ok, the root cause for that was found - broken installation of libpcap.

Thanks
