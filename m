Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6F7C0015E
	for <linux-rdma@archiver.kernel.org>; Mon, 24 Jul 2023 17:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbjGXRyf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjGXRyR (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 24 Jul 2023 13:54:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4363D1FCF;
        Mon, 24 Jul 2023 10:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C9E961380;
        Mon, 24 Jul 2023 17:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A60C433B9;
        Mon, 24 Jul 2023 17:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690220831;
        bh=3XwirjoLnPCgSltx4kx1ehpz0VSB+lrzwShEyZV3teg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I2br1FiiNlts4U71C5B0I0vtSSSexW8W4oOr6LvDMbzWIg8lbSmznEg486ggH/vLb
         lnXFA+mL12zdS8m1tNRoA5ldSk9dwkD2ZKbAt0nIWECa7aOGof4p0YNHUzuhrY+Qbx
         XqFG+n5+mVbx6aWhTvHXNQIO45IFPJFbOr98DBOBMZOS+3k6CYIo4WN3n0I67Sz8y3
         8evgnInnh0eZ498jP/P5lx6jV1oHDOcwqykKX3QwBUykH+RAcsDPzHcJhYxQdAQlsI
         1BFJcjKzgQh3W6mkqAxha5chMiV9xApS7CmmNwLgVul2W5YgkdNtlKnxtOBGqYGwO3
         okndwtB40yvnw==
Date:   Mon, 24 Jul 2023 20:47:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     jgg@ziepe.ca, markzhang@nvidia.com, michaelgur@nvidia.com,
        ohartoov@nvidia.com, chenzhongjin@huawei.com, yuancan@huawei.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] RDMA/nldev: Add length check for
 IFLA_BOND_ARP_IP_TARGET parsing
Message-ID: <20230724174707.GB11388@unreal>
References: <20230723074504.3706691-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230723074504.3706691-1-linma@zju.edu.cn>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Jul 23, 2023 at 03:45:04PM +0800, Lin Ma wrote:
> The nla_for_each_nested parsing in function
> nldev_stat_set_counter_dynamic_doit() does not check the length of the
> attribute. This can lead to an out-of-attribute read and allow a
> malformed nlattr (e.g., length 0) to be viewed as a 4 byte integer.

1. Subject of this patch doesn't really match the change.
2. See my comment on your i40e patch.
https://lore.kernel.org/netdev/20230724174435.GA11388@unreal/

Thanks
