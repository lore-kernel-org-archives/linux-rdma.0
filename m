Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA19BC7EE23
	for <linux-rdma@archiver.kernel.org>; Mon,  5 Jun 2023 22:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjFEWsF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 5 Jun 2023 18:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjFEWsF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 5 Jun 2023 18:48:05 -0400
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F492D9
        for <linux-rdma@vger.kernel.org>; Mon,  5 Jun 2023 15:48:04 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b035e94072so10703021fa.1
        for <linux-rdma@vger.kernel.org>; Mon, 05 Jun 2023 15:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686005282; x=1688597282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3HePtUdxH0wJGOlf9KCmbfvF/q7viOZyOmY/5Y380GU=;
        b=Pohjbo26z4t5m0R9BFymMvpRGxluetgML9VLJR/fcnqF7nQ+Mgu5mnGkecj1jJJcWv
         5xcbpik9x6UmbUDoufqvR+4BlmtfuXK1WpHmEapjxfqhBOArU7keQZca1qrwC42TnjIj
         7Gpz3DIosezdekihy3/boQfkHfUnjDzVQk86DKa0BkthjHiJI/4f3E0VLxwmPjybYva4
         1EOZxKsEgrbvK6kS8gWm7rVgXEnbc8o/MY7TqqT+117ImLgVJ8ZrweVkd5CId2Ylfen4
         kmd0lNeCofryC50vGZWU7y8TiYnG4wwUskJ/jUePOXaz8I8f6h1cUJOk9DAHa5BnOOl8
         eyEA==
X-Gm-Message-State: AC+VfDzuOToidWIjO54pGgAX5+CiqpqUVf4mVA8217ogiluX7thAXLe4
        1pgAQY9qAfehjbh1Is255wY=
X-Google-Smtp-Source: ACHHUZ4GMWv5HfDNJut/+XpI9vyCdUqqyx1WVFWwSt0FYuC/U80F8uXDguvpFthv18NLkgKXxut1YQ==
X-Received: by 2002:a05:651c:381:b0:2ac:767c:fba0 with SMTP id e1-20020a05651c038100b002ac767cfba0mr295240ljp.2.1686005282221;
        Mon, 05 Jun 2023 15:48:02 -0700 (PDT)
Received: from [10.100.102.14] (46-117-190-200.bb.netvision.net.il. [46.117.190.200])
        by smtp.gmail.com with ESMTPSA id f7-20020a2e3807000000b002afd30401b0sm1614515lja.138.2023.06.05.15.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 15:48:01 -0700 (PDT)
Message-ID: <150253ed-5fd5-9404-7792-bc14f210cdd3@grimberg.me>
Date:   Tue, 6 Jun 2023 01:48:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH for-rc 2/3] IB/isert: Fix possible list corruption in CMA
 handler
Content-Language: en-US
To:     Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
        selvin.xavier@broadcom.com, jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org
References: <20230601094220.64810-1-saravanan.vajravel@broadcom.com>
 <20230601094220.64810-3-saravanan.vajravel@broadcom.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230601094220.64810-3-saravanan.vajravel@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 6/1/23 12:42, Saravanan Vajravel wrote:
> When ib_isert module receives connection error event, it is
> releasing the isert session and removes corresponding list
> node but it doesn't take appropriate mutex lock to remove
> the list node.  This can lead to linked  list corruption
> 
> Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index b3471ac82c1a..64af8d966adf 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -657,11 +657,15 @@ static int
>   isert_connect_error(struct rdma_cm_id *cma_id)
>   {
>   	struct isert_conn *isert_conn = cma_id->qp->qp_context;
> +	struct isert_np *isert_np = cma_id->context;
>   
>   	ib_drain_qp(isert_conn->qp);
> +
> +	mutex_lock(&isert_np->mutex);
>   	list_del_init(&isert_conn->node);
>   	isert_conn->cm_id = NULL;
>   	isert_put_conn(isert_conn);
> +	mutex_unlock(&isert_np->mutex);

I'd place the mutex on the list_del_init only, it does not
protect the rest.
