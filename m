Return-Path: <SRS0=nSk8=VH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC1DC73C68
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jul 2019 04:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D34992083D
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jul 2019 04:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562732700;
	bh=4FdvBTrd6aaIrNkb5WVHmme5xSc6VGxXjEjCFOP6XLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gndVR7LtARVXdUITw95N9GHVrd1xrnLNSWkmVaECCWmZfMreQIHCOVdOZRAZJ28cb
	 RB3dmNjHN4iyb3DbEOXnUgSzVd1Vg6Nz7TU/Zejyfh3E8W+Zj4QIAsf7dlXAjlVqWi
	 ks8SGq1rq90hr62Bi5HQKN9E+5aqzEGvI9V0tV68=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfGJEY7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Jul 2019 00:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfGJEY7 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 10 Jul 2019 00:24:59 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E40E20838;
        Wed, 10 Jul 2019 04:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562732698;
        bh=4FdvBTrd6aaIrNkb5WVHmme5xSc6VGxXjEjCFOP6XLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g5uk2FqiNoyYWFK0+7CgTfGD+95ZstYT7cOUMZ98ezviEt4PmI+nQjvFKhhzZBdQq
         fIXuoHwz/RcMEzGAoTotMq8ESW/DTaOEaLQCR/AOSG0NekD/dGCBpxHOQPbdDa6Pyn
         xCQgWfGImwxrhUo/fjBHhSPiFlmOgWKogPELIZjE=
Date:   Wed, 10 Jul 2019 07:24:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] net/mlx5e: Return in default case statement in
 tx_post_resync_params
Message-ID: <20190710042453.GZ7034@mtr-leonro.mtl.com>
References: <20190708231154.89969-1-natechancellor@gmail.com>
 <CAKwvOdkYdNiKorJAKHZ7LTfk9eOpMqe6F4QSmJWQ=-YNuPAyrw@mail.gmail.com>
 <20190709231024.GA61953@archlinux-threadripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709231024.GA61953@archlinux-threadripper>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jul 09, 2019 at 04:10:24PM -0700, Nathan Chancellor wrote:
> On Tue, Jul 09, 2019 at 03:44:59PM -0700, Nick Desaulniers wrote:
> > On Mon, Jul 8, 2019 at 4:13 PM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > clang warns:
> > >
> > > drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:251:2:
> > > warning: variable 'rec_seq_sz' is used uninitialized whenever switch
> > > default is taken [-Wsometimes-uninitialized]
> > >         default:
> > >         ^~~~~~~
> > > drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:255:46: note:
> > > uninitialized use occurs here
> > >         skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
> > >                                                     ^~~~~~~~~~
> > > drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:239:16: note:
> > > initialize the variable 'rec_seq_sz' to silence this warning
> > >         u16 rec_seq_sz;
> > >                       ^
> > >                        = 0
> > > 1 warning generated.
> > >
> > > This case statement was clearly designed to be one that should not be
> > > hit during runtime because of the WARN_ON statement so just return early
> > > to prevent copying uninitialized memory up into rn_be.
> > >
> > > Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/590
> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> > > index 3f5f4317a22b..5c08891806f0 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> > > @@ -250,6 +250,7 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
> > >         }
> > >         default:
> > >                 WARN_ON(1);
> > > +               return;
> > >         }
> >
> > hmm...a switch statement with a single case is a code smell.  How
> > about a single conditional with early return?  Then the "meat" of the
> > happy path doesn't need an additional level of indentation.
> > --
> > Thanks,
> > ~Nick Desaulniers
>
> I assume that the reason for this is there may be other cipher types
> added in the future? I suppose the maintainers can give more clarity to
> that.

Our devices supports extra ciphers, for example TLS_CIPHER_AES_GCM_256.
So I assume this was the reason for switch<->case, but because such
implementation doesn't exist in any driver, I recommend to rewrite the
code to have "if" statement and return early.

>
> Furthermore, if they want the switch statements to remain, it looks like
> fill_static_params_ctx also returns in the default statement so it seems
> like this is the right fix.
>
> Cheers,
> Nathan
