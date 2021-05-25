Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F08C47085
	for <linux-rdma@archiver.kernel.org>; Tue, 25 May 2021 04:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4398361425
	for <linux-rdma@archiver.kernel.org>; Tue, 25 May 2021 04:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhEYELj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 25 May 2021 00:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhEYELi (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 25 May 2021 00:11:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8638060FDA;
        Tue, 25 May 2021 04:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621915809;
        bh=F1vsYbd/GlvINyjwQQmr6wnTcRu7kV0sEFCqs1mHRmI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jMvxF+OfdXRZC4tIjdTKj1219nBM+LkpYFZ2p8j6X2iI/KHfJBcW4kwHtl1AxUdNu
         CEaJjcv0N7hJVb/MljzzNh9zYx/71/J2yc/vFtMWmQw5RsaRNJPvtH0GfUwZMQpD2N
         8SzSWIIzOQXkLcx5YjvRuOfcVs5L7nQm5PUxWcY6KflrfgLuFFTwKhI6rvD27gXoEx
         OVEkD/Yg6f8+50xKhfZvofRiPKtOfyqb7LSP3PqGiPiHgBowpkZT4Ric0YJr2NP20Q
         QCUWElFEIhNxmXIyMl1/zc1a8uX88GaLPN+GZLNWM2LWMivJr0KC8YEMisvrdkTUBX
         K2G75QeRg/J8A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] samples: bpf: ix kernel-doc syntax in file header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162191580948.24013.704618312560321536.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 04:10:09 +0000
References: <20210523151408.22280-1-yashsri421@gmail.com>
In-Reply-To: <20210523151408.22280-1-yashsri421@gmail.com>
To:     Aditya Srivastava <yashsri421@gmail.com>
Cc:     kafai@fb.com, lukas.bulwahn@gmail.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Sun, 23 May 2021 20:44:08 +0530 you wrote:
> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> The header for samples/bpf/ibumad_kern.c follows this syntax, but
> the content inside does not comply with kernel-doc.
> 
> This line was probably not meant for kernel-doc parsing, but is parsed
> due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
> causes unexpected warnings from kernel-doc:
> warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * ibumad BPF sample kernel side
> 
> [...]

Here is the summary with links:
  - [v2] samples: bpf: ix kernel-doc syntax in file header
    https://git.kernel.org/bpf/bpf-next/c/4ce7d68beb9e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


