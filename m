From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Tue, 31 May 2016 11:13:06 -0600
Message-ID: <20160531171306.GA6618@obsidianresearch.com>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
 <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Max Gurtovoy <maxg@mellanox.com>, matanb@mellanox.com, leon@leon.nu, sagi@grimberg.me, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 31, 2016 at 08:35:10AM -0700, Bart Van Assche wrote:
> On 05/30/16 03:09, Max Gurtovoy wrote:
> >ib_device_cap_flags 64-bit expansion caused a possible caps overlapping
> >(depending on machine endianness) and made consumers read wrong device
> >capabilities. For example IB_DEVICE_SG_GAPS_REG was falsely read by the
> >iser driver causing it to use a non-existing capability. Fix this by
> >casting ib_device_cap_flags enumerations to ULL.
> >
> > [ ... ]
> >diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> >[ ... ]
> > enum ib_device_cap_flags {
> >       [ ... ]
> > 	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
> >      [ ... ]
> > };
> 
> How can this patch make a difference? The presence of any constant
> in an enum that does not fit in a 32-bit integer makes an enum 64
> bits wide. In other words, all the changes from "1" into "1ULL" in
> this patch do not have

The expressions are evaluated before the enum type is decided, the
enum type has no impact on the type of the expressions.

(1<<32) is always undefined behavior because '1' is only a 32 bit type.

I'm confused why we didn't get any static checker hits on the shift
overflow - modern compilers warn on that??

Jason
