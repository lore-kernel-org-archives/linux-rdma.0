From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v9 13/13] nvmet: Optionally use PCI P2P memory
Date: Fri, 5 Oct 2018 00:34:06 -0700
Message-ID: <236ae882-34e0-50d8-ac19-ee5dab8db3f2@grimberg.me>
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181004212747.6301-14-logang@deltatee.com>
 <a3af4bda-0b73-c964-c7d6-5d59f0710768@grimberg.me>
 <2bcc0927-83ab-1bf2-d584-aebd5274cefa@deltatee.com>
 <20181005070720.GA23725@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181005070720.GA23725-jcswGhMUV9g@public.gmane.org>
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
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>>> +static inline struct device *nvmet_ns_dev(struct nvmet_ns *ns)
>>>> +{
>>>> +	return disk_to_dev(ns->bdev->bd_disk);
>>>> +}
>>>
>>> This needs to handle non bdev namespaces.
>>
>> As it's coded now the helper never gets called unless ns->bdev is not
>> null. But in general, yes you are right, we should probably return NULL
>> if ns->bdev is NULL.
> 
> I'd rather skip that for now.

If there is a v10 I don't see why that cannot be addressed.

>>> index ef286b72d958..3d12f5f4568d 100644
>>> --- a/drivers/nvme/target/fc.c
>>> +++ b/drivers/nvme/target/fc.c
>>> @@ -2280,6 +2280,7 @@ nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport
>>> *tgtport,
>>>           fod->req.cmd = &fod->cmdiubuf.sqe;
>>>           fod->req.rsp = &fod->rspiubuf.cqe;
>>>           fod->req.port = tgtport->pe->port;
>>> +       fod->req.p2p_client = tgtport->dev;
>>>
>>>           /* clear any response payload */
>>>           memset(&fod->rspiubuf, 0, sizeof(fod->rspiubuf));
>>> --
>>
>> Sure, I guess that makes sense. I've never tried it with fc hardware but
>> I assume there's no reason it wouldn't work.
>>
>> I'll queue these changes up for a v10.
> 
> And I'd wait until someone has actually tested this case.

Oh yes, agreed. Should work though...
