Return-Path: <SRS0=7pIb=7X=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529B4C433DF
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jun 2020 13:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1162A206F4
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jun 2020 13:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=shipmail.org header.i=@shipmail.org header.b="CSFaq2l8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbgFJNHf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Jun 2020 09:07:35 -0400
Received: from ste-pvt-msa1.bahnhof.se ([213.80.101.70]:27693 "EHLO
        ste-pvt-msa1.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbgFJNHf (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 10 Jun 2020 09:07:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTP id E6AD13F683;
        Wed, 10 Jun 2020 15:07:32 +0200 (CEST)
Authentication-Results: ste-pvt-msa1.bahnhof.se;
        dkim=pass (1024-bit key; unprotected) header.d=shipmail.org header.i=@shipmail.org header.b=CSFaq2l8;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from ste-pvt-msa1.bahnhof.se ([127.0.0.1])
        by localhost (ste-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8se4flHNtQaz; Wed, 10 Jun 2020 15:07:31 +0200 (CEST)
Received: from mail1.shipmail.org (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        (Authenticated sender: mb878879)
        by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id D09623F613;
        Wed, 10 Jun 2020 15:07:30 +0200 (CEST)
Received: from localhost.localdomain (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        by mail1.shipmail.org (Postfix) with ESMTPSA id 22F47360060;
        Wed, 10 Jun 2020 15:07:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=shipmail.org; s=mail;
        t=1591794450; bh=IJ9u1GxVx+qsu6oG3TX7HWi7e9bnoSgVQXnBCxCvSrY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=CSFaq2l8gV0H1uLMlTxTWB5ilfeWzJiad7o1Ei9DoLShaL8QaUdeDbLjt/qe+wgW+
         yn9NNJyKa56gDfDoXcFsVFJOkyVObxJPuPLYh/ula+z3sWXes4cnYncQPYbX5b9KQo
         gwWz7YCRYCYJTRPWHwedVmdLbCPwaFtmSfRgiIQw=
Subject: Re: [PATCH 02/18] dma-buf: minor doc touch-ups
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     linux-rdma@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20200604081224.863494-1-daniel.vetter@ffwll.ch>
 <20200604081224.863494-3-daniel.vetter@ffwll.ch>
From:   =?UTF-8?Q?Thomas_Hellstr=c3=b6m_=28Intel=29?= 
        <thomas_os@shipmail.org>
Message-ID: <f5ffe0bf-e050-90c1-b83b-1f11fcf55012@shipmail.org>
Date:   Wed, 10 Jun 2020 15:07:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200604081224.863494-3-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On 6/4/20 10:12 AM, Daniel Vetter wrote:
> Just some tiny edits:
> - fix link to struct dma_fence
> - give slightly more meaningful title - the polling here is about
>    implicit fences, explicit fences (in sync_file or drm_syncobj) also
>    have their own polling
>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>

Reviewed-by: Thomas Hellstrom <thomas.hellstrom@intel.com>


