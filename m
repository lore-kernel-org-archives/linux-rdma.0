From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 11/11] nvmet: Optionally use PCI P2P memory
Date: Wed, 21 Mar 2018 10:52:25 -0600
Message-ID: <a75f5bce-8ab5-7d99-bb27-908d0cc7c6f6@deltatee.com>
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-12-logang@deltatee.com> <20180321092702.GC7098@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180321092702.GC7098-jcswGhMUV9g@public.gmane.org>
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
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 21/03/18 03:27 AM, Christoph Hellwig wrote:
>> +				  const char *page, size_t count)
>> +{
>> +	struct nvmet_port *port = to_nvmet_port(item);
>> +	struct device *dev;
>> +	struct pci_dev *p2p_dev = NULL;
>> +	bool use_p2pmem;
>> +
>> +	switch (page[0]) {
>> +	case 'y':
>> +	case 'Y':
>> +	case 'a':
>> +	case 'A':
>> +		use_p2pmem = true;
>> +		break;
>> +	case 'n':
>> +	case 'N':
>> +		use_p2pmem = false;
>> +		break;
>> +	default:
>> +		dev = bus_find_device_by_name(&pci_bus_type, NULL, page);
>> +		if (!dev) {
>> +			pr_err("No such PCI device: %s\n", page);
>> +			return -ENODEV;
>> +		}
>> +
>> +		use_p2pmem = true;
>> +		p2p_dev = to_pci_dev(dev);
>> +
>> +		if (!pci_has_p2pmem(p2p_dev)) {
>> +			pr_err("PCI device has no peer-to-peer memory: %s\n",
>> +			       page);
>> +			pci_dev_put(p2p_dev);
>> +			return -ENODEV;
>> +		}
>> +	}
> 
> Yikes.  Shouldn't auto just be the normal yes case instead of this
> string parsing mess?

Sorry, I don't follow. The code, as is, should automatically select the
device if the user  sets it to "yes" or "auto" or "y" or similar.
(Roughly similar to how kstrtobool() works, except '0' or '1' are not
accepted seeing they could overlap with PCI device names). In other
cases, it looks for the specific PCI device name to use exactly.

Are you saying it shouldn't work this way or are you saying the code to
implement it is too messy?

>> +	if (rsp->req.sg != &rsp->cmd->inline_sg) {
>> +		if (rsp->req.p2p_dev)
>> +			pci_p2pmem_free_sgl(rsp->req.p2p_dev, rsp->req.sg,
>> +					    rsp->req.sg_cnt);
>> +		else
>> +			sgl_free(rsp->req.sg);
>> +	}
> 
> Can we factor this into a helper, as the other target drivers (fc for now,
> tcp soon) using sgl allocatins should share the code?
> 
> (same for the alloc side)

Sure. Would the helpers belong in core.c?

Thanks,

Logan
