Return-Path: <SRS0=727Q=3X=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CF5C35247
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Feb 2020 20:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77F902084E
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Feb 2020 20:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580760506;
	bh=1VB3lIo4r7T//AyFcgGanj3aTbzYAyC7q+pP+2U2xYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HkTUS6HNr7mn1rQrR6rnXXLqkoeSo4HdDlfuaOWtKRpL/Ytp3jyN890gCtZxEtQzm
	 ch+mwN/rw6bZqwlJH7pPeW37xUQWPl4EQLdlmyn18S+vhgJKCu2n+8bfZG/OqWa4lw
	 7JvX+NBC4FK9ZkJtGf+uJAGvwBTgLi8LPbxzUUwE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgBCUIZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 3 Feb 2020 15:08:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgBCUIZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 3 Feb 2020 15:08:25 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7647E2084E;
        Mon,  3 Feb 2020 20:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580760505;
        bh=1VB3lIo4r7T//AyFcgGanj3aTbzYAyC7q+pP+2U2xYc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AmdrGrI/dhvmjWEmFvwGBDUx/kEIziGUn+mNN3fm2V0w1CIfK+PL/HePTqrOpGWNN
         GywOelSCBicl7wqV0hoxp8Ml8+0qQaKhm6N9qVAgIVq9QpGtWc7TFI8UsjoaYDAA+y
         7whtuAeBDJKOdnQXstQgsom78PkrYdtBj+XifG2c=
Date:   Mon, 3 Feb 2020 22:08:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dimitris Dimitropoulos <d.dimitropoulos@imatrex.com>
Cc:     linux-rdma@vger.kernel.org
Subject: Re: RDMA header inspection
Message-ID: <20200203200820.GU414821@unreal>
References: <CAOc41xG5xb-6LEKmsvPPET9jKZ8ScAMW1rW=AzV1_HLs9DhNEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOc41xG5xb-6LEKmsvPPET9jKZ8ScAMW1rW=AzV1_HLs9DhNEQ@mail.gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Feb 03, 2020 at 11:30:09AM -0800, Dimitris Dimitropoulos wrote:
> Hi,
>
> I'm trying to inspect RDMA headers and they do not show up on
> wireshark. How can I observe RDMA headers ? Also, any header parser
> available in the code base that I can link to and use to process the
> headers ?

The libpcap which is compiled with RDMA support has ability to catch
traffic for mlx4/mlx5 devices.
https://github.com/the-tcpdump-group/libpcap/pull/585

Thanks

>
>
> Thank you.
>
> Dimitris
