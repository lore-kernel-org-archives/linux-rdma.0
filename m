From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
Date: Wed, 5 Sep 2018 14:09:55 -0600
Message-ID: <eb42fb94-9da6-955b-8524-0a0f5ac4bd19@deltatee.com>
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-8-logang@deltatee.com>
 <b5ab8fa3-34ac-3117-fa0d-5206c3939435@kernel.dk>
 <20180901082812.GB670@lst.de>
 <5f79c012-c6e1-56bb-62fd-0689181fb2c9@deltatee.com>
 <59b28977-8f2a-6228-2050-03fae6bdbedd@kernel.dk>
 <1b4283da-44df-4a02-3167-e295243cef78@deltatee.com>
 <09258b9b-3aed-9890-b31a-bd70a133966c@kernel.dk>
 <20180905195647.GA1626@lst.de>
 <bcc1b3cf-2fd9-fa61-9cfb-b0e4d84e5d94@kernel.dk>
 <20180905201152.GA1893@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180905201152.GA1893-jcswGhMUV9g@public.gmane.org>
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
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 05/09/18 02:11 PM, Christoph Hellwig wrote:
> On Wed, Sep 05, 2018 at 01:54:31PM -0600, Jens Axboe wrote:
>> On 9/5/18 1:56 PM, Christoph Hellwig wrote:
>>> On Wed, Sep 05, 2018 at 01:45:04PM -0600, Jens Axboe wrote:
>>>> The point is that the caller doesn't necessarily know where the bio
>>>> will end up, hence the caller can't fully check if the whole stack
>>>> supports P2P.
>>>
>>> The caller must necessarily know where the bio will end up, as for P2P
>>> support we need to query if the bio target is P2P capable vs the
>>> source of the P2P memory.
>>
>> Then what's the point of having the check at all?
> 
> Just an additional little safe guard.  If you think it isn't worth
> it I guess we can just drop it for now.

Yes, the point is to prevent driver writers from doing the wrong thing
by not doing the necessary checks before submitting to the queue.

Logan
