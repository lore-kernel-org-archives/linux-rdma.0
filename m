From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH for-next 02/10] IB/iser: Default to fastreg instead of fmr
Date: Tue, 17 Nov 2015 11:35:33 +0200
Message-ID: <564AF4E5.1000400@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-3-git-send-email-sagig@mellanox.com>
 <20151117085726.GB19578@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20151117085726.GB19578@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org



On 17/11/2015 10:57, Christoph Hellwig wrote:
>> +	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
>> +		iser_info("FastReg supported, using FastReg for registration\n");
>> +		device->reg_ops = &fastreg_ops;
>> +	} else
>>   	if (device->ib_device->alloc_fmr && device->ib_device->dealloc_fmr &&
>
> Should an 'else if'.  If the line gets to long it might be time to add a
> rdma_cap_fmr() helper to ib_verbs.h

OK, I will.
