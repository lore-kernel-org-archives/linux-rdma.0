Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25790C7EE26
	for <linux-rdma@archiver.kernel.org>; Mon, 15 May 2023 11:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbjEOL4T (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 15 May 2023 07:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239894AbjEOLzb (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 15 May 2023 07:55:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C123C30E0;
        Mon, 15 May 2023 04:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PuPfI1ULNn6nKdgBOgNMBtEbGf2urZOQinv9le4S0tg=; b=IkBBAEfMBi3BnwkUH9a+d6WFrp
        IAP6BVB6s9Sl8NqTDNcoPch40oFg+Og/x7m6XkOUE72+xSzl5ZlI98459I4E/du347IDxCTnReoyr
        2oONv2hE1I3etOOnCSY2vH9ouRwvUXHVKKVE+lKyCxDJ7gkQCHtKzqlDKNWUmE1Pr4uvdovJE5O8U
        aFKw5WRtbNE+EPp9q4TeTUEoP0voDGcBEZNG9WfWZqArILRyyFm3+03au5ftDUPZXH3r+YWAxP/6I
        F2qrkp8eHjEgXrfMbulzU3v+q/5Tn/XUKFTFaEw9mWhCAMnwjbBu1x/P/5q4Wok0/BQJDjF1eLR8M
        Iv7zwhgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pyWis-0022I3-1r;
        Mon, 15 May 2023 11:50:38 +0000
Date:   Mon, 15 May 2023 04:50:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v5 5/6] mm/gup: remove vmas parameter from
 pin_user_pages()
Message-ID: <ZGIcjr2I5FDDKdCZ@infradead.org>
References: <cover.1684097001.git.lstoakes@gmail.com>
 <acd4a8c735c9bc1c736e1a52a9a036db5cc7d462.1684097002.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acd4a8c735c9bc1c736e1a52a9a036db5cc7d462.1684097002.git.lstoakes@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, May 14, 2023 at 10:26:58PM +0100, Lorenzo Stoakes wrote:
> We are now in a position where no caller of pin_user_pages() requires the
> vmas parameter at all, so eliminate this parameter from the function and
> all callers.
> 
> This clears the way to removing the vmas parameter from GUP altogether.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com> (for qib)
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
