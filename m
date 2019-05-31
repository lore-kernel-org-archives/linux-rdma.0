From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH, RESEND] RDMA/srp: Accept again source addresses that do
 not have a port number
Date: Fri, 31 May 2019 12:33:12 -0700
Message-ID: <aa530e2d-a968-4532-cdaa-a6cbf722f19e@acm.org>
References: <20190529163831.138926-1-bvanassche@acm.org>
 <20190530184437.GA29836@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190530184437.GA29836@ziepe.ca>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/30/19 11:44 AM, Jason Gunthorpe wrote:
> On Wed, May 29, 2019 at 09:38:31AM -0700, Bart Van Assche wrote:
>> The function srp_parse_in() is used both for parsing source address
>> specifications and for target address specifications. Target addresses
>> must have a port number. Having to specify a port number for source
>> addresses is inconvenient. Make sure that srp_parse_in() supports again
>> parsing addresses with no port number.
>>
>> Cc: Laurence Oberman <loberman@redhat.com>
>> Cc: <stable@vger.kernel.org>
>> Fixes: c62adb7def71 ("IB/srp: Fix IPv6 address parsing") # v4.17.
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c | 21 +++++++++++++++------
>>   1 file changed, 15 insertions(+), 6 deletions(-)
> 
> Bart, do you want this applied now, or are we still waiting for
> Laurence?

Hi Jason,

Since Laurence has not replied to your e-mail please go ahead and apply 
this patch.

Thanks,

Bart.
