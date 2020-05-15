Return-Path: <SRS0=2Sn3=65=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22937C433E4
	for <linux-rdma@archiver.kernel.org>; Fri, 15 May 2020 09:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04DC32074D
	for <linux-rdma@archiver.kernel.org>; Fri, 15 May 2020 09:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgEOJzG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 15 May 2020 05:55:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:45156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgEOJzG (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 15 May 2020 05:55:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 306D9AD31;
        Fri, 15 May 2020 09:55:06 +0000 (UTC)
Date:   Fri, 15 May 2020 11:55:01 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Orson Zhai <orsonzhai@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Orson Zhai <orson.unisoc@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: Re: [PATCH V2] dynamic_debug: Add an option to enable dynamic debug
 for modules only
Message-ID: <20200515095501.GU17734@linux-b0ei>
References: <1587408228-10861-1-git-send-email-orson.unisoc@gmail.com>
 <20200420191014.GE121146@unreal>
 <CA+H2tpGgGtW_8Z8fV9to39JwA_KrcfAeBC+KN87v0xKnZHt2_w@mail.gmail.com>
 <20200422142552.GA492196@unreal>
 <CA+H2tpGR7tywhkexa31AD_FkhyxQgVq_L+b0DbvXzwr6yT8j9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+H2tpGR7tywhkexa31AD_FkhyxQgVq_L+b0DbvXzwr6yT8j9Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu 2020-04-23 00:02:48, Orson Zhai wrote:
> On Wed, Apr 22, 2020 at 10:25 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Apr 22, 2020 at 09:06:08PM +0800, Orson Zhai wrote:
> > > On Tue, Apr 21, 2020 at 3:10 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > My motivation came from the concept of GKI (Generic Kernel Image) in Android.
> > > Google will release a common kernel image (binary) to all of the Android system
> > > vendors in the world instead of letting them to build their owns as before.
> > > Every SoC vendor's device drivers will be provided in kernel modules only.
> > > By my patch, the driver owners could debug their modules in field (say
> > > production releases)
> > > without having to enable dynamic debug for the whole GKI.
> >
> > Will Google release that binary with CONFIG_DYNAMIC_DEBUG_CORE disabled?
> >
> In Google's plan, there will be only one GKI (no debug version) for
> one Android version per kernel version per year.

Are there plans to use modules with debug messages enabled on production
systems?

IMHO, the debug messages are primary needed during development and
when fixing bugs. I am sure that developers will want to enable many
more features that will help with debugging and which will be disabled
on production systems.

I expect that Google will not release only the single binary. They
should release also the sources and build configuration. Then
developers might build their own versions with the needed debugging
features enabled.

Best Regards,
Petr
