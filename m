Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 810E5C4361B
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Dec 2020 05:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447D7207DE
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Dec 2020 05:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgLOFAO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 15 Dec 2020 00:00:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgLOFAO (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 15 Dec 2020 00:00:14 -0500
Date:   Tue, 15 Dec 2020 06:59:29 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Parav Pandit <parav@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [net-next v4 01/15] net/mlx5: Fix compilation warning for 32-bit
 platform
Message-ID: <20201215045929.GG5005@unreal>
References: <20201214214352.198172-1-saeed@kernel.org>
 <20201214214352.198172-2-saeed@kernel.org>
 <CAKgT0UeAaydinMZdfJt_f40eK0xxgEUdTeM7-YJc=pUyqB9-5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKgT0UeAaydinMZdfJt_f40eK0xxgEUdTeM7-YJc=pUyqB9-5A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Dec 14, 2020 at 02:31:25PM -0800, Alexander Duyck wrote:
> On Mon, Dec 14, 2020 at 1:49 PM Saeed Mahameed <saeed@kernel.org> wrote:
> >
> > From: Parav Pandit <parav@nvidia.com>
> >
> > MLX5_GENERAL_OBJECT_TYPES types bitfield is 64-bit field.
> >
> > Defining an enum for such bit fields on 32-bit platform results in below
> > warning.
> >
> > ./include/vdso/bits.h:7:26: warning: left shift count >= width of type [-Wshift-count-overflow]
> >                          ^
> > ./include/linux/mlx5/mlx5_ifc.h:10716:46: note: in expansion of macro ‘BIT’
> >  MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
> >                                              ^~~
> > Use 32-bit friendly left shift.
> >
> > Fixes: 2a2970891647 ("net/mlx5: Add sample offload hardware bits and structures")
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeed@kernel.org>
> > ---
> >  include/linux/mlx5/mlx5_ifc.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> > index 0d6e287d614f..b9f15935dfe5 100644
> > --- a/include/linux/mlx5/mlx5_ifc.h
> > +++ b/include/linux/mlx5/mlx5_ifc.h
> > @@ -10711,9 +10711,9 @@ struct mlx5_ifc_affiliated_event_header_bits {
> >  };
> >
> >  enum {
> > -       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT(0xc),
> > -       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT(0x13),
> > -       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
> > +       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 1ULL << 0xc,
> > +       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = 1ULL << 0x13,
> > +       MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = 1ULL << 0x20,
> >  };
>
> Why not just use BIT_ULL?

mlx5_ifc.h doesn't include bits.h on-purpose and there are "*.c" files
that include that ifc header file, but don't include bits.h either.

It can cause to build failures in random builds.

The mlx5_ifc.h is our main hardware definition file that we are using in
other projects outside of the kernel (rdma-core) too, so it is preferable
to keep it as plain-C without any extra dependencies.

Thanks
