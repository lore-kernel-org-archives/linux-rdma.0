Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D425C433EF
	for <linux-rdma@archiver.kernel.org>; Tue, 17 May 2022 17:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351627AbiEQRyz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 17 May 2022 13:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351668AbiEQRyw (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 17 May 2022 13:54:52 -0400
Received: from smtp.smtpout.orange.fr (smtp04.smtpout.orange.fr [80.12.242.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44E13FBDC
        for <linux-rdma@vger.kernel.org>; Tue, 17 May 2022 10:54:49 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id r1P4nJQwzAym2r1P4nqVqo; Tue, 17 May 2022 19:54:47 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 17 May 2022 19:54:47 +0200
X-ME-IP: 86.243.180.246
Message-ID: <142a9c03-574f-adcf-bc4d-bb2a25c01e88@wanadoo.fr>
Date:   Tue, 17 May 2022 19:54:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] RDMA: remove null check after call container_of()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>, Haowen Bai <baihaowen@meizu.com>
Cc:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1652751208-23211-1-git-send-email-baihaowen@meizu.com>
 <20220517121646.GE63055@ziepe.ca>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220517121646.GE63055@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Le 17/05/2022 à 14:16, Jason Gunthorpe a écrit :
> On Tue, May 17, 2022 at 09:33:28AM +0800, Haowen Bai wrote:
>> container_of() will never return NULL, so remove useless code.
> 
> It is confusing here, but it can be null. 

Hi,

out of curiosity, can you elaborate how it can be NULL?

CJ

> If you want to do this then
> you have to split out the _ib_alloc_device call and check it
> seperately.
> 
> Jason
> 

