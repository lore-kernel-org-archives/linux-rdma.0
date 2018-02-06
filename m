From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rfc 0/5] generic adaptive IRQ moderation library for I/O devices
Date: Tue, 6 Feb 2018 08:56:19 +0200
Message-ID: <CAJ3xEMgPfchks6wFUL8S1OJwv9JCcTtCmXz5ZdtR2HvKYQAFUg@mail.gmail.com>
References: <20180205220316.30236-1-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205220316.30236-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Tal Gilboa <talgi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andy Gospodarek <gospo-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 6, 2018 at 12:03 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
[...]
> In the networking stack, each device driver implements adaptive IRQ moderation
> on its own. The approach here is a bit different, it tries to take the common denominator,
> which is per-queue statistics gathering and workload change identification
> (basically decides if the moderation scheme needs to change).

not any more, Andy and Tal made the mlx5 AM code a kernel library
which is called DIM

f4e5f0e MAINTAINERS: add entry for Dynamic Interrupt Moderation
6a8788f bnxt_en: add support for software dynamic interrupt moderation
8115b75 net/dim: use struct net_dim_sample as arg to net_dim
4c4dbb4 net/mlx5e: Move dynamic interrupt coalescing code to include/linux
9a31742 net/mlx5e: Change Mellanox references in DIM code
b9c872f net/mlx5e: Move generic functions to new file
f5e7f67 net/mlx5e: Move AM logic enums
138968e net/mlx5e: Remove rq references in mlx5e_rx_am
f58ee09 net/mlx5e: Move interrupt moderation forward declarations
98dd1ed net/mlx5e: Move interrupt moderation structs to new file

can you make use of that? cc-ing them in case you have questions/comments


> The library is targeted to multi-queue devices, but should work on single queue
> devices as well, however I'm not sure that these devices will need something
> like interrupt moderation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
