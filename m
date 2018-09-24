From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH] iw_cxgb4: Use proper enumerated type in c4iw_bar2_addrs
Date: Mon, 24 Sep 2018 14:41:26 -0500
Message-ID: <f1c6aef0-40d4-f0c4-b008-28ca22280d46@opengridcomputing.com>
References: <20180924192903.16796-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180924192903.16796-1-natechancellor@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-rdma@vger.kernel.org



On 9/24/2018 2:29 PM, Nathan Chancellor wrote:
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

Looks correct, Thanks.

Acked-by: Steve Wise <swise@opengridcomputing.com>
