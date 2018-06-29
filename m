From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH] IB/srpt: Support HCAs with more than two ports
Date: Fri, 29 Jun 2018 09:32:42 -0700
Message-ID: <82918f75-5624-acf5-9495-1fd76c4318d6@wdc.com>
References: <20180626222448.11411-1-bart.vanassche@wdc.com>
 <20180629162059.GA21030@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180629162059.GA21030@ziepe.ca>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Christoph Hellwig <hch@infradead.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 06/29/18 09:21, Jason Gunthorpe wrote:
> On Tue, Jun 26, 2018 at 03:24:48PM -0700, Bart Van Assche wrote:
>> Since there are adapters that have four ports, increase the size of
>> the srpt_device.port[] array. This patch avoids that the following
>> warning is hit with quad port Chelsio adapters:
>>
>>      WARN_ON(sdev->device->phys_port_cnt > ARRAY_SIZE(sdev->port));
>>
>> Reported-by: Steve Wise <swise@opengridcomputing.com>
>> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
>> Cc: Steve Wise <swise@opengridcomputing.com>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: <stable@vger.kernel.org>
>> ---
>>   drivers/infiniband/ulp/srpt/ib_srpt.c | 6 +++---
>>   drivers/infiniband/ulp/srpt/ib_srpt.h | 2 +-
>>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> Can we write it this way instead? More typesafe.

Hello Jason,

The patch you posted looks fine to me. Do you want me to add your 
Signed-off-by after I have retested this patch when I repost it?

Thanks,

Bart.
