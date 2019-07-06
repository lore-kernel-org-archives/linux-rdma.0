Return-Path: <SRS0=XE47=VD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0284FC468AC
	for <linux-rdma@archiver.kernel.org>; Sat,  6 Jul 2019 05:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF49921670
	for <linux-rdma@archiver.kernel.org>; Sat,  6 Jul 2019 05:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="mXGpAyHD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rBKCfUyq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfGFFJC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 6 Jul 2019 01:09:02 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52897 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfGFFJC (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 6 Jul 2019 01:09:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 391FB20E7B;
        Sat,  6 Jul 2019 01:09:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 06 Jul 2019 01:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=rp0B1rpce/PlxIypONFH/+e8UDi
        2FDwQaPb/lmlhDLY=; b=mXGpAyHD4+0NMFu888WlnbFje8Dl+Qe6yfdgXeueVSI
        hwKVLTA05KoovXEIBCa1Km7jHivB+ZffXXGoT3OR+pVTWCKIJ1L08eg5z+bT690w
        nJuusymgD4Jd4oPgUF7leJqNZnKRWxX2zpN0HivwIVPskwCHJBIvSLSo2aqyc4fw
        1kfLRRDb3tiU7bSwbuf3oeLokh2NJ3nboRwF31TRIAV68498EhzzbXVpCzTed5uC
        +x/Iwa8OJg7oDa0JUsdtwFXsdOECqatK+/v8TArj72F57ie/uJyEIWKG6Q7cFZuG
        h3N5NvJQEkNuhsABDDz1+jl258+UTpORVw1TniBbdyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rp0B1r
        pce/PlxIypONFH/+e8UDi2FDwQaPb/lmlhDLY=; b=rBKCfUyq5e3KLfigfUsGr5
        4R4kcuFOjB07NlAVtlaY7gTeYCTFn9C0ckjE/p5xgeQdzjEkIpFEQ6s4KZfCgT0v
        sSgd4b9or5ahXNfz/63pr99M3RoeJGYC3tP6SJdYAlfMZgppxZakAolLn1EsqOih
        utRUSbkV4mMgFx+p10+n9Dh3TcUSE535SkAm3MtTKJm5qeVLDHbkvi9Bq9W1HLjc
        iWPdvSi61vpyUs6d/PCoYuUO/wLembGngv7gHMu5wCbt0mambNiKNA4lxaXddLgQ
        LvjaXl9ow5pDqABwWMu/w2FFoJaHdRXrrzNrFs/XPB+N7rJ7Co0G6rY2ofhtWcDQ
        ==
X-ME-Sender: <xms:7CwgXeU5xNVrc8EH-sdxBas1gXHFVzH2RZYoM72JDUSlCEGKs3urvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:7CwgXVvHFs2r9ERjSOqU-wDHsxKeslnXOJSxBqCeUSbslSwjQ3sFDA>
    <xmx:7CwgXRzoi9Cs4bHCT8IlnEC4_Lq_MDeiftU4FxqkL0NXTHgL3xoKWw>
    <xmx:7CwgXUnqfLa9A64ITx_8VxvAEmZvzIV7sB2VHOFJXXa-VvZcbVqFdw>
    <xmx:7SwgXVl24_T_9d6mELCWyRdubZImDq1hrSiIjoUWwdUzGC3eo0-HOQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52F2E8005B;
        Sat,  6 Jul 2019 01:09:00 -0400 (EDT)
Date:   Sat, 6 Jul 2019 07:08:57 +0200
From:   Greg KH <greg@kroah.com>
To:     Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc:     stable@vger.kernel.org, linux-rdma@vger.kernel.org,
        stable-commits@vger.kernel.org
Subject: Re: [PATCH] IB/hfi1: Close PSM sdma_progress sleep window
Message-ID: <20190706050857.GA5322@kroah.com>
References: <20190624201537.170286.13849.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624201537.170286.13849.stgit@awfm-01.aw.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 04:15:37PM -0400, Mike Marciniszyn wrote:
> commit da9de5f8527f4b9efc82f967d29a583318c034c7 upstream.
> 
> The call to sdma_progress() is called outside the wait lock.
> 
> In this case, there is a race condition where sdma_progress() can return
> false and the sdma_engine can idle.  If that happens, there will be no
> more sdma interrupts to cause the wakeup and the user_sdma xmit will hang.
> 
> Fix by moving the lock to enclose the sdma_progress() call.
> 
> Also, delete busycount. The need for this was removed by:
> commit bcad29137a97 ("IB/hfi1: Serve the most starved iowait entry first")
> 
> Ported to linux-4.9.y.

Now applied, thanks.

Note, this already is in 4.14.132 and 4.19.57 so I didn't need the
backports for those kernels.

greg k-h
