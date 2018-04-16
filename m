From: oulijun <oulijun@huawei.com>
Subject: Re: [PATCH] IB: make INFINIBAND_ADDR_TRANS configurable
Date: Mon, 16 Apr 2018 17:03:29 +0800
Message-ID: <79002036-47dc-9a57-8c00-43a44a6b100a@huawei.com>
References: <20180413070644.11974-1-gthelen@google.com>
 <9ad4563e701a38915d58552f9eee5b3602833ddf.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9ad4563e701a38915d58552f9eee5b3602833ddf.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "gthelen@google.com" <gthelen@google.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "tarick@google.com" <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

在 2018/4/13 20:47, Bart Van Assche 写道:
> On Fri, 2018-04-13 at 00:06 -0700, Greg Thelen wrote:
>> Allow INFINIBAND without INFINIBAND_ADDR_TRANS.
>>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> Cc: Tarick Bedeir <tarick@google.com>
>> ---
>>  drivers/infiniband/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
>> index ee270e065ba9..f20a3977087c 100644
>> --- a/drivers/infiniband/Kconfig
>> +++ b/drivers/infiniband/Kconfig
>> @@ -61,7 +61,7 @@ config INFINIBAND_ON_DEMAND_PAGING
>>  	  pages on demand instead.
>>  
>>  config INFINIBAND_ADDR_TRANS
>> -	bool
>> +	bool "InfiniBand address translation"
>>  	depends on INFINIBAND
>>  	default y
> 
> Hello Greg,
> 
> Please change the short description from "InfiniBand address translation" (which
> is a misleading description) into "RDMA/CM". Please also add a help text that
> explains to people who are not RDMA experts what the RDMA/CM is.
> 
> Thanks,
> 
> Bart.
> 
Hi, Bart
  We need to select the INFINIBAND without INFINIBAND_ADDR_TRANS if use cm for others?

Thanks
Lijun Ou
> 
> 
> �{.n�+�������+%��lzwm��b�맲��r��zX��ݙ�����ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z�
�w���?����&�)ߢf
> 
