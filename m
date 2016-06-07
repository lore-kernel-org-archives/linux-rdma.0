From: Sagi Grimberg <sagi@lightbits.io>
Subject: Re: [PATCH v2] IB/core: remove dead code
Date: Tue, 7 Jun 2016 16:14:10 +0300
Message-ID: <5756C8A2.5060305@lightbits.io>
References: <1465247706-4418-1-git-send-email-sudipm.mukherjee@gmail.com>
 <5756C0E0.7090303@lightbits.io> <20160607124259.GA3906@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160607124259.GA3906@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@lightbits.io>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, leon@kernel.org, Max Gurtovoy <maxg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


>> Actually it looks like the data-integrity insert/strip operation
>> (where protection sg list does not exist) is broken.
>>
>> It looks that the protection scatterlist should be done only if
>> prot_sg_count was provided...
>>
>> I don't have access to mlx5 devices at the moment (still waiting
>> to get some...)

Hey Christoph,

> I've reported the brokenness in the existing iSER code when I started
> working on signature MR support in the generic API.  As no one helped
> managed to figure out the issue or how it should operate I clone the
> existing semantics, even given I knew they are broken.

There are two modes for the insert/strip operation, one is with PI on
memory and without on the wire (which is useful when having a target
working against legacy initiators), and one is with PI on the wire but
not in memory. You reported that the latter was broken (the less
useful case) and my understanding is that it was a result of
the target<->isert interaction. The last time I used the first mode
it worked fine.

I'll try to get my hands on some mlx5 devices soon and have a look into
this. I still want to change the API so it will hide all this noise from
the consumer but I need to find some spare cycles for it.

In the meantime, CC'ing Max from Mellanox and maybe he can check if
PI insert/strip are still alive.

Cheers,
Sagi.
