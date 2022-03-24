Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0A0C433F5
	for <linux-rdma@archiver.kernel.org>; Thu, 24 Mar 2022 14:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348188AbiCXOrN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 24 Mar 2022 10:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbiCXOrN (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 24 Mar 2022 10:47:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3686AA02A
        for <linux-rdma@vger.kernel.org>; Thu, 24 Mar 2022 07:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60B39B82406
        for <linux-rdma@vger.kernel.org>; Thu, 24 Mar 2022 14:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C575C340ED;
        Thu, 24 Mar 2022 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648133137;
        bh=UypcQSvZYzuJuDjgwYcFxaF/cdj0H0bJTLW6Rz1rtIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kP9K6gYG1MbFGDjNmTOGbOmJ2KEjlah4Y8y3ovdtVYNe9o0xslQrB7IKZlU5u1ykb
         JM2Qlpa2+j9gqhS8C7SFm+dxA+/Isq9jUEpZ4cWxVl/yGlrl7jm8pQsHUnkW0G8/Td
         1IXgqpULVD4De4vEZ/LrxBntrxkyAeUtTfIwBoA9FEIo5rONGJwKa+wd1QhOF1NUzN
         QENT40hePXsmpknQLrttlatRzrvzd+CMkDul3AHvLxFcdfvZFWNklWP8qlwkrQYGpT
         8I/hIJS8L5QAN9jcL0/A8/BU1LiVQej0PmVy32kuMxNL/7uBsGATttgSFK7gT0IixQ
         ZBWPuzO6yQObg==
Date:   Thu, 24 Mar 2022 16:45:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Latecki, Karol" <karol.latecki@intel.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Honggang Li <honli@redhat.com>,
        Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.de>,
        Benjamin Drung <benjamin.drung@ionos.com>
Subject: Re: Question about v37 and v38 minor releases
Message-ID: <YjyEDYtw7Rrf2JfB@unreal>
References: <DM4PR11MB5549E169E3C06766D347A936E7119@DM4PR11MB5549.namprd11.prod.outlook.com>
 <DM4PR11MB55492CF07DCC8105204D39AFE7119@DM4PR11MB5549.namprd11.prod.outlook.com>
 <DM4PR11MB55494BCEA81DCEB6FED81834E7119@DM4PR11MB5549.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR11MB55494BCEA81DCEB6FED81834E7119@DM4PR11MB5549.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Mar 16, 2022 at 09:34:19AM +0000, Latecki, Karol wrote:
> Hello!
> 
> I would like to ask if there are any plans or ETAs for rdma-core v37 and v38 minor release? Our team is waiting for 4c905646de3e75bdccada4abe9f0d273d76eaf50 "mlx5: Initialize wr_data when post a work request" to be upstreamed to package repositories like yum or dnf.

Usually request to create stable branch comes from package managers itself.

RedHat - Honggang Li <honli@redhat.com>
SuSE - Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.de>
Debian - Benjamin Drung <benjamin.drung@ionos.com>

They manage rdma-core packages in relevant package repositories.

Thanks


> Apologies for low-importance question, but I did not find any road map or other communication channel on rdma-core github site.
> 
> Thank you!
> Karol Latecki
