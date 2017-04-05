From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 00/14] RDMA/cxgb: Fine-tuning for several function
 implementations
Date: Wed, 05 Apr 2017 14:16:14 -0400
Message-ID: <1491416174.2923.3.camel@redhat.com>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Steve Wise <swise@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-02-08 at 22:10 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Feb 2017 22:00:10 +0100
> 
> Several update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (14):
>   Use kcalloc() in cxio_create_qp()
>   Rename jump labels in cxio_create_qp()
>   Use kcalloc() in two functions
>   Use common error handling code in recover_queues()
>   Return an error code only as a constant in ep_open()
>   Return an error code only as a constant in stag_open()
>   Adjust three checks for null pointers
>   Adjust construction of two error messages in recover_lost_dbs()
>   Use common error handling code in recover_lost_dbs()
>   Use kmalloc_array() in c4iw_id_table_alloc()
>   Use kcalloc() in create_qp()
>   Delete an unnecessary variable initialisation in create_qp()
>   Rename jump labels in c4iw_create_qp()
>   Rename jump labels in rdma_init()
> 
>  drivers/infiniband/hw/cxgb3/cxio_hal.c | 20 ++++----
>  drivers/infiniband/hw/cxgb4/device.c   | 83 +++++++++++++++---------
> ----------
>  drivers/infiniband/hw/cxgb4/id_table.c |  5 +-
>  drivers/infiniband/hw/cxgb4/qp.c       | 48 ++++++++++----------
>  4 files changed, 75 insertions(+), 81 deletions(-)

I didn't see enough value in this series to bother picking it up.
 Steve, if there are any patches out of this series you actually want,
please collect them and forward them on to me.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
