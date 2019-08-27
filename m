Return-Path: <SRS0=5TNZ=WX=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40875C3A5A3
	for <linux-rdma@archiver.kernel.org>; Tue, 27 Aug 2019 18:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20C8D2070B
	for <linux-rdma@archiver.kernel.org>; Tue, 27 Aug 2019 18:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfH0SdZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 27 Aug 2019 14:33:25 -0400
Received: from smtprelay0123.hostedemail.com ([216.40.44.123]:41458 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730424AbfH0SdZ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 27 Aug 2019 14:33:25 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id A828E1805A801;
        Tue, 27 Aug 2019 18:33:23 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id CEC63182CF666;
        Tue, 27 Aug 2019 18:33:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: toad20_7493a051a5231
X-Filterd-Recvd-Size: 3368
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Tue, 27 Aug 2019 18:33:20 +0000 (UTC)
Message-ID: <b0fe444622e32af6c34f3326e5dce3513adf5113.camel@perches.com>
Subject: Re: [PATCH] RDMA/siw: Fix compiler warnings on 32-bit due to
 u64/pointer abuse
From:   Joe Perches <joe@perches.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     David Laight <David.Laight@aculab.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Tue, 27 Aug 2019 11:33:19 -0700
In-Reply-To: <CAMuHMdW0jEpE3YrA5Znq8O9e4eswARwYYerEhRLSLWxeXMbsEQ@mail.gmail.com>
References: <20190819100526.13788-1-geert@linux-m68k.org>
         <581e7d79ed75484beb227672b2695ff14e1f1e34.camel@perches.com>
         <CAMuHMdVh8dwd=77mHTqG80_D8DK+EtVGewRUJuaJzK1qRYrB+w@mail.gmail.com>
         <dbc03b4ac1ef4ba2a807409676cf8066@AcuMS.aculab.com>
         <CAMuHMdWHGTMwK+PO_BgsNZMpqRat1SHE-_CP0UqxEALA_OJeNg@mail.gmail.com>
         <20190827174639.GT1131@ZenIV.linux.org.uk>
         <CAMuHMdW0jEpE3YrA5Znq8O9e4eswARwYYerEhRLSLWxeXMbsEQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 2019-08-27 at 19:59 +0200, Geert Uytterhoeven wrote:
> On Tue, Aug 27, 2019 at 7:46 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Tue, Aug 27, 2019 at 07:29:52PM +0200, Geert Uytterhoeven wrote:
> > > On Tue, Aug 27, 2019 at 4:17 PM David Laight <David.Laight@aculab.com> wrote:
> > > > From: Geert Uytterhoeven
> > > > > Sent: 19 August 2019 18:15
> > > > ...
> > > > > > I think a cast to unsigned long is rather more common.
> > > > > > 
> > > > > > uintptr_t is used ~1300 times in the kernel.
> > > > > > I believe a cast to unsigned long is much more common.

btw: apparently that's not true.

This grep may be incomplete but it seems there are fewer
kernel uses of a cast to unsigned long then pointer:

$ git grep -P '\(\s*\w+(\s+\w+){0,3}(\s*\*)+\s*\)\s*\(\s*unsigned\s+long\s*\)'|wc -l
423

Maybe add a cast_to_ptr macro like

#define cast_to_ptr(type, val)	((type)(uintptr_t)(val))

though that may not save any horizontal space

and/or a checkpatch test like:
---
 scripts/checkpatch.pl | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 287fe73688f0..4ec88bc53f2f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6281,6 +6281,15 @@ sub process {
 			}
 		}
 
+# check for casts to pointer with intermediate casts to (unsigned long) not (uintptr_t)
+		if ($line =~ /\(\s*\w+(?:\s+\w+){0,3}(?:\s*\*){1,4}\s*\)\s*\(\s*unsigned\s+long\s*\)/) {
+			if (WARN("PREFER_UINTPTR_T",
+				 "prefer intermediate cast to uintptr_t\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/(\(\s*\w+(?:\s+\w+){0,3}(?:\s*\*){1,4}\s*\))\s*\(\s*unsigned\s+long\s*\)/$1(uintptr_t)/;
+			}
+		}
+
 # check for pointless casting of alloc functions
 		if ($line =~ /\*\s*\)\s*$allocFunctions\b/) {
 			WARN("UNNECESSARY_CASTS",

