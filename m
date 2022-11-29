Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E6EC4332F
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Nov 2022 18:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbiK2SoF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Nov 2022 13:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235871AbiK2SoD (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 29 Nov 2022 13:44:03 -0500
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BC72612B;
        Tue, 29 Nov 2022 10:43:56 -0800 (PST)
Received: by mail-pf1-f181.google.com with SMTP id x66so14549073pfx.3;
        Tue, 29 Nov 2022 10:43:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sYPth5BQVrDX75aFx/+sC7AKQI5zsDp3wXLvquf4TpA=;
        b=s8hijUnfC7LZmPpOIHas+7M3ZpfMhHAT323MKp5w5TLuTgcU5lo4xEusYh7QYEGCSq
         xLNifNLWZwpmV2WCUKOyDqw2af0B7+VDU7pJykimqVqQ7QUpi5S+3uWvIJkWnaRHm/B4
         PLU2kzDeu83wGEvdHhSz2YzyJjhXloVDQqYOJJqp0Mqbxs0fwLvIYKxUezz92MNO6sk7
         mDzHd9eVjDSsMeDLpsuPwVpDrpWAjX9RaxUOuOq5IQ/sGC58szsYsu23bUn0emEg1taS
         Fdb9jfPoKUJccDVzJT0oLu2y2lVBw5QJWBfXDTmXRY2D9HlrSoPQyGTxfS/r61tdxd1H
         frXQ==
X-Gm-Message-State: ANoB5plp6zKsrE7jADbZdkn++xaJStJvXsm/IpfyH/kgSu94oTgznRVy
        ww3A7HNUvFJ2KFxqCjbyU8E=
X-Google-Smtp-Source: AA0mqf72OXF6reXJcsMeTu+K/BN44/9w+pKQFF1ztSjciayyFkKhObLva3AYQ5n96Jo3TXEqynjTkA==
X-Received: by 2002:a63:155e:0:b0:476:95a8:de91 with SMTP id 30-20020a63155e000000b0047695a8de91mr32786090pgv.102.1669747436382;
        Tue, 29 Nov 2022 10:43:56 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:7d15:8e62:30bb:9a14? ([2620:15c:211:201:7d15:8e62:30bb:9a14])
        by smtp.gmail.com with ESMTPSA id nu8-20020a17090b1b0800b002193a995482sm1690888pjb.24.2022.11.29.10.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 10:43:55 -0800 (PST)
Message-ID: <b4d78eb0-4492-ac7f-d500-3d49b0dc7aa1@acm.org>
Date:   Tue, 29 Nov 2022 10:43:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 2/2] RDMA/srp: Fix error return code in
 srp_parse_options()
Content-Language: en-US
To:     Wang Yufen <wangyufen@huawei.com>, jgg@ziepe.ca, leon@kernel.org,
        dennis.dalessandro@cornelisnetworks.com
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, bart.vanassche@wdc.com,
        easwar.hariharan@intel.com
References: <1669687459-14180-1-git-send-email-wangyufen@huawei.com>
 <1669687459-14180-2-git-send-email-wangyufen@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1669687459-14180-2-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 11/28/22 18:04, Wang Yufen wrote:
> In the previous while loop, "ret" may be assigned zero, , so the error

The word "iteration" is missing from the above sentence. Additionally, 
there is a double comma.

> return code may be incorrectly set to 0 instead of -EINVAL. Alse

Alse -> Also

>   		case SRP_OPT_QUEUE_SIZE:
> -			if (match_int(args, &token) || token < 1) {
> +			ret = match_int(args, &token);
> +			if (ret)
> +				goto out;
> +			if (token < 1) {
>   				pr_warn("bad queue_size parameter '%s'\n", p);
> +				ret = -EINVAL;
>   				goto out;
>   			}
>   			target->scsi_host->can_queue = token;

Why only to report "bad queue_size parameter" if ret == 0 && token < 1 
but not if ret < 0? This is a behavior change that has not been 
explained in the patch description.

> @@ -3490,25 +3496,34 @@ static int srp_parse_options(struct net *net, const char *buf,
>   			break;
>   
>   		case SRP_OPT_MAX_CMD_PER_LUN:
> -			if (match_int(args, &token) || token < 1) {
> +			ret = match_int(args, &token);
> +			if (ret)
> +				goto out;
> +			if (token < 1) {
>   				pr_warn("bad max cmd_per_lun parameter '%s'\n",
>   					p);
> +				ret = -EINVAL;
>   				goto out;
>   			}
>   			target->scsi_host->cmd_per_lun = token;
>   			break;

Same comment here and for many other changes below.

Thanks,

Bart.

