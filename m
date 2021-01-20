Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C67C433DB
	for <linux-rdma@archiver.kernel.org>; Wed, 20 Jan 2021 05:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFB8B23131
	for <linux-rdma@archiver.kernel.org>; Wed, 20 Jan 2021 05:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbhATFhH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 20 Jan 2021 00:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbhATFef (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 20 Jan 2021 00:34:35 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167DBC061575
        for <linux-rdma@vger.kernel.org>; Tue, 19 Jan 2021 21:33:55 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id o11so22307521ote.4
        for <linux-rdma@vger.kernel.org>; Tue, 19 Jan 2021 21:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=bfE625taTNIabYcxrauV/zKrngHJnfxvyXwAYf/bO7g=;
        b=Hs+Lv44SNv69MXFA7WxMaj/n2WHrQc19lUWqR9nDDBqelSvB3xh9W9PmYUN9MBZwaL
         8oHME3Gz47opngLOVGv2JgiSHLrTkDYQhrlR3wXbrdI5zoZ8/1HJW9hzxQ8jVTo/L9nr
         wi574s92R3tc3pg+ocOItlPIx2qAk4uW6nxKa797PAXjKq/l9N/YHYadTEZK/9Q7Fknk
         JlK4hUlcYzmDaK2+DZd4Yhr7M/y2WEh9s+ydLa0noSQFblhWSnautydGFMtYqFPJa16s
         x3gBHrs9kkB/VSHmLPKtGR+YdAFRKd9IjrQCpeZzNkMg3wnvT1CPCgtbLNbx44ugnzqX
         GMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bfE625taTNIabYcxrauV/zKrngHJnfxvyXwAYf/bO7g=;
        b=I3JAOHwJzYrt9OKCKEw5Um7ymRYJgg42qz0ADnUYK+SPrQHfyNBM7++Gtj4N0G5ztH
         q8Gb3o4/kNuz3HRV1QFLJd/M6FzxFjLv1ER/9s6xAUAl1zIuXBVXpFE0lpTNL+fd5N77
         4KNBMMlkRmXxPlP8nBCfcUI6oBXICbDbKnpeAXxmibbTDDX4/VELbAahS6DV/qVv/vu1
         4lq4akOtoKUMmv70Z/DPSSx15N7YbU5HyHEFyLnFaJeigvKUE7Z7yy5vtbBUTTAfccZb
         //AMWjKSZrB6LITXLDfQ7HNSdG8++AjOWWT7X+gGtDD6xIKfe+6osyKfR1+NnNLT5/9v
         k7sg==
X-Gm-Message-State: AOAM530K//J6YD+AYfPjlU5oYobNU3MRIwXKUMFkg/5LcIOI5yIFy4lM
        NEputsnyRrcidHjcE2NqO2PUO2/3MZDmcxeQ2cI=
X-Google-Smtp-Source: ABdhPJxNMsz68dAdWwDDjaY/v91ffIG5Dhd6+QxXE+1ZcPHu2AQjIFXbuSZ7lDfjtSUcU5LIO0PC9ZlEZM3sELXynL4=
X-Received: by 2002:a9d:3e2:: with SMTP id f89mr5951600otf.278.1611120834545;
 Tue, 19 Jan 2021 21:33:54 -0800 (PST)
MIME-Version: 1.0
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Wed, 20 Jan 2021 13:33:43 +0800
Message-ID: <CAD=hENfPfgZpcs+JER9qijyo-D16n1X0q2oPqF-qo88GLkkBXw@mail.gmail.com>
Subject: Revert "RDMA/rxe: Remove VLAN code leftovers from RXE"
To:     mwilck@suse.com, Jason Gunthorpe <jgg@nvidia.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 2021-01-19 at 20:10 +0800, Zhu Yanjun wrote:
> On Tue, Jan 19, 2021 at 6:57 PM <mwilck@suse.com> wrote:
> >
> > From: Martin Wilck <mwilck@suse.com>
> >
> > This reverts commit b2d2440430c0fdd5e0cad3efd6d1c9e3d3d02e5b.
> >
> > It's true that creating rxe on top of 802.1q interfaces doesn't
> > work.
> > Thus, commit fd49ddaf7e26 ("RDMA/rxe: prevent rxe creation on top
> > of vlan interface")
> > was absolutely correct.
> >
> > But b2d2440430c0 was incorrect assuming that with this change,
> > RDMA and VLAN don't work togehter at all. It just has to be
> > set up differently. Rather than creating rxe on top of the VLAN
> > interface, rxe must be created on top of the physical interface.
> > RDMA then works just fine through VLAN interfaces on top of that
> > physical interface, via the "upper device" logic.
>
> I read this commit log for several times. I can not get you.
> Can you show me by an example?

> My test scenario which is broken by your patch uses a script that does
> roughly the following:

> # (set up eth0)
> rdma link add rxe_eth0 type rxe netdev eth0
> ip link add link eth0 name eth0.10 type vlan id 10
> ip link set eth0.10 up
> ip addr add 192.168.10.102/24 dev eth0.10

Thanks a lot.
It seems that the vlan SKBs also enter RXE.

There are 3 hunks in the commit b2d2440430c0("RDMA/rxe: Remove VLAN
code leftovers from RXE").

Can you make more research to find out which hunk causes this problem?

From Jason, vlan is not supported now.
If you want to make more work, the link
https://www.spinics.net/lists/linux-rdma/msg94737.html can give some
tips.

good luck.

Zhu Yanjun

> nvme discover -t rdma -a 192.168.10.101 -s 4420



> 192.168.10.101 is another host that configures the network
> and rxe the same way, and has some nvmet targets.

>  => fails with your patch applied, works otherwise.


> Regards,
> Martin
