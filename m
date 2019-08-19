Return-Path: <SRS0=Wuup=WP=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA429C3A5A0
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Aug 2019 16:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFD5922CE9
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Aug 2019 16:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfHSQ4Y (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 19 Aug 2019 12:56:24 -0400
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:58363 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726525AbfHSQ4Y (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 19 Aug 2019 12:56:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 97F20180A7F8C;
        Mon, 19 Aug 2019 16:56:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: twist55_71b833439d92c
X-Filterd-Recvd-Size: 2537
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Mon, 19 Aug 2019 16:56:21 +0000 (UTC)
Message-ID: <581e7d79ed75484beb227672b2695ff14e1f1e34.camel@perches.com>
Subject: Re: [PATCH] RDMA/siw: Fix compiler warnings on 32-bit due to
 u64/pointer abuse
From:   Joe Perches <joe@perches.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 19 Aug 2019 09:56:20 -0700
In-Reply-To: <20190819100526.13788-1-geert@linux-m68k.org>
References: <20190819100526.13788-1-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, 2019-08-19 at 12:05 +0200, Geert Uytterhoeven wrote:
> When compiling on 32-bit:
> 
>     drivers/infiniband/sw/siw/siw_cq.c:76:20: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>     drivers/infiniband/sw/siw/siw_qp.c:952:28: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
[]
> Fix this by applying the following rules:
>   1. When printing a u64, the %llx format specififer should be used,
>      instead of casting to a pointer, and printing the latter.
>   2. When assigning a pointer to a u64, the pointer should be cast to
>      uintptr_t, not u64,
>   3. When casting from u64 to pointer, an intermediate cast to uintptr_t
>      should be added,

I think a cast to unsigned long is rather more common.

uintptr_t is used ~1300 times in the kernel.
I believe a cast to unsigned long is much more common.

It might be useful to add something to the Documentation
for this style.  Documentation/process/coding-style.rst

And trivia:

> > diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
[]
> @@ -842,8 +842,8 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
>  			rv = -EINVAL;
>  			break;
>  		}
> -		siw_dbg_qp(qp, "opcode %d, flags 0x%x, wr_id 0x%p\n",
> -			   sqe->opcode, sqe->flags, (void *)sqe->id);
> +		siw_dbg_qp(qp, "opcode %d, flags 0x%x, wr_id 0x%llx\n",
> +			   sqe->opcode, sqe->flags, sqe->id);

Printing possible pointers as %llx is generally not a good idea
given the desire for %p obfuscation.


