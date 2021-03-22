Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DED8C433C1
	for <linux-rdma@archiver.kernel.org>; Mon, 22 Mar 2021 02:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 225386188B
	for <linux-rdma@archiver.kernel.org>; Mon, 22 Mar 2021 02:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCVCye (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 21 Mar 2021 22:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhCVCyT (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 21 Mar 2021 22:54:19 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86166C061574;
        Sun, 21 Mar 2021 19:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=LchtIFk89xU4+bvTjczihlQeS2+A0oDJIO4T86TI7/c=; b=RZ/s6ksgaYtj7p+TO5f9seCcQG
        BMq4dpCNgALtQVBROU5goabiQotB2mVRNwp2ImlFVmh3L1idMsAMG4bP3qScTy6lD5UwT6Bay29Nc
        PstMsP+uYeNcePvahbCfgWy9+aLuDv96qseFVXrAfC+iarvImt9lZmnjHdeR+40aX3HEpIM9+fdxu
        h3n+6A5d/yRAN4ddclbxesB4Hk8mo9RRcn4ZcYctt3VK4MSiJOn2zF6vmhdwvC5+b6dsW70wbRaYN
        0VMKCxAI6bzE2yij7ZqUWjTZTMeVdmltI9wMs4SmhHOi9SHvXt3jLOk/d2dPSP+PhNRHBEEAXvAyJ
        YUF3pzdg==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOAhm-00AjUJ-BA; Mon, 22 Mar 2021 02:54:13 +0000
Subject: Re: [PATCH] IB/hns: Fix a spelling
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, oulijun@huawei.com,
        huwei87@hisilicon.com, liweihang@huawei.com, dledford@redhat.com,
        jgg@ziepe.ca, dt@kernel.org, linux-rdma@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210322022751.4137205-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d29400f4-32fd-d479-9d8e-7dd91499cce5@infradead.org>
Date:   Sun, 21 Mar 2021 19:54:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322022751.4137205-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 3/21/21 7:27 PM, Bhaskar Chowdhury wrote:
> 
> s/wubsytem/subsystem/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  .../devicetree/bindings/infiniband/hisilicon-hns-roce.txt       | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt b/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
> index 84f1a1b505d2..c57e09099bcb 100644
> --- a/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
> +++ b/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
> @@ -1,7 +1,7 @@
>  Hisilicon RoCE DT description
> 
>  Hisilicon RoCE engine is a part of network subsystem.
> -It works depending on other part of network wubsytem, such as, gmac and
> +It works depending on other part of network subsystem, such as, gmac and

No comma after "such as".

>  dsa fabric.
> 
>  Additional properties are described here:
> --


-- 
~Randy

