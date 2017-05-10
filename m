From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: change PCI bar addr assignments to Linux API
 functions
Date: Wed, 10 May 2017 15:16:09 -0400
Message-ID: <713997af-caff-a12b-38c5-295f763198b1@intel.com>
References: <1494442093-3590-1-git-send-email-robers97@gmail.com>
 <20170510185238.GA25924@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170510185238.GA25924-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/10/2017 2:52 PM, Christoph Hellwig wrote:
> On Wed, May 10, 2017 at 01:48:13PM -0500, Steven L. Roberts wrote:
>> From: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> The Ominpath adapter driver fails to load the ppc64le platform
>> due to invalid PCI setup.
>>
>> This patch makes the PCI configuration more robust and will
>> fixes 64 bit addressing for ppc64le.
>>
>> Signed-off-by: Steven L Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/hfi1/pcie.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
>> index 93faf86..6a9f6f9 100644
>> --- a/drivers/infiniband/hw/hfi1/pcie.c
>> +++ b/drivers/infiniband/hw/hfi1/pcie.c
>> @@ -207,8 +207,8 @@ int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev)
>>  	/*
>>  	 * Save BARs and command to rewrite after device reset.
>>  	 */
>> -	dd->pcibar0 = addr;
>> -	dd->pcibar1 = addr >> 32;
>> +	pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0, &dd->pcibar0);
>> +	pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1, &dd->pcibar1);
>
> Why do you even read / re-write them?  Thjis isn't the drivers job.

We save them off so we can restore after a reset wipes them out. See 
restore_pci_variables().

The restore function already uses the PCI_BASE_ADDRESS_* values so the 
only change was needed here.

-Denny


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
