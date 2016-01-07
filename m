From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 00/10] iSER support for remote invalidate
Date: Thu, 7 Jan 2016 17:26:55 +0200
Message-ID: <568E83BF.70606@dev.mellanox.co.il>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
 <1450671628.25674.27.camel@haakon3.risingtidesystems.com>
 <20151224101514.GB6438@infradead.org> <567BC782.7090501@dev.mellanox.co.il>
 <1452105796.26125.28.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1452105796.26125.28.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


> FYI, the only conflict as reported in linux-next last week is with nfsd
> tree and "IB: merge struct ib_device_attr into struct ib_device" here:
>
> http://marc.info/?l=linux-next&m=145155049101826&w=2
>
> It looks like there is ongoing discussion this morning wrt rdma + nfsd
> trees..
>
> Do you still want this series dropped from target-pending/for-next..?

Given that the series was modified on top of the CQ API work then it
makes better sense yes. Doug will take it.

Thanks Nic.
