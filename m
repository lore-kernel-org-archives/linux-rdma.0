From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] iw_cxgb4: Use proper enumerated type in c4iw_bar2_addrs
Date: Tue, 25 Sep 2018 14:46:47 -0600
Message-ID: <20180925204647.GB24279@ziepe.ca>
References: <20180924192903.16796-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180924192903.16796-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 24, 2018 at 12:29:03PM -0700, Nathan Chancellor wrote:
> Clang warns when one enumerated type is implicitly converted to another.
> 
> drivers/infiniband/hw/cxgb4/qp.c:287:8: warning: implicit conversion
> from enumeration type 'enum t4_bar2_qtype' to different enumeration type
> 'enum cxgb4_bar2_qtype' [-Wenum-conversion]
>                                                  T4_BAR2_QTYPE_EGRESS,
>                                                  ^~~~~~~~~~~~~~~~~~~~
> 
> c4iw_bar2_addrs expects a value from enum cxgb4_bar2_qtype so use the
> corresponding values from that type so Clang is satisfied without
> changing the meaning of the code.
> 
> T4_BAR2_QTYPE_EGRESS = CXGB4_BAR2_QTYPE_EGRESS = 0
> T4_BAR2_QTYPE_INGRESS = CXGB4_BAR2_QTYPE_INGRESS = 1
> 
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Acked-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  drivers/infiniband/hw/cxgb4/cq.c | 2 +-
>  drivers/infiniband/hw/cxgb4/qp.c | 7 ++++---
>  2 files changed, 5 insertions(+), 4 deletions(-)

Applied to for-next

Thanks,
Jason
