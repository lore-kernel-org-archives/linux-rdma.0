From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH] RDMA/cma: Make CM response timeout and # CM retries
 configurable
Date: Fri, 22 Feb 2019 11:14:44 -0600
Message-ID: <afadc799-b547-5c20-64d2-75fa0f64cd9e@opengridcomputing.com>
References: <20190217170909.1178575-1-haakon.bugge@oracle.com>
 <20190222163637.GA9819@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222163637.GA9819@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


On 2/22/2019 10:36 AM, Jason Gunthorpe wrote:
> On Sun, Feb 17, 2019 at 06:09:09PM +0100, Håkon Bugge wrote:
>> During certain workloads, the default CM response timeout is too
>> short, leading to excessive retries. Hence, make it configurable
>> through sysctl. While at it, also make number of CM retries
>> configurable.
>>
>> The defaults are not changed.
>>
>> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
>>  drivers/infiniband/core/cma.c | 51 ++++++++++++++++++++++++++++++-----
>>  1 file changed, 44 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
>> index c43512752b8a..ce99e1cd1029 100644
>> +++ b/drivers/infiniband/core/cma.c
>> @@ -43,6 +43,7 @@
>>  #include <linux/inetdevice.h>
>>  #include <linux/slab.h>
>>  #include <linux/module.h>
>> +#include <linux/sysctl.h>
>>  #include <net/route.h>
>>  
>>  #include <net/net_namespace.h>
>> @@ -68,13 +69,46 @@ MODULE_AUTHOR("Sean Hefty");
>>  MODULE_DESCRIPTION("Generic RDMA CM Agent");
>>  MODULE_LICENSE("Dual BSD/GPL");
>>  
>> -#define CMA_CM_RESPONSE_TIMEOUT 20
>>  #define CMA_QUERY_CLASSPORT_INFO_TIMEOUT 3000
>> -#define CMA_MAX_CM_RETRIES 15
>>  #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
>>  #define CMA_IBOE_PACKET_LIFETIME 18
>>  #define CMA_PREFERRED_ROCE_GID_TYPE IB_GID_TYPE_ROCE_UDP_ENCAP
>>  
>> +#define CMA_DFLT_CM_RESPONSE_TIMEOUT 20
>> +static int cma_cm_response_timeout = CMA_DFLT_CM_RESPONSE_TIMEOUT;
>> +static int cma_cm_response_timeout_min = 8;
>> +static int cma_cm_response_timeout_max = 31;
>> +#undef CMA_DFLT_CM_RESPONSE_TIMEOUT
>> +
>> +#define CMA_DFLT_MAX_CM_RETRIES 15
>> +static int cma_max_cm_retries = CMA_DFLT_MAX_CM_RETRIES;
>> +static int cma_max_cm_retries_min = 1;
>> +static int cma_max_cm_retries_max = 100;
>> +#undef CMA_DFLT_MAX_CM_RETRIES
>> +
>> +static struct ctl_table_header *cma_ctl_table_hdr;
>> +static struct ctl_table cma_ctl_table[] = {
>> +	{
>> +		.procname	= "cma_cm_response_timeout",
>> +		.data		= &cma_cm_response_timeout,
>> +		.maxlen		= sizeof(cma_cm_response_timeout),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec_minmax,
>> +		.extra1		= &cma_cm_response_timeout_min,
>> +		.extra2		= &cma_cm_response_timeout_max,
>> +	},
>> +	{
>> +		.procname	= "cma_max_cm_retries",
>> +		.data		= &cma_max_cm_retries,
>> +		.maxlen		= sizeof(cma_max_cm_retries),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec_minmax,
>> +		.extra1		= &cma_max_cm_retries_min,
>> +		.extra2		= &cma_max_cm_retries_max,
>> +	},
>> +	{ }
>> +};
> Is sysctl the right approach here? Should it be rdma tool instead?
>
> Jason

There are other rdma sysctls currently:  net.rdma_ucm.max_backlog and
net.iw_cm.default_backlog.  The core network stack seems to use sysctl
and not ip tool to set basically globals.

To use rdma tool, we'd have to have some concept of a "module" object, I
guess.  IE there's dev, link, and resource rdma tool objects currently. 
But these cma timeout settings are really not per dev, link, nor a
resource.   Maybe we have just a "core" object:  rdma core set
cma_max_cm_retries min 8 max 30.
