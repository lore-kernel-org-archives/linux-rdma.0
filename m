From: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Date: Wed, 9 May 2018 11:52:04 -0400
Message-ID: <1c5b4a06-25bc-457a-8569-a5ae5eaa6e00@redhat.com>
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <CAPcyv4g+5N_n03J-VhmJfrr60Sqk95ZapLKBkwSsGvV4nQ+ZRw@mail.gmail.com>
 <64C231F5-DE36-415F-B308-3A423B0BBACB@raithlin.com>
 <15433946-f7f5-f610-4e80-380fb59920e5@redhat.com>
 <3C9FB262-A93C-4C8F-B1E0-85C6D6F78BC2@raithlin.com>
 <c5f30ced-7bbf-9420-db1a-72519fc78b3a@redhat.com>
 <20180508180157.7c7b393f@w520.home>
 <B5BFCF39-6BB4-4E45-B805-C8FCC8B79EF3@raithlin.com>
 <20180509084445.626d2732@w520.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180509084445.626d2732-DGNDKt5SQtizQB+pC5nmwQ@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/09/2018 10:44 AM, Alex Williamson wrote:
> On Wed, 9 May 2018 12:35:56 +0000
> "Stephen  Bates" <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org> wrote:
> 
>> Hi Alex and Don
>>
>>>     Correct, the VM has no concept of the host's IOMMU groups, only
>>> the hypervisor knows about the groups,
>>
>> But as I understand it these groups are usually passed through to VMs
>> on a pre-group basis by the hypervisor? So IOMMU group 1 might be
>> passed to VM A and IOMMU group 2 passed to VM B. So I agree the VM is
>> not aware of IOMMU groupings but it is impacted by them in the sense
>> that if the groupings change the PCI topology presented to the VM
>> needs to change too.
> 
> Hypervisors don't currently expose any topology based on the grouping,
> the only case where such a concept even makes sense is when a vIOMMU is
> present as devices within the same group cannot have separate address
> spaces.  Our options for exposing such information is also limited, our
> only real option would seem to be placing devices within the same group
> together on a conventional PCI bus to denote the address space
> granularity.  Currently we strongly recommend singleton groups for this
> case and leave any additional configuration constraints to the admin.
> 
> The case you note of a group passed to VM A and another passed to VM B
> is exactly an example of why any sort of dynamic routing change needs to
> have the groups fully released, such as via hot-unplug.  For instance,
> a routing change at a shared node above groups 1 & 2 could result in
> the merging of these groups and there is absolutely no way to handle
> that with portions of the group being owned by two separate VMs after
> the merge.  Thanks,
> 
> Alex
> 
The above is why I stated the host/HV has to do p2p setup *before* device-assignment
is done.
Now, that could be done at boot time (with a mod.conf-like config in host/HV, before VM startup)
as well.
Dynamically, if such a feature is needed, requires a hot-unplug/plug cycling as Alex states.
