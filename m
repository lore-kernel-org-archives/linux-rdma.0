From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH] infiniband: hw: Drop unnecessary continue
Date: Sat, 3 Mar 2018 10:32:52 -0500
Message-ID: <8758a94b-ca48-7b82-6192-fd7ad6a515e4@intel.com>
References: <20180303130336.GA8210@seema-Inspiron-15-3567>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180303130336.GA8210@seema-Inspiron-15-3567>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arushi Singhal <arushisinghal19971997@gmail.com>
Cc: mike.marciniszyn@intel.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On 3/3/2018 8:03 AM, Arushi Singhal wrote:
> Continue at the bottom of a loop are removed.
> Issue found using drop_continue.cocci Coccinelle script.
> 
> Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
> ---
>   drivers/infiniband/hw/qib/qib_init.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
> index 3990f38..1bd3b32 100644
> --- a/drivers/infiniband/hw/qib/qib_init.c
> +++ b/drivers/infiniband/hw/qib/qib_init.c
> @@ -681,7 +681,6 @@ int qib_init(struct qib_devdata *dd, int reinit)
>   		if (lastfail) {
>   			qib_dev_err(dd,
>   				"failed to allocate kernel ctxt's rcvhdrq and/or egr bufs\n");
> -			continue;
>   		}
>   	}
>   
> 

Please run checkpatch before posting patches. This will fail as you left 
braces around a single line.

-Denny
