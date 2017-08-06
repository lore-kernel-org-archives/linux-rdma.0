From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH v2 00/17] IB/mlx: Fine-tuning for several function
 implementations
Date: Sun, 6 Aug 2017 16:00:09 +0200
Message-ID: <617e30ff-2705-b053-ee28-ed9385037580@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <1492720654.3041.16.camel@redhat.com>
 <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> Date: Fri, 21 Apr 2017 19:56:54 +0200
> 
> Several update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (17):
>   Use kcalloc() in mlx4_ib_alloc_pv_bufs()
>   Use kmalloc_array() in six functions
>   Improve size determinations in six functions
>   Fix a typo in a comment line
>   Delete four unnecessary return statements
>   Delete an unnecessary check before kfree() in free_pv_object()
>   Move an assignment out of a check in forward_trap()
>   Enclose 46 expressions for sizeof by parentheses
>   Split a condition check in six functions
>   Delete an unnecessary variable in __mlx4_ib_query_gid()
>   Delete an unnecessary variable initialisation in mlx4_ib_add()
>   Delete an unnecessary variable assignment in mlx4_ib_add()
>   Delete an error message for a failed memory allocation in mlx4_ib_add()
>   Delete unnecessary braces in mlx4_ib_add()
>   Delete unwanted spaces behind usages of the sizeof operator
>   Add spaces for better code readability
>   Less function calls in create_kernel_qp() after error detection
> ---
> 
> v2:
> Changes were rebased on source files from Linux next-20170421.
> Some of them were recombined as requested by Doug Ledford.
> 
>  drivers/infiniband/hw/mlx4/mad.c  |  72 ++++++++--------
>  drivers/infiniband/hw/mlx4/main.c | 164 ++++++++++++++++++++----------------
>  drivers/infiniband/hw/mlx4/qp.c   | 173 +++++++++++++++++++-------------------
>  drivers/infiniband/hw/mlx5/qp.c   |  66 ++++++++++-----
>  drivers/infiniband/hw/mlx5/srq.c  |   5 +-
>  5 files changed, 261 insertions(+), 219 deletions(-)

Will the clarification be continued for the shown change possibilities?

Regards,
Markus
