From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH v2 iproute2-next 3/6] rdma: Add CM_ID resource tracking
 information
Date: Mon, 26 Mar 2018 09:55:46 -0500
Message-ID: <783e600a-9296-8ea0-003e-59e48fd5234b@opengridcomputing.com>
References: <cover.1520020530.git.swise@opengridcomputing.com>
 <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
 <f6dd4255-69b2-bb90-de92-bb633f7248ef@gmail.com>
 <0443b8e0-17ff-1e62-51ba-ba1fa0e0d529@opengridcomputing.com>
 <8d788e10-c170-9b94-09f0-98515fdd5bac@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <8d788e10-c170-9b94-09f0-98515fdd5bac@gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 3/26/2018 9:44 AM, David Ahern wrote:
> On 3/26/18 8:30 AM, Steve Wise wrote:
>>
>> On 3/26/2018 9:17 AM, David Ahern wrote:
>>> On 2/27/18 9:07 AM, Steve Wise wrote:
>>>> diff --git a/rdma/rdma.h b/rdma/rdma.h
>>>> index 5809f70..e55205b 100644
>>>> --- a/rdma/rdma.h
>>>> +++ b/rdma/rdma.h
>>>> @@ -18,10 +18,12 @@
>>>>  #include <libmnl/libmnl.h>
>>>>  #include <rdma/rdma_netlink.h>
>>>>  #include <time.h>
>>>> +#include <net/if_arp.h>
>>>>  
>>>>  #include "list.h"
>>>>  #include "utils.h"
>>>>  #include "json_writer.h"
>>>> +#include <rdma/rdma_cma.h>
>>>>  
>>> did you forget to add rdma_cma.h? I don't see that file in my repo.
>> It is provided by the rdma-core package, upon which rdma tool now
>> depends for the rdma_port_space enum.
>>
> You need to add a check for the package, and only build rdma if that
> package is installed. See check_mnl in configure for an example.

Ok, that makes sense.

Steve.
