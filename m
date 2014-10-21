From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH trivial] IB/srp: Allow newline separator for connection
 string
Date: Tue, 21 Oct 2014 14:01:13 +0300
Message-ID: <54463CF9.6070706@dev.mellanox.co.il>
References: <1413731942-3317-1-git-send-email-sagig@mellanox.com> <54452561.1050508@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54452561.1050508-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/20/2014 6:08 PM, Bart Van Assche wrote:
> On 10/19/14 17:19, Sagi Grimberg wrote:
>> In case last argument of the connection string is
>> processed as a string (destination gid for example).
>>
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
>> b/drivers/infiniband/ulp/srp/ib_srp.c
>> index 62d2a18..5f590cf 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -2760,7 +2760,7 @@ static int srp_parse_options(const char *buf,
>> struct srp_target_port *target)
>>           return -ENOMEM;
>>
>>       sep_opt = options;
>> -    while ((p = strsep(&sep_opt, ",")) != NULL) {
>> +    while ((p = strsep(&sep_opt, ",\n")) != NULL) {
>>           if (!*p)
>>               continue;
>
> Hello Sagi,
>
> It has already happened that users were confused by a write into the
> "add_target" sysfs attribute that failed because of a newline not being
> accepted as a separator. This patch will avoid such confusion so I think
> it's an improvement. Hence,
>

I would consider it a minor bug fix (and CC it to stable).

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
