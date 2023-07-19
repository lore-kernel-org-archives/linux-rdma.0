Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64029C001E0
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Jul 2023 09:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjGSJmi (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 19 Jul 2023 05:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbjGSJme (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 19 Jul 2023 05:42:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B276BE42
        for <linux-rdma@vger.kernel.org>; Wed, 19 Jul 2023 02:42:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 368BA6132C
        for <linux-rdma@vger.kernel.org>; Wed, 19 Jul 2023 09:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E861CC433C7;
        Wed, 19 Jul 2023 09:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689759752;
        bh=GchyoraxLfzqhlpmhflAMQ02VEUEgBP5VgzZ4epkrtI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qqPt/cHsPbYY3WXPEol7Qx3Apkqr2/hhNnydy3AG47H7lwaIFnpEQ5TbjxLVL1pOl
         63/ALMdRubNFXcrU6eCtUD8RmwCDU0Z8FZDzsft9eO6brEqV6x8oNyVuQogia4Wcbj
         JgVVg56woKVev/R34Z+rB/wvooKcI79fwMfgCfIBkjiEDFDVI6Nat2FMpwWBtvw6W3
         uxGyUJi/bnaiFmLyYrOgFau5gAM+tw1HBySWZpjrOr2QWSTcl6jzPwMgCYauXyDgGc
         yEwu0oVpeCcVZzWgprznsYJsiPn0xizbjMlSMU5v0Cirmujg4n95p+vY4gjYknpDkD
         LpezO3HioKIdQ==
Date:   Wed, 19 Jul 2023 12:42:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Shetu Ayalew <shetu@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH rdma-next] IB/mlx5: Add HW counter called rx_dct_connect
Message-ID: <20230719094228.GK8808@unreal>
References: <6d2313eedc567fc29f5ba53c197d5678962bb43a.1689757404.git.leon@kernel.org>
 <555e4ba0-410a-b9b5-eee8-dfacebae38e7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555e4ba0-410a-b9b5-eee8-dfacebae38e7@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Jul 19, 2023 at 09:30:53AM +0000, Mark Zhang wrote:
> On 7/19/2023 5:03 PM, Leon Romanovsky wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > From: Shetu Ayalew <shetu@nvidia.com>
> > 
> > The rx_dct_connect counter shows the number of received connection
> > requests for the associated DCTs.
> > 
> > Signed-off-by: Shetu Ayalew <shetu@nvidia.com>
> > Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   drivers/infiniband/hw/mlx5/counters.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
> > index 93257fa5aae8..14af6ff91dfa 100644
> > --- a/drivers/infiniband/hw/mlx5/counters.c
> > +++ b/drivers/infiniband/hw/mlx5/counters.c
> > @@ -40,6 +40,7 @@ static const struct mlx5_ib_counter retrans_q_cnts[] = {
> >          INIT_Q_COUNTER(packet_seq_err),
> >          INIT_Q_COUNTER(implied_nak_seq_err),
> >          INIT_Q_COUNTER(local_ack_timeout_err),
> > +       INIT_Q_COUNTER(rx_dct_connect),
> >   };
> > 
> >   static const struct mlx5_ib_counter vport_basic_q_cnts[] = {
> > --
> > 2.41.0
> > 
> 
> Just curious why it's in retrans_q_cnts[], instead of basic_q_cnts[]:

Ohh, you are right, it should be basic_q_cnts.

Thanks Mark.

> 
> diff --git a/drivers/infiniband/hw/mlx5/counters.c 
> b/drivers/infiniband/hw/mlx5/counters.c
> index 93257fa5aae8..8300ce622835 100644
> --- a/drivers/infiniband/hw/mlx5/counters.c
> +++ b/drivers/infiniband/hw/mlx5/counters.c
> @@ -27,6 +27,7 @@ static const struct mlx5_ib_counter basic_q_cnts[] = {
>          INIT_Q_COUNTER(rx_write_requests),
>          INIT_Q_COUNTER(rx_read_requests),
>          INIT_Q_COUNTER(rx_atomic_requests),
> +       INIT_Q_COUNTER(rx_dct_connect),
>          INIT_Q_COUNTER(out_of_buffer),
>   };
> 
> @@ -46,6 +47,7 @@ static const struct mlx5_ib_counter 
> vport_basic_q_cnts[] = {
>          INIT_VPORT_Q_COUNTER(rx_write_requests),
>          INIT_VPORT_Q_COUNTER(rx_read_requests),
>          INIT_VPORT_Q_COUNTER(rx_atomic_requests),
> +       INIT_VPORT_Q_COUNTER(rx_dct_connect),
>          INIT_VPORT_Q_COUNTER(out_of_buffer),
>   };
