From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH rfc 0/5] generic adaptive IRQ moderation library for I/O
 devices
Date: Tue, 6 Feb 2018 11:25:30 +0200
Message-ID: <08889344-db9d-cf46-6cfb-56764042f578@grimberg.me>
References: <20180205220316.30236-1-sagi@grimberg.me>
 <CAJ3xEMgPfchks6wFUL8S1OJwv9JCcTtCmXz5ZdtR2HvKYQAFUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMgPfchks6wFUL8S1OJwv9JCcTtCmXz5ZdtR2HvKYQAFUg@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: linux-block@vger.kernel.org, RDMA mailing list <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Idan Burstein <idanb@mellanox.com>, Bart Van Assche <bart.vanassche@wdc.com>, Tal Gilboa <talgi@mellanox.com>, Andy Gospodarek <gospo@broadcom.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hey Or,

> not any more, Andy and Tal made the mlx5 AM code a kernel library
> which is called DIM
> 
> f4e5f0e MAINTAINERS: add entry for Dynamic Interrupt Moderation
> 6a8788f bnxt_en: add support for software dynamic interrupt moderation
> 8115b75 net/dim: use struct net_dim_sample as arg to net_dim
> 4c4dbb4 net/mlx5e: Move dynamic interrupt coalescing code to include/linux
> 9a31742 net/mlx5e: Change Mellanox references in DIM code
> b9c872f net/mlx5e: Move generic functions to new file
> f5e7f67 net/mlx5e: Move AM logic enums
> 138968e net/mlx5e: Remove rq references in mlx5e_rx_am
> f58ee09 net/mlx5e: Move interrupt moderation forward declarations
> 98dd1ed net/mlx5e: Move interrupt moderation structs to new file
> 
> can you make use of that? cc-ing them in case you have questions/comments

Thanks a lot for the pointer, I'm not following net-next regularly.
This seems to be a copy of the mlx5 code.

So as mentioned in the cover letter, the implementation was inspired
from the mlx5 driver as it had some of the abstraction properties I was
aiming to achieve.

What I didn't mention, was that I started from using the mlx5
implementation as is (slightly modified). Unfortunately in the
workloads that I've tested, I was not able to get the am level to
converge. So I went in a slightly different direction which gave me
better results (although still not perfect and lightly tested).

This led me to believe that mlx5 offered strategy might not suite
storage I/O workloads (although I do acknowledge that I could be proven
wrong here).

For example, a design choice I took was that the moderation scheme would
be more aggressive towards latency on the expense of throughput
optimization since high end storage devices are often expected to meet
strict latency requirements. Does that makes sense for network devices?
I don't know.

Another difference is that unlike net devices, storage I/O transactions
usually look like request/response where the data transfer is offloaded
by the controller/hba (net devices moderate on raw RX datagrams).
Moreover, it might not be trivial to track the bytes/sec from a
completion at all (might be embedded somewhere in the consumer context).

So overall, at this point I'm a bit skeptical that it will makes sense
to commonise the two implementations. I'd like to hear some more input
if this is something that the community is interested in first. If this
is something people are interested in, we can look if it makes sense to
reuse net_dim.h or not.
