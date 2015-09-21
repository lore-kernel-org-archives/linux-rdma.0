From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/4] IB/iser: Add module parameter for always
 register memory
Date: Mon, 21 Sep 2015 19:42:56 +0300
Message-ID: <56003390.60002@dev.mellanox.co.il>
References: <1442742767-8755-1-git-send-email-sagig@mellanox.com>
 <1442742767-8755-3-git-send-email-sagig@mellanox.com>
 <20150921163922.GC3993@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150921163922.GC3993-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/21/2015 7:39 PM, Jason Gunthorpe wrote:
> On Sun, Sep 20, 2015 at 12:52:45PM +0300, Sagi Grimberg wrote:
>> This module parameter forces memory registration even for
>> a continuous memory region. It is true by default as sending
>> an all-physical rkey with remote permissions might be insecure.
>>
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>   drivers/infiniband/ulp/iser/iscsi_iser.c  |  5 +++++
>>   drivers/infiniband/ulp/iser/iscsi_iser.h  |  1 +
>>   drivers/infiniband/ulp/iser/iser_memory.c | 18 ++++++++++++------
>>   drivers/infiniband/ulp/iser/iser_verbs.c  | 21 +++++++++++++--------
>>   4 files changed, 31 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
>> index 1ace5d83a4d7..bad9dd701d3c 100644
>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
>> @@ -97,6 +97,11 @@ unsigned int iser_max_sectors = ISER_DEF_MAX_SECTORS;
>>   module_param_named(max_sectors, iser_max_sectors, uint, S_IRUGO | S_IWUSR);
>>   MODULE_PARM_DESC(max_sectors, "Max number of sectors in a single scsi command (default:1024");
>>
>> +bool iser_always_reg = true;
>> +module_param_named(always_register, iser_always_reg, bool, S_IRUGO);
>> +MODULE_PARM_DESC(always_register,
>> +		 "Always register memory, even for continuous memory regions (default:false)");
>                                                                               ^^^^^^^^^^^^^^^
> Description doesn't match implementation?

Yea... I noticed that too...

v1 is already on the list.

Thanks for commenting.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
