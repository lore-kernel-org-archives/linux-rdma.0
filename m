Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67086C7EE23
	for <linux-rdma@archiver.kernel.org>; Wed,  1 Mar 2023 03:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjCADYc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 28 Feb 2023 22:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCADYb (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 28 Feb 2023 22:24:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E316F158AF;
        Tue, 28 Feb 2023 19:24:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78CF96122E;
        Wed,  1 Mar 2023 03:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCD9C4339C;
        Wed,  1 Mar 2023 03:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677641069;
        bh=VNUiYHTK1WmTQNHzsmJaVBzgcpH8B55pyube1Ia3Fvs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c9SR42IIbZ4yZSGobj6hJEq88zt7jTRltAJsX5QxL30SKT40Vprrr0m/0su9lCUp8
         ZjHu2Hku+8PsKurVCpeh/KZjviLtvBwxAmuwR2OcPukWnlVdoNvvRLg3GDw0Kt7Pdn
         V9qi4E/JkdvFN9/7hJd9xHlU+EZOuub2Bop8JALCvHrhekBEpyBxYYUJcTbZ5mIPFn
         uKZvjLcamSXebshdu/1anQ3F46VF/qGvHOwQSClFEXUIFQBybfrYLdQ+TuMlSpWWjs
         zvwm//OCbY1qSvDKBTJ990thy8U8QYxyqJVlm2Ub8QGtHU4ZdbJqCvAcyDzd/M20J2
         frQTU/NKdFaRg==
Date:   Tue, 28 Feb 2023 19:24:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 0/4] net/smc: Introduce BPF injection
 capability
Message-ID: <20230228192428.447ceddc@kernel.org>
In-Reply-To: <Y/67dZ8X+VoOi10b@TONYMAC-ALIBABA.local>
References: <1677576294-33411-1-git-send-email-alibuda@linux.alibaba.com>
        <20230228150051.4eeaa121@kernel.org>
        <Y/67dZ8X+VoOi10b@TONYMAC-ALIBABA.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, 1 Mar 2023 10:41:57 +0800 Tony Lu wrote:
> Actually, this patch set is going to replace the patch of TCP ULP for
> SMC. If this patch set is accepted, I am going to revert that patch.
> 
> For the reasons, the TCP ULP for SMC doesn't use wildly. It's not
> possible to know which applications are suitable to be replaced with
> SMC. But it's easier to detect the behavior of applications and
> determine whether to replace applications with SMC. And this patch set
> is going to fallback to TCP by behavior with eBPF.
> 
> So this is the _fix_ for that patch.

Good to hear, I was worried you'd still want to install the ULP at some
point whether the decision is via BPF or user space.
