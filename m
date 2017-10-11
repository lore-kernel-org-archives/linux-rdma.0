From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next] IB,hfi1 Add MODULE_FIRMWARE statements
Date: Wed, 11 Oct 2017 11:32:50 -0400
Message-ID: <f24cdc10-1140-037c-b2e6-fd837fd54e4e@intel.com>
References: <20171011144134.c6bba480faee444cb9881710@suse.de>
 <1d7e8d05-9a6b-6dbf-d528-41ba64129348@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1d7e8d05-9a6b-6dbf-d528-41ba64129348-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/11/2017 11:31 AM, Dennis Dalessandro wrote:
> On 10/11/2017 8:41 AM, Thomas Bogendoerfer wrote:
>> Provide information about used firmware files via modinfo.
>>
>> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/hfi1/firmware.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/hfi1/firmware.c 
>> b/drivers/infiniband/hw/hfi1/firmware.c
>> index dee3c674f33d..f56ace76b42c 100644
>> --- a/drivers/infiniband/hw/hfi1/firmware.c
>> +++ b/drivers/infiniband/hw/hfi1/firmware.c
>> @@ -70,6 +70,11 @@
>>   #define ALT_FW_PCIE_NAME "hfi1_pcie_d.fw"
>>   #define HOST_INTERFACE_VERSION 1
>> +MODULE_FIRMWARE(DEFAULT_FW_8051_NAME_ASIC);
>> +MODULE_FIRMWARE(DEFAULT_FW_FABRIC_NAME);
>> +MODULE_FIRMWARE(DEFAULT_FW_SBUS_NAME);
>> +MODULE_FIRMWARE(DEFAULT_FW_PCIE_NAME);
>> +
>>   static uint fw_8051_load = 1;
>>   static uint fw_fabric_serdes_load = 1;
>>   static uint fw_pcie_serdes_load = 1;
>>
> 
> I don't find this terribly useful, but if it's useful for you I'm sure 
> it is for others as well, so I have no problem with it.
> 
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Although you may want to change the subject from IB,hfi1 to IB/hfi1.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
