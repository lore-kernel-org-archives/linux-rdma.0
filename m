From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 25/28] IB/Verbs: Use management helper cap_af_ib()
Date: Thu, 16 Apr 2015 10:16:33 -0400
Message-ID: <552FC441.5070500@dev.mellanox.co.il>
References: <552BB470.4090407@profitbricks.com> <552BB801.2010506@profitbricks.com> <CAJ3xEMiEoosZzHhpoJOLdxmdhRrjOfB=HV6bHhus7E=QmHiwPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiEoosZzHhpoJOLdxmdhRrjOfB=HV6bHhus7E=QmHiwPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/16/2015 9:57 AM, Or Gerlitz wrote:
> On Mon, Apr 13, 2015 at 3:35 PM, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
>>
>> Introduce helper cap_af_ib() to help us check if the port of an
>> IB device support Native Infiniband Address.
>>
>> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
>> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> ---
>>  drivers/infiniband/core/cma.c |  2 +-
>>  include/rdma/ib_verbs.h       | 15 +++++++++++++++
>>  2 files changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
>> index 65e41f4..7f5815d 100644
>> --- a/drivers/infiniband/core/cma.c
>> +++ b/drivers/infiniband/core/cma.c
>> @@ -470,7 +470,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
>>
>>         list_for_each_entry(cur_dev, &dev_list, list) {
>>                 for (p = 1; p <= cur_dev->device->phys_port_cnt; ++p) {
>> -                       if (!rdma_ib_or_iboe(cur_dev->device, p))
>> +                       if (!cap_af_ib(cur_dev->device, p))
>>                                 continue;
>>
>>                         if (ib_find_cached_pkey(cur_dev->device, p, pkey, &index))
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 29ddd14..dfe33f3 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -1879,6 +1879,21 @@ static inline int cap_ipoib(struct ib_device *device, u8 port_num)
>>  }
>>
>>  /**
>> + * cap_af_ib - Check if the port of device has the capability
>> + * Native Infiniband Address.
>> + *
>> + * @device: Device to be checked
>> + * @port_num: Port number of the device
>> + *
>> + * Return 0 when port of the device don't support
>> + * Native Infiniband Address.
>> + */
>> +static inline int cap_af_ib(struct ib_device *device, u8 port_num)
>> +{
>> +       return rdma_ib_or_iboe(device, port_num);
>> +}
> 
> Sean, can you please put a precise writeup what does it take to
> support AF_IB... I am a bit
> confused here and wasn't sure if this can be supported with RoCE.

I think this means IB GID addressing is checked (Native Infiniband
Address) and not AF_IB (which is socket address/protocol family like
INET and INET6).

I think this naming is confusing and maybe cap_ib_gid is better ?

-- Hal

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
