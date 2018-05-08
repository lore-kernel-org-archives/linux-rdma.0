From: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Date: Tue, 8 May 2018 18:21:15 -0400
Message-ID: <11819753-af26-4632-8580-d4a47127a3b2@redhat.com>
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508144341.0441b676@w520.home>
 <a524127a-3557-3dff-971c-dfe94ba5a01c@deltatee.com>
 <20180508152631.50fd583c@w520.home>
 <354F7407-0DC7-470C-B9AA-74FDF9C46B08@raithlin.com>
 <20180508160336.0935ddde@w520.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180508160336.0935ddde-DGNDKt5SQtizQB+pC5nmwQ@public.gmane.org>
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
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/08/2018 06:03 PM, Alex Williamson wrote:
> On Tue, 8 May 2018 21:42:27 +0000
> "Stephen  Bates" <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org> wrote:
> 
>> Hi Alex
>>
>>>     But it would be a much easier proposal to disable ACS when the
>>> IOMMU is not enabled, ACS has no real purpose in that case.
>>
>> I guess one issue I have with this is that it disables IOMMU groups
>> for all Root Ports and not just the one(s) we wish to do p2pdma on.
> 
> But as I understand this series, we're not really targeting specific
> sets of devices either.  It's more of a shotgun approach that we
> disable ACS on downstream switch ports and hope that we get the right
> set of devices, but with the indecisiveness that we might later
> white-list select root ports to further increase the blast radius.
> 
>>>     The IOMMU and P2P are already not exclusive, we can bounce off
>>> the IOMMU or make use of ATS as we've previously discussed.  We were
>>>     previously talking about a build time config option that you
>>> didn't expect distros to use, so I don't think intervention for the
>>> user to disable the IOMMU if it's enabled by default is a serious
>>> concern either.
>>
>> ATS definitely makes things more interesting for the cases where the
>> EPs support it. However I don't really have a handle on how common
>> ATS support is going to be in the kinds of devices we have been
>> focused on (NVMe SSDs and RDMA NICs mostly).
>>
>>> What you're trying to do is enabled direct peer-to-peer for
>>> endpoints which do not support ATS when the IOMMU is enabled, which
>>> is not something that necessarily makes sense to me.
>>
>> As above the advantage of leaving the IOMMU on is that it allows for
>> both p2pdma PCI domains and IOMMU groupings PCI domains in the same
>> system. It is just that these domains will be separate to each other.
> 
> That argument makes sense if we had the ability to select specific sets
> of devices, but that's not the case here, right?  With the shotgun
> approach, we're clearly favoring one at the expense of the other and
> it's not clear why we don't simple force the needle all the way in that
> direction such that the results are at least predictable.
> 
>>>   So that leaves avoiding bounce buffers as the remaining IOMMU
>>> feature
>>
>> I agree with you here that the devices we will want to use for p2p
>> will probably not require a bounce buffer and will support 64 bit DMA
>> addressing.
>>
>>> I'm still not seeing why it's terribly undesirable to require
>>> devices to support ATS if they want to do direct P2P with an IOMMU
>>> enabled.
>>
>> I think the one reason is for the use-case above. Allowing IOMMU
>> groupings on one domain and p2pdma on another domain....
> 
> If IOMMU grouping implies device assignment (because nobody else uses
> it to the same extent as device assignment) then the build-time option
> falls to pieces, we need a single kernel that can do both.  I think we
> need to get more clever about allowing the user to specify exactly at
> which points in the topology they want to disable isolation.  Thanks,
> 
> Alex

+1/ack

RDMA VFs lend themselves to NVMEoF w/device-assignment.... need a way to
put NVME 'resources' into an assignable/manageable object for 'IOMMU-grouping',
which is really a 'DMA security domain' and less an 'IOMMU grouping domain'.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
