From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [Outreachy kernel] [PATCH] infiniband: hw: Drop unnecessary
 continue
Date: Sat, 3 Mar 2018 10:34:29 -0500
Message-ID: <2032604b-b25b-e5bf-bea5-3c43a50b8ff7@intel.com>
References: <20180303130336.GA8210@seema-Inspiron-15-3567>
 <alpine.DEB.2.20.1803031506550.2302@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1803031506550.2302@hadrien>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>, Arushi Singhal <arushisinghal19971997@gmail.com>
Cc: mike.marciniszyn@intel.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On 3/3/2018 9:07 AM, Julia Lawall wrote:
>> diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
>> index 3990f38..1bd3b32 100644
>> --- a/drivers/infiniband/hw/qib/qib_init.c
>> +++ b/drivers/infiniband/hw/qib/qib_init.c
>> @@ -681,7 +681,6 @@ int qib_init(struct qib_devdata *dd, int reinit)
>>   		if (lastfail) {
>>   			qib_dev_err(dd,
>>   				"failed to allocate kernel ctxt's rcvhdrq and/or egr bufs\n");
>> -			continue;
>>   		}
> 
> Again, the braces should be dropped too.

Thanks Julia, I just noticed the same thing! :)

-Denny
