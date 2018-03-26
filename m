From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH v2 iproute2-next 3/6] rdma: Add CM_ID resource tracking
 information
Date: Mon, 26 Mar 2018 10:24:25 -0500
Message-ID: <09f5080f-04d2-3b5e-74fd-7aba85516097@opengridcomputing.com>
References: <cover.1520020530.git.swise@opengridcomputing.com>
 <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
 <f6dd4255-69b2-bb90-de92-bb633f7248ef@gmail.com>
 <0443b8e0-17ff-1e62-51ba-ba1fa0e0d529@opengridcomputing.com>
 <8d788e10-c170-9b94-09f0-98515fdd5bac@gmail.com>
 <783e600a-9296-8ea0-003e-59e48fd5234b@opengridcomputing.com>
 <20180326150826.GH1877@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326150826.GH1877@mtr-leonro.local>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 3/26/2018 10:08 AM, Leon Romanovsky wrote:
> On Mon, Mar 26, 2018 at 09:55:46AM -0500, Steve Wise wrote:
>>
>> On 3/26/2018 9:44 AM, David Ahern wrote:
>>> On 3/26/18 8:30 AM, Steve Wise wrote:
>>>> On 3/26/2018 9:17 AM, David Ahern wrote:
>>>>> On 2/27/18 9:07 AM, Steve Wise wrote:
>>>>>> diff --git a/rdma/rdma.h b/rdma/rdma.h
>>>>>> index 5809f70..e55205b 100644
>>>>>> --- a/rdma/rdma.h
>>>>>> +++ b/rdma/rdma.h
>>>>>> @@ -18,10 +18,12 @@
>>>>>>  #include <libmnl/libmnl.h>
>>>>>>  #include <rdma/rdma_netlink.h>
>>>>>>  #include <time.h>
>>>>>> +#include <net/if_arp.h>
>>>>>>
>>>>>>  #include "list.h"
>>>>>>  #include "utils.h"
>>>>>>  #include "json_writer.h"
>>>>>> +#include <rdma/rdma_cma.h>
>>>>>>
>>>>> did you forget to add rdma_cma.h? I don't see that file in my repo.
>>>> It is provided by the rdma-core package, upon which rdma tool now
>>>> depends for the rdma_port_space enum.
>>>>
>>> You need to add a check for the package, and only build rdma if that
>>> package is installed. See check_mnl in configure for an example.
>> Ok, that makes sense.
> IMHO, better solution will be to copy those files to iproute2.

Hey Leon,

Why is it better in your opinion?  My gut tells me adding rdma_cma.h to
iproute2 means more uabi type syncing.
