From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hns: Explicitly include linux/interrupt.h
Date: Tue, 22 Aug 2017 10:21:45 +0800
Message-ID: <599B9539.5040004@huawei.com>
References: <20170728105112.7577-1-broonie@kernel.org>
 <1501529069.2725.5.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501529069.2725.5.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, Doug & Mark Brown & Arnd Bergmann
   Thanks for your patches!

   @Doug, Which branch can we found this patch? Thanks
   Regards
Wei Hu

On 2017/8/1 3:24, Doug Ledford wrote:
> On Fri, 2017-07-28 at 11:51 +0100, Mark Brown wrote:
>> This file uses interrupt APIs but doesn't explicitly include
>> linux/interrupt.h meaning that changes in other header files could
>> cause
>> build breakage as happened in next-20170728 for arm64.  Add an
>> explicit
>> include to avoid such problems.
>>
>> Signed-off-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/hns/hns_roce_eq.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_eq.c
>> b/drivers/infiniband/hw/hns/hns_roce_eq.c
>> index 50f864935a0e..e1e4c16ca3d5 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_eq.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_eq.c
>> @@ -30,6 +30,7 @@
>>    * SOFTWARE.
>>    */
>>   
>> +#include <linux/interrupt.h>
>>   #include <linux/platform_device.h>
>>   #include "hns_roce_common.h"
>>   #include "hns_roce_device.h"
> Hi Mark,
>
> Your patch is fine, but I grabbed the one from Arnd before I grabbed
> this one.  That was an accident on my part (yours was sent to the list
> first and I normally would have grabbed it), my apologies for that.  I
> knew I had seen a patch come through and I scrolled back until I found
> it without realizing there were two.
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
