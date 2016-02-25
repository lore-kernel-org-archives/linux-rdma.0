From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH 3/5] IB/isert: Convert to new CQ API
Date: Thu, 25 Feb 2016 18:41:02 +0200
Message-ID: <56CF2E9E.6030006@mellanox.com>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
 <1456148958-27973-4-git-send-email-hch@lst.de>
 <56CDD3D7.7060408@dev.mellanox.co.il> <20160224184348.GA5241@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160224184348.GA5241@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 2/24/2016 8:43 PM, Christoph Hellwig wrote:
> On Wed, Feb 24, 2016 at 06:01:27PM +0200, Sagi Grimberg wrote:
>> I don't find the wr_cqe address all that useful. I modified
>> isert_print_wc to get a error type instead ("send", "recv", "rdma
>> write"...) sounds fine?
>
> Fine with me.
>

sounds good.
