Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219B4C4332F
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Mar 2022 04:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbiCBEh7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239530AbiCBEhp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 1 Mar 2022 23:37:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DB4B1508;
        Tue,  1 Mar 2022 20:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37050617D4;
        Wed,  2 Mar 2022 04:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D7BC004E1;
        Wed,  2 Mar 2022 04:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646195809;
        bh=+mVvVQ6eR35cGWfvwYFQ1hJ5u16ruLFdnKZR1Dw6rFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tdGQOBRrvgqJJeRZ1QZBJSU+t/m4J4kzVLFsUYg1iZ9ob81wQcQrWqx6BIkJ1eoVq
         rbai4buwlAr7kqcAfDNrdKFnZRYnmA+TN0yxHynBJOu1a8NOjQbt375g+6pVtKD1oK
         8YrPLw6DGxvJZDqGDZ5pK+H7cdJlsb3dAHtVHcYvrmdfjB7FAdIEgebGbW7A2S1Z5H
         +tBZKohn80RfyMxrqfwK8XU4Hze4RNOcHNeNehvScrEuW+aBA9RnvxUdief2YCweXs
         4eB2tWY8MWHxfIoJ5DDUbE+9uMQPU1r221JjxewpJXw60R1bXahHIU++tQzeeuE7CW
         z8nZwUGOaH6wg==
Date:   Tue, 1 Mar 2022 20:36:47 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        ttoukan.linux@gmail.com, brouer@redhat.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [net-next v8 4/4] mlx5: add support for page_pool_get_stats
Message-ID: <20220302043647.nyudrn24nbdmy5lf@sx1>
References: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
 <1646172610-129397-5-git-send-email-jdamato@fastly.com>
 <20220302010225.dlhj3mtikog63zxz@sx1>
 <CALALjgzEerMcHnbEGcrsDPdeO5RPp3TpdZP40RD+Qd7MCv03JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALALjgzEerMcHnbEGcrsDPdeO5RPp3TpdZP40RD+Qd7MCv03JQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 01 Mar 17:50, Joe Damato wrote:
>On Tue, Mar 1, 2022 at 5:02 PM Saeed Mahameed <saeed@kernel.org> wrote:
>>

[...]

>The only options I see are:
>  - A new define that allows setting a custom field name
>(MLX5E_DECLARE_RX_STAT_NAME_OVERRIDE ?), or
>  - Leaving the code as-is
>
>Can you let me know what you prefer for the v9?
>

ack, leave as is.

