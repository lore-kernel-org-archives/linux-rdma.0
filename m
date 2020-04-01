Return-Path: <SRS0=G6D5=5R=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FCB2C43331
	for <linux-rdma@archiver.kernel.org>; Wed,  1 Apr 2020 13:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1B752073B
	for <linux-rdma@archiver.kernel.org>; Wed,  1 Apr 2020 13:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dwRcbTng"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbgDANR3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 1 Apr 2020 09:17:29 -0400
Received: from m12-12.163.com ([220.181.12.12]:58013 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732166AbgDANR2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 1 Apr 2020 09:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=CRk20
        cFC0nALLQFAPQo/Cw+GRVuwhLr6JteE5T6WcvE=; b=dwRcbTngNIEfEv2zl72E8
        ZZwYqWexLW6Daqrh/MgaiDQXWxb/9EOSVidgZt9fieaNGbObrWh8InTbGG7Qw8cg
        CsHaUQaTIHHIVQLE6wgQrpZOAf+GGRFMgVTVg6AxH3yDRKtjS7HF8PZxncLEayPx
        l3WOCtuSetE9rEHQQqHYMo=
Received: from [192.168.0.6] (unknown [125.82.11.8])
        by smtp8 (Coremail) with SMTP id DMCowADX3n6ck4Rek3WCBg--.112S2;
        Wed, 01 Apr 2020 21:14:05 +0800 (CST)
Subject: Re: [PATCH] net/mlx5: improve some comments
To:     saeedm@mellanox.com, leon@kernel.org, davem@davemloft.net
Cc:     guoren@kernel.org, xiubli@redhat.com, jeyu@kernel.org, cai@lca.pw,
        wqu@suse.com, stfrench@microsoft.com,
        yamada.masahiro@socionext.com, chris@chris-wilson.co.uk,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200401125720.20276-1-xianfengting221@163.com>
From:   Hu Haowen <xianfengting221@163.com>
Message-ID: <16dea5e4-fb5b-d269-2dff-3349f260a13c@163.com>
Date:   Wed, 1 Apr 2020 21:14:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200401125720.20276-1-xianfengting221@163.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: DMCowADX3n6ck4Rek3WCBg--.112S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr4UAryDAryfur1rGFWxZwb_yoWkKFX_Cr
        nxuw13Xw1UWr9YkrW5uw45JrWrKr4Y9rs3AF4jqay3X3yDCr4xJ34DG34UGFn7WFWjqFn8
        A3WaqF1UA3sYvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnBOJUUUUUU==
X-Originating-IP: [125.82.11.8]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/1tbiPh34AFxBg1tjjwAAsy
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On 2020/4/1 8:57 PM, Hu Haowen wrote:
> Added a missing space character and replaced "its" with "it's".

Sorry, this patch does not include space character adding. Please
ignore and delete that part of the commit message.


> Signed-off-by: Hu Haowen <xianfengting221@163.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> index c9c9b479bda5..0a8adda073c2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> @@ -684,7 +684,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
>   		get_block_timestamp(tracer, &tmp_trace_block[TRACES_PER_BLOCK - 1]);
>   
>   	while (block_timestamp > tracer->last_timestamp) {
> -		/* Check block override if its not the first block */
> +		/* Check block override if it's not the first block */
>   		if (!tracer->last_timestamp) {
>   			u64 *ts_event;
>   			/* To avoid block override be the HW in case of buffer

