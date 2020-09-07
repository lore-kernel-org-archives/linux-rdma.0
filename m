Return-Path: <SRS0=uoZ+=CQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CEEC433E2
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Sep 2020 16:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 854F42080A
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Sep 2020 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599496989;
	bh=bmVLYFBJiyn8ShyyCKW2pQZ2G588VaCgu+JOFMtEIf8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=lqkLVLA1qi/TWv++pF8rHwuzfcLWfmGBKD6gv1ityOZ4+GCAXS+sfvEpSSZTxH8Ex
	 wfOYD3RZPte5cVsY6uXTcvNMpSuLqhEWftaG3DHN0UZO69HNqMcXmP523KNKi11et1
	 52uSiye8qXLSozXcF91d5yHX+n1j3zj5dZmDztpE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbgIGQnG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730685AbgIGQgR (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 7 Sep 2020 12:36:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37EBC21941;
        Mon,  7 Sep 2020 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496576;
        bh=bmVLYFBJiyn8ShyyCKW2pQZ2G588VaCgu+JOFMtEIf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sF1SSEImL2CgMgg9WhArgzNgxxkvRMPeKf/aV8j2/sE9OtUFC8E3dzBKUxTNzMMci
         S16dLb0FNaj/72d98DJiHUTl8dVmFdWgoTWEd8DrFknk4VFy/Jy26MHUVXM8UIQaju
         BWg/6R8DnXGXg+JkzvgqbWu5A8VLEOMlqkKrTUwk=
Date:   Mon, 7 Sep 2020 09:36:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        yishaih@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] mlx4: make sure to always set the port type
Message-ID: <20200907093614.12231d6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907064830.GK55261@unreal>
References: <20200904200621.2407839-1-kuba@kernel.org>
        <20200906072759.GC55261@unreal>
        <20200906093305.5c901cc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200907062135.GJ2997@nanopsycho.orion>
        <20200907064830.GK55261@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, 7 Sep 2020 09:48:30 +0300 Leon Romanovsky wrote:
>>>> And can we call to devlink_port_type_*_set() without IS_ENABLED() check?  
>>>
>>> It'll generate two netlink notifications - not the end of the world but
>>> also doesn't feel super clean.  
> 
> I would say that such a situation is corner case during the driver init and
> not an end of the world to see double netlink message.

Could you spell out your reasoning here? Are you concerned about
out-of-tree drivers?

I don't see how adding IS_ENABLED() to the condition outweighs 
the benefit of not having duplicated netlink notifications.
