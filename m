Return-Path: <SRS0=E+a+=WR=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B82C41514
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Aug 2019 21:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE8DB22DD3
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Aug 2019 21:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbfHUVrb (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 21 Aug 2019 17:47:31 -0400
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:51270 "EHLO
        emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbfHUVrb (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 21 Aug 2019 17:47:31 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Aug 2019 17:47:30 EDT
Received: from darkstar.musicnaut.iki.fi (85-76-66-34-nat.elisa-mobile.fi [85.76.66.34])
        by emh02.mail.saunalahti.fi (Postfix) with ESMTP id A7EC92002C;
        Thu, 22 Aug 2019 00:39:18 +0300 (EEST)
Date:   Thu, 22 Aug 2019 00:39:18 +0300
From:   Aaro Koskinen <aaro.koskinen@iki.fi>
To:     Geert Uytterhoeven <geert@linux-m68k.org>, Qian Cai <cai@lca.pw>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>
Subject: Re: Build regressions/improvements in v5.3-rc5
Message-ID: <20190821213918.GE30291@darkstar.musicnaut.iki.fi>
References: <20190819081157.9736-1-geert@linux-m68k.org>
 <CAMuHMdV11Km7yF3gk5uTrPS1mVhjMdkbg28QRymcYyBPiAMBMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV11Km7yF3gk5uTrPS1mVhjMdkbg28QRymcYyBPiAMBMw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi,

On Mon, Aug 19, 2019 at 11:07:49AM +0200, Geert Uytterhoeven wrote:
> On Mon, Aug 19, 2019 at 10:47 AM Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > JFYI, when comparing v5.3-rc5[1] to v5.3-rc4[3], the summaries are:
> >   - build errors: +7/-0
> 
>   + /kisskb/src/include/asm-generic/5level-fixup.h: error: unknown
> type name 'pgd_t'; did you mean 'pid_t'?:  => 14:18
>   + /kisskb/src/include/asm-generic/pgtable.h: error: implicit
> declaration of function 'p4d_bad'; did you mean 'pgd_bad'?
> [-Werror=implicit-function-declaration]:  => 580:15
>   + /kisskb/src/include/asm-generic/pgtable.h: error: implicit
> declaration of function 'p4d_bad'; did you mean 'pud_bad'?
> [-Werror=implicit-function-declaration]:  => 580:15
>   + /kisskb/src/include/asm-generic/pgtable.h: error: implicit
> declaration of function 'p4d_none'; did you mean 'pgd_none'?
> [-Werror=implicit-function-declaration]:  => 578:6
>   + /kisskb/src/include/asm-generic/pgtable.h: error: implicit
> declaration of function 'p4d_none'; did you mean 'pud_none'?
> [-Werror=implicit-function-declaration]:  => 578:6
> 
> parisc-defconfig

This commit broke PA-RISC build:

0cfaee2af3a04c0be5f056cebe5f804dedc59a43 is the first bad commit
commit 0cfaee2af3a04c0be5f056cebe5f804dedc59a43
Author: Qian Cai <cai@lca.pw>
Date:   Tue Aug 13 15:37:47 2019 -0700  

    include/asm-generic/5level-fixup.h: fix variable 'p4d' set but not used

A.
