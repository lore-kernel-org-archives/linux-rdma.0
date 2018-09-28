From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] RDMA/qedr: Remove enumerated type qed_roce_ll2_tx_dest
Date: Fri, 28 Sep 2018 10:14:33 -0600
Message-ID: <20180928161433.GC24524@ziepe.ca>
References: <20180927011820.13608-1-natechancellor@gmail.com>
 <20180927205557.32026-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180927205557.32026-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 27, 2018 at 01:55:58PM -0700, Nathan Chancellor wrote:
> Clang warns when one enumerated type is explicitly converted to another.
> 
> drivers/infiniband/hw/qedr/qedr_roce_cm.c:198:28: warning: implicit
> conversion from enumeration type 'enum qed_roce_ll2_tx_dest' to
> different enumeration type 'enum qed_ll2_tx_dest' [-Wenum-conversion]
>         ll2_tx_pkt.tx_dest = pkt->tx_dest;
>                            ~ ~~~~~^~~~~~~
> 1 warning generated.
> 
> Turns out that QED_ROCE_LL2_TX_DEST_NW and QED_ROCE_LL2_TX_DEST_LB are
> only used once in the whole tree and QED_ROCE_LL2_TX_DEST_MAX is used
> nowhere. Remove them and use the equivalent values from qed_ll2_tx_dest
> in their place.
> 
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Acked-by: Michal Kalderon <michal.kalderon@cavium.com>
> ---
> 
> v1 -> v2:
> 
> * Rather than using an explicit cast, just convert the uses to the
>   appropriate values and delete the duplicated enum.

Applied to for-next, thanks

Jason
