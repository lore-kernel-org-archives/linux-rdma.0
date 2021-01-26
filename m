Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64CBC4332B
	for <linux-rdma@archiver.kernel.org>; Tue, 26 Jan 2021 08:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B20CE22DFB
	for <linux-rdma@archiver.kernel.org>; Tue, 26 Jan 2021 08:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389817AbhAZIVC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 26 Jan 2021 03:21:02 -0500
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:53526 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389809AbhAZIVA (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 26 Jan 2021 03:21:00 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 8742B12C7;
        Tue, 26 Jan 2021 08:20:14 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: fire53_3e0904e2758c
X-Filterd-Recvd-Size: 4553
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Tue, 26 Jan 2021 08:20:12 +0000 (UTC)
Message-ID: <48c5a16657bb7b6c0f619253e57133137d4e825c.camel@perches.com>
Subject: Re: [PATCH mlx5-next v4 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
From:   Joe Perches <joe@perches.com>
To:     Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Date:   Tue, 26 Jan 2021 00:20:11 -0800
In-Reply-To: <20210126060135.GQ579511@unreal>
References: <20210124131119.558563-1-leon@kernel.org>
         <20210124131119.558563-2-leon@kernel.org>
         <20210125135229.6193f783@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20210126060135.GQ579511@unreal>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 2021-01-26 at 08:01 +0200, Leon Romanovsky wrote:
> On Mon, Jan 25, 2021 at 01:52:29PM -0800, Jakub Kicinski wrote:
> > On Sun, 24 Jan 2021 15:11:16 +0200 Leon Romanovsky wrote:
> > > +static int pci_enable_vfs_overlay(struct pci_dev *dev) { return 0; }
> > > +static void pci_disable_vfs_overlay(struct pci_dev *dev) {}
> > 
> > s/static /static inline /
> 
> Thanks a lot, I think that we should extend checkpatch.pl to catch such
> mistakes.

Who is this "we" you refer to? ;)

> How hard is it to extend checkpatch.pl to do regexp and warn if in *.h file
> someone declared function with implementation but didn't add "inline" word?

Something like this seems reasonable and catches these instances in
include/linux/*.h

$ ./scripts/checkpatch.pl -f include/linux/*.h --types=static_inline --terse --nosummary
include/linux/dma-mapping.h:203: WARNING: static function definition might be better as static inline
include/linux/genl_magic_func.h:55: WARNING: static function definition might be better as static inline
include/linux/genl_magic_func.h:78: WARNING: static function definition might be better as static inline
include/linux/kernel.h:670: WARNING: static function definition might be better as static inline
include/linux/kprobes.h:213: WARNING: static function definition might be better as static inline
include/linux/kprobes.h:231: WARNING: static function definition might be better as static inline
include/linux/kprobes.h:511: WARNING: static function definition might be better as static inline
include/linux/skb_array.h:185: WARNING: static function definition might be better as static inline
include/linux/slab.h:606: WARNING: static function definition might be better as static inline
include/linux/stop_machine.h:62: WARNING: static function definition might be better as static inline
include/linux/vmw_vmci_defs.h:850: WARNING: static function definition might be better as static inline
include/linux/zstd.h:95: WARNING: static function definition might be better as static inline
include/linux/zstd.h:106: WARNING: static function definition might be better as static inline

A false positive exists when __must_check is used between
static and inline.  It's an unusual and IMO not a preferred use.
---
 scripts/checkpatch.pl | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4f8494527139..0ac366481962 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4451,6 +4451,18 @@ sub process {
 			}
 		}
 
+# check for static function definitions without inline in .h files
+# only works for static in column 1 and avoids multiline macro definitions
+		if ($realfile =~ /\.h$/ &&
+		    defined($stat) &&
+		    $stat =~ /^\+static(?!\s+(?:$Inline|union|struct))\b.*\{.*\}\s*$/s &&
+		    $line =~ /^\+static(?!\s+(?:$Inline|union|struct))\b/ &&
+		    $line !~ /\\$/) {
+			WARN("STATIC_INLINE",
+			     "static function definition might be better as static inline\n" .
+				$herecurr);
+		}
+
 # check for non-global char *foo[] = {"bar", ...} declarations.
 		if ($line =~ /^.\s+(?:static\s+|const\s+)?char\s+\*\s*\w+\s*\[\s*\]\s*=\s*\{/) {
 			WARN("STATIC_CONST_CHAR_ARRAY",


