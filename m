From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 03/10] verbs: Split init_device into a match and
 alloc/bind step
Date: Wed, 27 Sep 2017 16:49:19 +0300
Message-ID: <fbe7fac9-0ab2-1ccc-f5fe-03e434cef280@dev.mellanox.co.il>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <5a30e4a3-e22c-5d1a-435d-d3c5d94333fd@dev.mellanox.co.il>
 <20170927075552.GC2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170927075552.GC2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/27/2017 10:55 AM, Leon Romanovsky wrote:
> On Tue, Sep 26, 2017 at 07:00:16PM +0300, Yishai Hadas wrote:
>> On 9/20/2017 12:18 AM, Jason Gunthorpe wrote:
>>> The match step determines if the provider should bind to the sysfs device,
>>> and the allocation step creates the verbs_device and cleanly matches the
>>> uninit_device step which frees it.
>>>
>>> This split makes it simpler to factor out all the duplicated code in the
>>> match step.
>>>
>>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>> ---
>>>    libibverbs/driver.h | 21 ++++++++++++++-
>>>    libibverbs/init.c   | 74 ++++++++++++++++++++++++++++++++++-------------------
>>>    2 files changed, 68 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/libibverbs/driver.h b/libibverbs/driver.h
>>> index f9f5cfa2308c2f..397441f49a0e5a 100644
>>> --- a/libibverbs/driver.h
>>> +++ b/libibverbs/driver.h
>>> @@ -40,6 +40,7 @@
>>>    #include <infiniband/kern-abi.h>
>>>    #include <ccan/list.h>
>>>    #include <config.h>
>>> +#include <stdbool.h>
>>>    #ifdef __cplusplus
>>>    #  define BEGIN_C_DECLS extern "C" {
>>> @@ -95,10 +96,27 @@ struct verbs_qp {
>>>    	struct verbs_xrcd       *xrcd;
>>>    };
>>> +/* A rdma device detected in sysfs */
>>> +struct verbs_sysfs_dev {
>>> +	struct list_node entry;
>>> +	void *provider_data;
>>
>> It looks as this field isn't used in the series, correct ? if this is the
>> case better add when it'll become applicable.
> 
> Yishai,
> 
> Jason is a little bit overwhelmed now and because this series was posted
> long time here and got a lot of Acked-by tags, I would be happy to take it
> and move forward. Do you see any issues which he can't fix after this
> series merged?
> 

The above is some cleanup note that can be done later if we want to 
merge the series soon.

Other verbs changes in the series looks fine to me.
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
