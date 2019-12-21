Return-Path: <SRS0=4HyS=2L=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE07C2D0D3
	for <linux-rdma@archiver.kernel.org>; Sat, 21 Dec 2019 10:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E25421927
	for <linux-rdma@archiver.kernel.org>; Sat, 21 Dec 2019 10:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576923432;
	bh=bDlgy8lsRzxzzBg1z25vE4MtL8FCduXazTqCT3s0Zkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Lvi9W3hGkDyWU6QMtBhASCcxel4+0eyA2BV8fZDJiac5sjdxPsXFv/jMKRFb+hTta
	 xiNSQZsxkCDRBTNXqspEyiQ6bSfIeKcN0MkqufWn7xKFmDItDgjYwGAKbOywMNOMlD
	 j5QgeMdzdEUEDx1cIc5yqomRCApG2fggC0+LCugU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfLUKRL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 21 Dec 2019 05:17:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfLUKRL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 21 Dec 2019 05:17:11 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A52F2072B;
        Sat, 21 Dec 2019 10:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576923430;
        bh=bDlgy8lsRzxzzBg1z25vE4MtL8FCduXazTqCT3s0Zkc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b1Ab1jcaZqv7qcZRUP+4KwcYx7r+yfjDPhA96l9lmtUB464PHkk2oaFIAcrC/Jjh2
         piK4/oTurT1Zfa+p/uaO0hDMYOQLfinJ+IgC+WEEfMJaSlsPPi4bFRmLzggY2XzDRq
         K16uxxYMYRemXUfo1Mp/BWFYiQWRr15dxoVV5ST4=
Date:   Sat, 21 Dec 2019 12:17:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jack Wang <jinpuwang@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        axboe@kernel.dk, hch@infradead.org, sagi@grimberg.me,
        bvanassche@acm.org, dledford@redhat.com,
        danil.kipnis@cloud.ionos.com, jinpu.wang@cloud.ionos.com,
        rpenyaev@suse.de
Subject: Re: [PATCH v5 00/25] RTRS (former IBTRS) rdma transport library and
 the corresponding RNBD (former IBNBD) rdma network block device
Message-ID: <20191221101705.GD13335@unreal>
References: <20191220155109.8959-1-jinpuwang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220155109.8959-1-jinpuwang@gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Dec 20, 2019 at 04:50:44PM +0100, Jack Wang wrote:
> Hi all,
>
> here is V5 of the RTRS (former IBTRS) rdma transport library and the
> corresponding RNBD (former IBNBD) rdma network block device.
>
> Main changes are the following:
> 1. Fix the security problem pointed out by Jason
> 2. Implement code-style/readability/API/etc suggestions by Bart van Assche
> 3. Rename IBTRS and IBNBD to RTRS and RNBD accordingly
> 4. Fileio mode support in rnbd-srv has been removed.
>
> The main functional change is a fix for the security problem pointed out by
> Jason and discussed both on the mailing list and during the last LPC RDMA MC 2019.
> On the server side we now invalidate in RTRS each rdma buffer before we hand it
> over to RNBD server and in turn to the block layer. A new rkey is generated and
> registered for the buffer after it returns back from the block layer and RNBD
> server. The new rkey is sent back to the client along with the IO result.
> The procedure is the default behaviour of the driver. This invalidation and
> registration on each IO causes performance drop of up to 20%. A user of the
> driver may choose to load the modules with this mechanism switched off
> (always_invalidate=N), if he understands and can take the risk of a malicious
> client being able to corrupt memory of a server it is connected to. This might
> be a reasonable option in a scenario where all the clients and all the servers
> are located within a secure datacenter.
>
> Huge thanks to Bart van Assche for the very detailed review of both RNBD and
> RTRS. These included suggestions for style fixes, better readability and
> documentation, code simplifications, eliminating usage of deprecated APIs,
> too many to name.
>
> The transport library and the network block device using it have been renamed to
> RTRS and RNBD accordingly in order to reflect the fact that they are based on
> the rdma subsystem and not bound to InfiniBand only.
>
> Fileio mode support in rnbd-server is not so efficent as pointed out by Bart,
> and we can use loop device in between if there is need, hence we just
> removed the fileio mode support.

Thanks for pushing the code forward.
