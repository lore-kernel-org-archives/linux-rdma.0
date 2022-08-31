Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED689ECAAD1
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Aug 2022 14:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiHaO13 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 31 Aug 2022 10:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiHaO1P (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 31 Aug 2022 10:27:15 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9402013D0C;
        Wed, 31 Aug 2022 07:27:08 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id q9so13650495pgq.6;
        Wed, 31 Aug 2022 07:27:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=DsoXuHtlvfTG8c5sK5Njdz6GsfiGSg/UbyFHXvg+7Fo=;
        b=mLbeXQfllgXa8W0x5vsufBIVZlTkbojPRICCbC1iIOqZ5X+3DSHT5651s8LUfM/h8h
         3xHKBa9XNIcI/c36Pu3C9GfAnVVBVQ9OsqRVeY9FTqz/4FntiNbDZ2CoemkfyM+s0R63
         1F7NSyHXYJ0QYpt2LqsDLNFktRnJToC5fEEI31uzcYiU6geqWWJqzlotr4nutyCtCgio
         lK0iP/nfBPLQ0JqyOR+NdaHFSyMwo4SqKwvgNUbqJJJVCOViXnAC3KmiCCGC12tyYZ0k
         9gESYyoRMGpCknNAMmiD1oMVlXCsC3V/+h7YwXry5SloRyIcsfcLGNOeAx5WSBggkV8P
         7yiw==
X-Gm-Message-State: ACgBeo1PX0wC6SX2OEOyPPeGmPiXupTsqeokGz6B7dqRpjXE03jWB8gm
        XAmikWZLAPTdxnr/dn27+C32w83MQig=
X-Google-Smtp-Source: AA6agR5j12b8TF3UTeaeYLGzHWsCDOyDwzVD1rWm4ukluhOkv0LWVn6+93W8eWpVHzz3w5RJrAbcEg==
X-Received: by 2002:a63:f357:0:b0:423:31a8:8d71 with SMTP id t23-20020a63f357000000b0042331a88d71mr22663162pgj.358.1661956027990;
        Wed, 31 Aug 2022 07:27:07 -0700 (PDT)
Received: from [172.20.0.236] ([12.219.165.6])
        by smtp.gmail.com with ESMTPSA id k7-20020a170902c40700b00174c235e1fdsm7010894plk.199.2022.08.31.07.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 07:27:07 -0700 (PDT)
Message-ID: <44fa980e-85eb-c5ff-fc22-878ad94c4431@acm.org>
Date:   Wed, 31 Aug 2022 07:27:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] RDMA/srp: Set scmnd->result only when scmnd is not
 NULL
Content-Language: en-US
To:     "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
References: <20220831081626.18712-1-yangx.jy@fujitsu.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220831081626.18712-1-yangx.jy@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 8/31/22 01:16, yangx.jy@fujitsu.com wrote:
> This change fixes the following kernel NULL pointer dereference
> which is reproduced by blktests srp/007 occasionally.

Acked-by: Bart Van Assche <bvanassche@acm.org>
