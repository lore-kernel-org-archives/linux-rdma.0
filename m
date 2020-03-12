Return-Path: <SRS0=gJYK=45=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDBBC10DCE
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 19:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0BB020637
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 19:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCLTyR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Mar 2020 15:54:17 -0400
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:42674 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725268AbgCLTyQ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 12 Mar 2020 15:54:16 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id EB034182CED5B;
        Thu, 12 Mar 2020 19:54:15 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: baby05_7c5504a7ced51
X-Filterd-Recvd-Size: 2717
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Thu, 12 Mar 2020 19:54:14 +0000 (UTC)
Message-ID: <62ed1e9972f5d7d8a203e9295c388a70e6e9e0c2.camel@perches.com>
Subject: Re: [PATCH -next 001/491] MELLANOX ETHERNET INNOVA DRIVERS: Use
 fallthrough;
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, borisp@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 12:52:30 -0700
In-Reply-To: <20200312124504.7ee481a9@kicinski-fedora-PC1C0HJN>
References: <cover.1583896344.git.joe@perches.com>
         <605f5d4954fcb254fe6fc5c22dc707f29b3b7405.1583896347.git.joe@perches.com>
         <20200311.232302.1442236068172575398.davem@davemloft.net>
         <cf74e8fdd3ee99aec86cec4abfdb1ce84b7fd90a.camel@perches.com>
         <20200312124504.7ee481a9@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, 2020-03-12 at 12:45 -0700, Jakub Kicinski wrote:
> On Wed, 11 Mar 2020 23:26:59 -0700 Joe Perches wrote:
> > On Wed, 2020-03-11 at 23:23 -0700, David Miller wrote:
> > > Joe, please use Subject line subsystem prefixes consistent with what would
> > > be used for other changes to these drivers.  
> > 
> > Not easy to do for scripted patches.
> > There's no mechanism that scriptable.
> 
> I have this to show me the top 3 prefixes used for files currently
> modified in my tree:
> 
> tgs() {
>     local fs
> 
>     fs=$(git status -s | sed -n 's/ M //p')
> 
>     git log --oneline --no-merges -- $fs | \
> 	sed -e's/[^ ]* \(.*\):[^:]*/\1/' | \
> 	sort | uniq -c | sort -rn | head -3
> }
> 
> You could probably massage it to just give you to top one and feed 
> that into git commit template?

I had already tried that via:

$ cat get_patch_subject_prefix.bash 
#!/bin/bash
git log --format="%s" --no-merges -200 --since=2-years-ago $@ | \
  cut -f1 -d":" | \
  sort  | uniq -c | sort -rn | head -1 | \
  sed 's/^[[:space:]]*[[:digit:]]*[[:space:]]*//'
$ 

It doesn't work very well for many of the subsystems.

For instance, this script produces things like:

ARM/ZYNQ ARCHITECTURE: treewide
FCOE SUBSYSTEM (libfc, libfcoe, fcoe): scsi
WOLFSON MICROELECTRONICS DRIVERS: ASoC

There isn't a great single mechanism for this.

At various times, I have proposed adding a grammar for
patch subject titles to MAINTAINERS.

Like:
https://lore.kernel.org/lkml/1289919077.28741.50.camel@Joe-Laptop/


