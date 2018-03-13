From: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Date: Tue, 13 Mar 2018 15:53:18 -0400
Message-ID: <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <52cbbbc4-c488-f83f-8d02-14d455b4efd7@codeaurora.org>
 <3e738f95-d73c-4182-2fa1-8664aafb1ab7@deltatee.com>
 <703aa92c-0c1c-4852-5887-6f6e6ccde0fb@codeaurora.org>
 <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <a0af83f8-2cbc-862b-6f8b-231991527cfc-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/13/2018 3:19 PM, Logan Gunthorpe wrote:
> 
> 
> On 13/03/18 01:10 PM, Sinan Kaya wrote:
>> I was thinking of this for the pci_p2pdma_add_client() case for the
>> parent pointer.
>>
>> +struct pci_p2pdma_client {
>> +	struct list_head list;
>> +	struct pci_dev *client;
>> +	struct pci_dev *provider;
>> +};
> 
> Yeah, that structure only exists in a list owned by the client and we
> only check the upstream bridge once per entry so I don't see the point.
> 
>> But then, Why bother searching for the switch at all?
> 
> Huh? We have to make sure all the client and provider devices are behind
> the same switch. How can we do that without "searching" for the switch?
> 

Sorry, I was thinking of ACS case you described below. The only thing code
cares is if the device is behind a switch or not at this moment.

> In the ACS case, we only disable ACS on downstream ports of switches. No
> sense disabling it globally as that's worse from an isolation point of
> view and not worth it given we require all P2P transactions to be behind
> a switch.

I agree disabling globally would be bad. Somebody can always say I have
ten switches on my system. I want to do peer-to-peer on one switch only. Now,
this change weakened security for the other switches that I had no intention
with doing P2P.

Isn't this a problem?

Can we specify the BDF of the downstream device we want P2P with during boot via
kernel command line?

> 
>> Even if the switch is there, there is no guarantee that it is currently
>> being used for P2P.
> 
> IOMMU groups are set at boot time and, at present, there's no way to
> dynamically change ACS bits without messing up the groups. So switches
> not used for P2P will not have ACS enabled when CONFIG_PCI_P2PDMA is set
> and I don't know of any good solution to that. Please see the ACS
> discussions in v1 and v2.

Given the implementation limitations, this might be OK as a short-term
solution. 

It depends on if Alex is comfortable with this.

> 
>> It seems that we are going with the assumption that enabling this config
>> option implies you want P2P, then we can simplify this code as well.
> 
> How so?
> 
> Logan
> 
> 
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
