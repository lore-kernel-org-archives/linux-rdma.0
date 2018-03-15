From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Date: Thu, 15 Mar 2018 00:00:27 -0400
Message-ID: <yq1fu529eec.fsf@oracle.com>
References: <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <BB94077B-7EB3-49C4-862D-BF77D0A692CC@raithlin.com>
 <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
 <8de5d3dd-a78f-02d5-0eea-4365364143b6@deltatee.com>
 <20180314025639.GA50067@bhelgaas-glaptop.roam.corp.google.com>
 <112493af-ccd0-455b-6600-b50764f7ab7e@deltatee.com>
 <20180314185159.GD179719@bhelgaas-glaptop.roam.corp.google.com>
 <b75e83ad-bb83-1f8d-1751-0989cc2493f1@deltatee.com>
 <CAPcyv4g-A6fqdTahxX=aONSCgp1eEvBb=ZVMzbZUWUDmqBbj7Q@mail.gmail.com>
 <AA646409-BB63-4757-A250-CE7118D4D3B8@raithlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <AA646409-BB63-4757-A250-CE7118D4D3B8-pv7U853sEMVWk0Htik3J/w@public.gmane.org> (Stephen
 Bates's message of "Wed, 14 Mar 2018 19:34:53 +0000")
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Stephen,

>> It would be useful if those configurations were not left behind so
>> that Linux could feasibly deploy offload code to a controller in the
>> PCI domain.
>    
> Agreed. I think this would be great. Kind of like the XCOPY framework
> that was proposed a while back for SCSI devices [1] but updated to also
> include NVMe devices. That is definitely a use case we would like this
> framework to support.

I'm on my umpteenth rewrite of the block/SCSI offload code. It is not as
protocol-agnostic as I would like in the block layer facing downwards.
It has proven quite hard to reconcile token-based and EXTENDED COPY
semantics along with the desire to support stacking. But from an
application/filesystem perspective everything looks the same regardless
of the intricacies of the device. Nothing is preventing us from
supporting other protocols...

-- 
Martin K. Petersen	Oracle Linux Engineering
