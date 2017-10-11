From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-next] IB,hfi1 Add MODULE_FIRMWARE statements
Date: Wed, 11 Oct 2017 13:13:26 -0400
Message-ID: <3e374d9f-d63d-8601-b594-a9c2a426833e@intel.com>
References: <20171011144134.c6bba480faee444cb9881710@suse.de>
 <1d7e8d05-9a6b-6dbf-d528-41ba64129348@intel.com>
 <20171011154914.GL2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171011154914.GL2106@mtr-leonro.local>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 10/11/2017 11:49 AM, Leon Romanovsky wrote:
> On Wed, Oct 11, 2017 at 11:31:18AM -0400, Dennis Dalessandro wrote:
>> On 10/11/2017 8:41 AM, Thomas Bogendoerfer wrote:
>>> Provide information about used firmware files via modinfo.
>>>
>>> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
>>> ---
>>>    drivers/infiniband/hw/hfi1/firmware.c | 5 +++++
>>>    1 file changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
>>> index dee3c674f33d..f56ace76b42c 100644
>>> --- a/drivers/infiniband/hw/hfi1/firmware.c
>>> +++ b/drivers/infiniband/hw/hfi1/firmware.c
>>> @@ -70,6 +70,11 @@
>>>    #define ALT_FW_PCIE_NAME "hfi1_pcie_d.fw"
>>>    #define HOST_INTERFACE_VERSION 1
>>> +MODULE_FIRMWARE(DEFAULT_FW_8051_NAME_ASIC);
>>> +MODULE_FIRMWARE(DEFAULT_FW_FABRIC_NAME);
>>> +MODULE_FIRMWARE(DEFAULT_FW_SBUS_NAME);
>>> +MODULE_FIRMWARE(DEFAULT_FW_PCIE_NAME);
>>> +
>>>    static uint fw_8051_load = 1;
>>>    static uint fw_fabric_serdes_load = 1;
>>>    static uint fw_pcie_serdes_load = 1;
>>>
>>
>> I don't find this terribly useful, but if it's useful for you I'm sure it is
>> for others as well, so I have no problem with it.
> 
> Dennis,
> Aren't those defines being constant?
> 
>>
>> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

Which is why I didn't find it very useful. However Thomas makes a good 
point [1].

https://marc.info/?l=linux-rdma&m=150773727811239&w=2

-Denny
