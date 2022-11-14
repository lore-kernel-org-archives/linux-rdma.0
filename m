Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF50C433FE
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Nov 2022 08:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbiKNIaT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 14 Nov 2022 03:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236444AbiKNIaR (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 14 Nov 2022 03:30:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92041B1F5;
        Mon, 14 Nov 2022 00:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FC1A60F12;
        Mon, 14 Nov 2022 08:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC080C433C1;
        Mon, 14 Nov 2022 08:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668414615;
        bh=M5Go57T18KU3kovwfaSoPQkXTIJ9pU/x8zoi9VefwW4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SdH1QQKcLZQv3AKSNRqZgc4tXzBdMXgXKDuK3MoPQQRFpIYn6+O1nQZvg7Lp1GOYn
         QE742J9xLRn5ra6lGaVDnYoZgTzRjS0XJQSharaM9uVu6TJ//f4uH4suR3r5UAk5PK
         EjsXAoDr8CJU0bttAruYJ+pnYM1kFvmZR3cBw8CkWNisnUsoXW1ZUF1QcRRiDm7Y3L
         oMXJbnHupIRPsjq+jbJhGZzXY9uFf9StdS9G4A+jFvbnURqB8ZwRSbqvO+FUa98HIw
         VRhvftCN3zogKZ7mhH3RYpIiQTD/5vXd1uPM6Tw59jiLpnVXiTCkuHHIHG2JgSWt2/
         SIDKXJb6O8rcQ==
Date:   Mon, 14 Nov 2022 10:30:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Peter Xu <peterx@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Nadav Amit <namit@vmware.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Airlie <airlied@gmail.com>,
        Oded Gabbay <ogabbay@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 10/19] RDMA/umem: remove FOLL_FORCE usage
Message-ID: <Y3H8kys/B4u/gYLe@unreal>
References: <20221107161740.144456-1-david@redhat.com>
 <20221107161740.144456-11-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107161740.144456-11-david@redhat.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Nov 07, 2022 at 05:17:31PM +0100, David Hildenbrand wrote:
> GUP now supports reliable R/O long-term pinning in COW mappings, such
> that we break COW early. MAP_SHARED VMAs only use the shared zeropage so
> far in one corner case (DAXFS file with holes), which can be ignored
> because GUP does not support long-term pinning in fsdax (see
> check_vma_flags()).
> 
> Consequently, FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM is no longer required
> for reliable R/O long-term pinning: FOLL_LONGTERM is sufficient. So stop
> using FOLL_FORCE, which is really only for debugger access.
> 
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/infiniband/core/umem.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Thanks,
Tested-by: Leon Romanovsky <leonro@nvidia.com> # Over mlx4 and mlx5.
