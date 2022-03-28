Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0453C4167B
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Mar 2022 12:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242260AbiC1MIq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Mar 2022 08:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbiC1MIp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 28 Mar 2022 08:08:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5262F02E;
        Mon, 28 Mar 2022 05:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B651261386;
        Mon, 28 Mar 2022 12:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB604C004DD;
        Mon, 28 Mar 2022 12:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648469224;
        bh=tE6ioofk+pBW2MT07IEZlFDaMsj/QAWNPh7LO+tEgRY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SNBp87/b9ghn6N66Qiw+pC44k2wkbqkuWOtkrnabNs3b+dpmzNteG8aCrh0Nefk16
         W9SGaIyDxUNy9Ai3OvzygFgeCC0ID9u0ww0fVlfx7AJwQrjYzvriQcFbdtLQPUO/Hx
         tt8JrGbwpuEBBjZWjo/Pk9oYqU7a32+7BBqqZ034F/xwUi4FKRZB3/jWRRen2xbgm8
         PD4BleRvyw8JMy86JdPmgr5fneoYPT0uIu2WWZ2TBstcxYCqQ5Tu+4gUtW/TLfg5gC
         op/UBrH5it2hyjGXiexwdkZjBk+X3wzxDQ4GWY3KOrOh1J/G1OX1DVV22TIPLJ95bT
         LOCFHGhpSVGvA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 20/22] wireless: Replace comments with C99 initializers
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220326165909.506926-20-benni@stuerz.xyz>
References: <20220326165909.506926-20-benni@stuerz.xyz>
To:     =?utf-8?q?Benjamin_St=C3=BCrz?= <benni@stuerz.xyz>
Cc:     andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux@armlinux.org.uk,
        linux@simtec.co.uk, krzk@kernel.org, alim.akhtar@samsung.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, robert.moore@intel.com,
        rafael.j.wysocki@intel.com, lenb@kernel.org, 3chas3@gmail.com,
        laforge@gnumonks.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        mchehab@kernel.org, tony.luck@intel.com, james.morse@arm.com,
        rric@kernel.org, linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, pkshih@realtek.com,
        bhelgaas@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
        devel@acpica.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-input@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-media@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
        =?utf-8?q?Benjamin_St=C3=BCrz?= <benni@stuerz.xyz>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164846920750.11945.16978682699891961444.kvalo@kernel.org>
Date:   Mon, 28 Mar 2022 12:06:51 +0000 (UTC)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Benjamin Stürz <benni@stuerz.xyz> wrote:

> This replaces comments with C99's designated
> initializers because the kernel supports them now.
> 
> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>

The title prefix should be "ray_cs: ".

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220326165909.506926-20-benni@stuerz.xyz/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

