From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-next 0/4] IB/hfi1: Couple more for the RC cycle
Date: Thu, 20 Sep 2018 15:52:54 -0400
Message-ID: <d8b1bad2-1df7-3527-7388-d39169047fbc@intel.com>
References: <20180920193538.7072.71796.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180920193538.7072.71796.stgit@scvm10.sc.intel.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, "Odzioba, Lukasz" <lukasz.odzioba@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

On 9/20/2018 3:44 PM, Dennis Dalessandro wrote:
> Hi Doug and Jason,
> 
> Mike and Ira have identified some fixes that they would like to see land in the
> RC, these are serious problems and are marked as stable.
> 
> ---
> 
> Ira Weiny (1):
>        IB/hfi1: Fix SL array bounds check
> 
> Michael J. Ruhl (3):
>        IB/hfi1: Invalid user input can result in crash
>        IB/hfi1: Fix context recovery when PBC has an UnsupportedVL
>        IB/hfi1: Fix destroy_qp hang after a link down
> 
> 
>   drivers/infiniband/hw/hfi1/chip.c      |    6 +++-
>   drivers/infiniband/hw/hfi1/pio.c       |   51 ++++++++++++++++++++++++++------
>   drivers/infiniband/hw/hfi1/pio.h       |    2 +
>   drivers/infiniband/hw/hfi1/user_sdma.c |    2 +
>   drivers/infiniband/hw/hfi1/verbs.c     |    8 ++++-
>   5 files changed, 56 insertions(+), 13 deletions(-)
> 
> --
> -Denny
> 

Please ignore this. It should say for-rc not for-next and Lukasz email 
is bouncing, let me look into fixing that and I'll send a v2.

-Denny
