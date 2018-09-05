From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
Date: Wed, 5 Sep 2018 14:14:48 -0600
Message-ID: <2a3394bd-5f13-4818-43f4-dfc61f501e05@kernel.dk>
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
 <eb42fb94-9da6-955b-8524-0a0f5ac4bd19@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eb42fb94-9da6-955b-8524-0a0f5ac4bd19@deltatee.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-Id: linux-rdma@vger.kernel.org

On 9/5/18 2:09 PM, Logan Gunthorpe wrote:
> 
> 
> On 05/09/18 02:11 PM, Christoph Hellwig wrote:
>> On Wed, Sep 05, 2018 at 01:54:31PM -0600, Jens Axboe wrote:
>>> On 9/5/18 1:56 PM, Christoph Hellwig wrote:
>>>> On Wed, Sep 05, 2018 at 01:45:04PM -0600, Jens Axboe wrote:
>>>>> The point is that the caller doesn't necessarily know where the bio
>>>>> will end up, hence the caller can't fully check if the whole stack
>>>>> supports P2P.
>>>>
>>>> The caller must necessarily know where the bio will end up, as for P2P
>>>> support we need to query if the bio target is P2P capable vs the
>>>> source of the P2P memory.
>>>
>>> Then what's the point of having the check at all?
>>
>> Just an additional little safe guard.  If you think it isn't worth
>> it I guess we can just drop it for now.
> 
> Yes, the point is to prevent driver writers from doing the wrong thing
> by not doing the necessary checks before submitting to the queue.

But if the caller must absolutely know where the bio will end up, then
it seems super redundant. So I'd vote for killing this check, it buys
us absolutely nothing and isn't even exhaustive in its current form.

-- 
Jens Axboe
