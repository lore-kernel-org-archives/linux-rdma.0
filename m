Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26D2C4338F
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Aug 2021 21:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4AA560ED6
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Aug 2021 21:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhHEVCs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 5 Aug 2021 17:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230359AbhHEVCr (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 5 Aug 2021 17:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9D6560ED6;
        Thu,  5 Aug 2021 21:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628197353;
        bh=F7bxRg5LJfVYQAg2hfvdz+rTQBnSUFwYrzmL/mG3yao=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YDdvAeKtHPtLqantd3oxnZOjVZFKQuDppzItSmRUxYBf6FLaBJzqoe6eUrUTnvj5Q
         xL05Ves8PfIBxk1q6CpM24uNQb5H0DX0iPjTBw6dvoz5Tfp3ZiRxV4Gw+mrD9rihi8
         5FvpuX4ZHL5SzHU1mXuQMorVG+CcDp7YCx3dn2ifi1FhMqMyOe1eb4LsFuk+kBv9W3
         Ac++QvjeMMoCG0qisrzhbaj/JMW5VEAuZf3xg3N91eVcL9/ZLjmMNZTPVBLk4hnij7
         uMqPRcA8va3hUlHOsxoH5COR8jl1DPDU+NLND2M3xnPtIdWjymB4oW3yhLp8vbbEhQ
         J+IhX6WXtCm3A==
Message-ID: <875ef4b7f25f86d84d846a16aa69c4b9d5b5235d.camel@kernel.org>
Subject: Re: [PATCH mlx5-next 00/14] mlx5 single FDB for lag
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Date:   Thu, 05 Aug 2021 14:02:32 -0700
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 2021-08-03 at 16:19 -0700, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This series is aimed at mlx5-next branch to be pulled later by both
> rdma and netdev subsystems as it contains patches to both trees.
> 
> The series provides support for single shared FDB table for lag:

applied to mlx5-next, Thanks !

