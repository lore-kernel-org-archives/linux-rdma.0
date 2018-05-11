From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Date: Fri, 11 May 2018 10:52:49 +0200
Message-ID: <cf2b92c9-7c5b-f19c-b5b1-2f2d435296d1@amd.com>
References: <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
 <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
 <4e0d0b96-ab02-2662-adf3-fa956efd294c@deltatee.com>
 <2fc61d29-9eb4-d168-a3e5-955c36e5d821@amd.com>
 <94C8FE12-7FC3-48BD-9DCA-E6A427E71810@raithlin.com>
 <f0101988-cf82-7ffb-2aca-d3b8d2f4b504@deltatee.com>
 <868B49CE-4F0E-4A48-BE78-12149F85F1A4@raithlin.com>
 <8113cba8-62b9-1801-7a77-f82be223b183@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <8113cba8-62b9-1801-7a77-f82be223b183-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am 10.05.2018 um 19:15 schrieb Logan Gunthorpe:
>
> On 10/05/18 11:11 AM, Stephen  Bates wrote:
>>> Not to me. In the p2pdma code we specifically program DMA engines with
>>> the PCI bus address.
>> Ah yes of course. Brain fart on my part. We are not programming the P2PDMA initiator with an IOVA but with the PCI bus address...

By disabling the ACS bits on the intermediate bridges you turn their 
address routing from IOVA addresses (which are to be resolved by the 
root complex) back to PCI bus addresses (which are resolved locally in 
the bridge).

This only works when the IOVA and the PCI bus addresses never overlap. 
I'm not sure how the IOVA allocation works but I don't think we 
guarantee that on Linux.

>>
>>> So regardless of whether we are using the IOMMU or
>>> not, the packets will be forwarded directly to the peer. If the ACS
>>>   Redir bits are on they will be forced back to the RC by the switch and
>>>   the transaction will fail. If we clear the ACS bits, the TLPs will go
>>>   where we want and everything will work (but we lose the isolation of ACS).
>> Agreed.

If we really want to enable P2P without ATS and IOMMU enabled I think we 
should probably approach it like this:

a) Make double sure that IOVA in an IOMMU group never overlap with PCI 
BARs in that group.

b) Add configuration options to put a whole PCI branch of devices (e.g. 
a bridge) into a single IOMMU group.

c) Add a configuration option to disable the ACS bit on bridges in the 
same IOMMU group.


I agree that we have a rather special case here, but I still find that 
approach rather brave and would vote for disabling P2P without ATS when 
IOMMU is enabled.


BTW: I can't say anything about other implementations, but at least for 
the AMD-IOMMU the transaction won't fail when it is send to the root 
complex.

Instead the root complex would send it to the correct device. I already 
tested that on an AMD Ryzen with IOMMU enabled and P2P between two GPUs 
(but could be that this only works because of ATS).

Regards,
Christian.

>>>     For EPs that support ATS, we should (but don't necessarily have to)
>>>     program them with the IOVA address so they can go through the
>>>     translation process which will allow P2P without disabling the ACS Redir
>>>     bits -- provided the ACS direct translation bit is set. (And btw, if it
>>>     is, then we lose the benefit of ACS protecting against malicious EPs).
>>>     But, per above, the ATS transaction should involve only the IOVA address
>>>     so the ACS bits not being set should not break ATS.
>>      
>> Well we would still have to clear some ACS bits but now we can clear only for translated addresses.
> We don't have to clear the ACS Redir bits as we did in the first case.
> We just have to make sure the ACS Direct Translated bit is set.
>
> Logan
