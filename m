From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH 02/12] pci-p2p: Add sysfs group to display p2pmem stats
Date: Thu, 4 Jan 2018 16:13:09 -0700
Message-ID: <b83d097d-bcde-b277-6d4f-26cd7f943bbd@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-3-logang@deltatee.com>
 <20180104215040.GE189897@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180104215040.GE189897@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-Id: linux-rdma@vger.kernel.org



On 04/01/18 02:50 PM, Bjorn Helgaas wrote:
> On Thu, Jan 04, 2018 at 12:01:27PM -0700, Logan Gunthorpe wrote:
>> Attributes display the total amount of P2P memory, the ammount available
>> and whether it is published or not.
> 
> s/ammount/amount/ (also below)

Will fix.

> I wonder if "p2pdma" would be a more suggestive term?  It's not really
> the *memory* that is peer-to-peer; the peer-to-peer part is referring
> to *access* to the memory.

I agree with Jason on this point. For now, it only describes the 
peer-to-peer memory attributes. If we change the directory to p2pdma 
then we'd have to add a mem prefix or something to each attribute.

>> @@ -82,6 +130,9 @@ static int pci_p2pmem_setup(struct pci_dev *pdev)
>>   	if (error)
>>   		goto out_pool_destroy;
>>   
>> +	if (sysfs_create_group(&pdev->dev.kobj, &p2pmem_group))
>> +		dev_warn(&pdev->dev, "failed to create p2p sysfs group\n");
> 
> Not sure the warning (by itself) is worthwhile.  If we were going to
> disable the feature if sysfs_create_group() failed, that's one thing,
> but we aren't doing anything except generating a warning, which the
> user can't really do anything with.  If the user is looking for the
> sysfs file, its absence will be obvious even without the message.

Unfortunately, sysfs_create_group() has the warn_unused_result flag set. 
So I need to do something with the result to squash the warning. I could 
just assign it to an unused variable but something seemed like it needed 
to be done and printing a warning was the easiest thing...

Logan
