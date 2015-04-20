From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v5 19/27] IB/Verbs: Use management helper cap_iw_cm()
Date: Mon, 20 Apr 2015 17:16:08 +0200
Message-ID: <55351838.2060006@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <5534BB7B.4020601@profitbricks.com> <55350698.9000109@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55350698.9000109@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il
Cc: Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On 04/20/2015 04:00 PM, Steve Wise wrote:
> On 4/20/2015 3:40 AM, Michael Wang wrote:
[snip]
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 6805e3e..e4999f6 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -1818,6 +1818,21 @@ static inline int cap_ib_cm(struct ib_device *device, u8 port_num)
>>       return rdma_ib_or_iboe(device, port_num);
>>   }
>>   +/**
>> + * cap_iw_cm - Check if the port of device has the capability IWARP
>> + * Communication Manager.
>> + *
>> + * @device: Device to be checked
>> + * @port_num: Port number of the device
>> + *
>> + * Return 0 when port of the device don't support IWARP
>> + * Communication Manager.
>> + */
>> +static inline int cap_iw_cm(struct ib_device *device, u8 port_num)
>> +{
>> +    return rdma_tech_iwarp(device, port_num);
>> +}
>> +
>>   int ib_query_gid(struct ib_device *device,
>>            u8 port_num, int index, union ib_gid *gid);
>>   
> 
> iWARP devices _must_ support the IWCM so cap_iw_cm() is not really useful.

Sean suggested to add this helper paired with cap_ib_cm(), may be there are
some consideration on maintainability?

Me too also prefer this way to make the code more readable ;-)

Regards,
Michael Wang

> 
> 
