From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 16/24] ibnbd: client: main functionality
Date: Mon, 5 Feb 2018 13:54:58 +0100
Message-ID: <CAJrWOzAKmE_KPZi4i5dCXuBOkuN7Ax4SpVv6tbZfTW4SLamb+A@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-17-roman.penyaev@profitbricks.com> <4f5c5941-c30f-51e8-619a-c03aa9e514b7@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <4f5c5941-c30f-51e8-619a-c03aa9e514b7@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 2, 2018 at 4:11 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2/2/18 7:08 AM, Roman Pen wrote:
>> This is main functionality of ibnbd-client module, which provides
>> interface to map remote device as local block device /dev/ibnbd<N>
>> and feeds IBTRS with IO requests.
>
> Kill the legacy IO path for this, the driver should only support
> blk-mq. Hence kill off your BLK_RQ part, that will eliminate
> the dual path you have too.

ok, sounds good, frankly, we did not use rq very long time.

--
Roman
