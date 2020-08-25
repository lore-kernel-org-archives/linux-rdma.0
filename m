Return-Path: <SRS0=RHPu=CD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E629C433E1
	for <linux-rdma@archiver.kernel.org>; Tue, 25 Aug 2020 05:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF6D92071E
	for <linux-rdma@archiver.kernel.org>; Tue, 25 Aug 2020 05:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598332259;
	bh=uRlkyFcI1ug3cJPLxk+twuMIPefcD23jue1E0pLjMWg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Bpr29b8rRGMsRO88NSVHXR6WA5KjYHVfOvs95KEQFwfbqKZCz2a0VWX9TLgqigPu/
	 TR8UxBSsV3STjP+WMC+l6LMzHFk94fQcx2MA27BR+iN7CToSMseijS253wls6COFQw
	 rYM5Eiv78tFLXcC25fwk5UAYr+3SZfwD9r9O0QVI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgHYFK6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 25 Aug 2020 01:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgHYFKz (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 25 Aug 2020 01:10:55 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D75020737;
        Tue, 25 Aug 2020 05:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598332255;
        bh=uRlkyFcI1ug3cJPLxk+twuMIPefcD23jue1E0pLjMWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GMt99xwl20q8pVojmeoSu7cO2fVnmfFCAepCN1bR6wYErVynnNpMwsbsWHXhyQaYa
         P6mXXDQhjDQSLxgrOJTBWpYaSl/PYop0G9dSzEZflupteZt/Z1NXqrRahLuh/Kutbe
         zo6LtuJzX98d+ZrqrWRKF0L903Urv0oSPGZMOyec=
Date:   Tue, 25 Aug 2020 08:10:52 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Chris Worley <worleys@gmail.com>
Cc:     OFED mailing list <linux-rdma@vger.kernel.org>
Subject: Re: NVME module won't load ("nvme: disagrees about version of symbol
 nvme_uninit_ctrl")
Message-ID: <20200825051052.GO571722@unreal>
References: <CANWz5fhKJ=MbXdQo8gjAvioGj4V+V0wKZrU90OnCc+Nn0KkBLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANWz5fhKJ=MbXdQo8gjAvioGj4V+V0wKZrU90OnCc+Nn0KkBLg@mail.gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Aug 24, 2020 at 03:39:29PM -1000, Chris Worley wrote:
> Running MLNX_OFED_LINUX-5.0-2.1.8.0-rhel8.2-x86_6 on ConnectX-3 cards,
> attempting to run NVME-over-fabrics.
>
> OFED installed with: "./mlnxofedinstall --add-kernel-support
> --with-nvmf --force"
>
> The OFED install did indicate it couldn't load the firmware (although
> these are Mellanox cards) and said: "Note: In order to load the new
> nvme-rdma and nvmet-rdma modules, the nvme module must be reloaded."
> ... but the nvme driver doesn't even load.
>
> Where did I go wrong?

You posted to the wrong mailing list.
Please approach Mellanox support channel for MOFED related questions.

Thanks
