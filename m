Return-Path: <SRS0=NVh0=D5=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6093C388F7
	for <linux-rdma@archiver.kernel.org>; Thu, 22 Oct 2020 14:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D2F02463B
	for <linux-rdma@archiver.kernel.org>; Thu, 22 Oct 2020 14:52:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WVBGiV4P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368238AbgJVOwv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 22 Oct 2020 10:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368214AbgJVOwu (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 22 Oct 2020 10:52:50 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CF6C0613CE;
        Thu, 22 Oct 2020 07:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=oKEWyOVhaTMgm/+2u2GsofkNM4gFyJP7/a/xXAM9lSE=; b=WVBGiV4PEt7rg6l9yeRC27g4Y6
        861wWhrpEdE4OpAbajPSo/h8yEG3Hkc8bUSCW6wZIhFrLlW+WEzhSb2w9l7Ev+j6brP3hoKBvnMHn
        GfKjjnRsnCyeFwgeCWfzyylQLKW4Dv8QiD3tteTQJqqBuM+Y+JulqY6kn7UeaVEFSGXhn6cfwBMLf
        PUIb1ILRHKNQabUSkHhnaJO6QF511GzoMv8Lu/ezdEZGmJl+sGOFxTcJ/01QVDlGviBgIRbgsOyXc
        HAHno9XHZGBqNPEs5HwGW+SbSnch0EOb6Kls0xYUE0QkxBkdmS+Diw+chJFrXf7nprG+1NooWwjpj
        KXuoImZw==;
Received: from [2601:1c0:6280:3f0::507c]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVbxQ-0002rh-3X; Thu, 22 Oct 2020 14:52:48 +0000
Subject: Re: linux-next: Tree for Oct 22 (mlx5)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20201022144126.67d0cad9@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <646c66a0-f473-bbe6-960b-42736fcb0006@infradead.org>
Date:   Thu, 22 Oct 2020 07:52:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201022144126.67d0cad9@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 10/21/20 8:41 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Since the merge window is open, please do not add any v5.11 material to
> your linux-next included branches until after v5.10-rc1 has been released.
> 
> Changes since 20201021:
> 

on x86_64:
when CONFIG_IPV6 is not set/enabled:

In file included from ../include/linux/tcp.h:19:0,
                 from ../include/linux/ipv6.h:88,
                 from ../include/net/ipv6.h:12,
                 from ../include/rdma/ib_verbs.h:24,
                 from ../include/linux/mlx5/device.h:37,
                 from ../include/linux/mlx5/driver.h:52,
                 from ../drivers/net/ethernet/mellanox/mlx5/core/en.h:40,
                 from ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h:7,
                 from ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:5:
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c: In function ‘accel_fs_tcp_set_ipv6_flow’:
../include/net/sock.h:380:34: error: ‘struct sock_common’ has no member named ‘skc_v6_daddr’; did you mean ‘skc_daddr’?
 #define sk_v6_daddr  __sk_common.skc_v6_daddr
                                  ^
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:55:14: note: in expansion of macro ‘sk_v6_daddr’
         &sk->sk_v6_daddr, 16);

At top level:
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:47:13: warning: ‘accel_fs_tcp_set_ipv6_flow’ defined but not used [-Wunused-function]
 static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock *sk)



-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
