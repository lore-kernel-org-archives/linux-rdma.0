From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-rc 0/3]
Date: Wed, 20 Jun 2018 12:33:15 -0400
Message-ID: <0a8032b0-6645-062e-2ee7-5071748c2a46@intel.com>
References: <20180620162612.13582.28777.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180620162612.13582.28777.stgit@scvm10.sc.intel.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>
List-Id: linux-rdma@vger.kernel.org

Doh! Sorry about that, forgot to type an actual subject. Don't think it 
merits a re-send of the series though.

-Denny

On 6/20/2018 12:28 PM, Dennis Dalessandro wrote:
> Hi Doug and Jason,
> 
> Here are a couple patches that we'd like to get into 4.18 rc cycle. These fix
> bugs and aren't too complex. One of them is an issue that Dan Carpenter just
> reported recently and is marked for stable.
> 
> ---
> 
> Michael J. Ruhl (3):
>        IB/hfi1: Set in_use_ctxts bits for user ctxts only
>        IB/hfi1: Remove incorrect call to do_interrupt callback
>        IB/hfi1: Fix incorrect mixing of ERR_PTR and NULL return values
> 
> 
>   drivers/infiniband/hw/hfi1/chip.c        |   30 +++++++++++++++++-------------
>   drivers/infiniband/hw/hfi1/file_ops.c    |    4 ++++
>   drivers/infiniband/hw/hfi1/init.c        |    1 -
>   drivers/infiniband/hw/hfi1/rc.c          |    2 +-
>   drivers/infiniband/hw/hfi1/uc.c          |    4 ++--
>   drivers/infiniband/hw/hfi1/ud.c          |    4 ++--
>   drivers/infiniband/hw/hfi1/verbs_txreq.c |    4 ++--
>   drivers/infiniband/hw/hfi1/verbs_txreq.h |    4 ++--
>   8 files changed, 30 insertions(+), 23 deletions(-)
> 
> --
> -Denny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
