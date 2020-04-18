Return-Path: <SRS0=5X+a=6C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FF4C2BB1D
	for <linux-rdma@archiver.kernel.org>; Sat, 18 Apr 2020 01:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C2F1221EA
	for <linux-rdma@archiver.kernel.org>; Sat, 18 Apr 2020 01:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgDRBTX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 17 Apr 2020 21:19:23 -0400
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:34468 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725298AbgDRBTX (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 17 Apr 2020 21:19:23 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 0727C18011956;
        Sat, 18 Apr 2020 01:19:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: spark31_6e9dbd1434e32
X-Filterd-Recvd-Size: 2995
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sat, 18 Apr 2020 01:19:20 +0000 (UTC)
Message-ID: <fa9b79743b58559794fb46c933206f16ffa5992d.camel@perches.com>
Subject: Re: [PATCH v9 3/3] MAINTAINERS: add HMM selftests
From:   Joe Perches <joe@perches.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Ralph Campbell <rcampbell@nvidia.com>, linux-rdma@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Shuah Khan <shuah@kernel.org>
Date:   Fri, 17 Apr 2020 18:17:07 -0700
In-Reply-To: <20200417181323.10e263aeb79b51fe5991e3f2@linux-foundation.org>
References: <20200417235458.13462-1-rcampbell@nvidia.com>
         <20200417235458.13462-4-rcampbell@nvidia.com>
         <13a8e8efd56d00945e375760f7f065fb020287a1.camel@perches.com>
         <20200417181323.10e263aeb79b51fe5991e3f2@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, 2020-04-17 at 18:13 -0700, Andrew Morton wrote:
> On Fri, 17 Apr 2020 17:59:03 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > On Fri, 2020-04-17 at 16:54 -0700, Ralph Campbell wrote:
> > > Add files for HMM selftests.
> > > 
> > > Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> > > ---
> > >  MAINTAINERS | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index e64e5db31497..072921b7bae2 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -7729,6 +7729,9 @@ S:	Maintained
> > >  F:	Documentation/vm/hmm.rst
> > >  F:	include/linux/hmm*
> > >  F:	mm/hmm*
> > > +F:	include/uapi/linux/test_hmm*
> > > +F:	lib/test_hmm*
> > > +F:	tools/testing/selftests/vm/*hmm*
> > 
> > file patterns in alphabetic order please:
> > 
> > F	Documentation/vm/hmm.rst
> > F:	include/linux/hmm*
> > F:	include/uapi/linux/test_hmm*
> > F:	lib/test_hmm*
> > F:	mm/hmm*
> > F:	tools/testing/selftests/vm/*hmm*	
> 
> checkpatch rule for this, please ;)

Already sent a few days ago to you ;)

https://lore.kernel.org/lkml/17677130b3ca62d79817e6a22546bad39d7e81b4.camel@perches.com/

And somehow already in -mm too, at least by the email you sent me:

The patch titled
     Subject: checkpatch: additional MAINTAINER section entry ordering checks
has been added to the -mm tree.  Its filename is
     checkpatch-additional-maintainer-section-entry-ordering-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-additional-maintainer-section-entry-ordering-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-additional-maintainer-section-entry-ordering-checks.patch





