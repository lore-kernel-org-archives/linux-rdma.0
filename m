From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rfc 0/5] generic adaptive IRQ moderation library for I/O devices
Date: Tue, 6 Feb 2018 13:34:21 +0200
Message-ID: <CAJ3xEMi0FfPgiZkpVJNdcuykK5v6cUzR5uj6nAHUK6evTUXqbA@mail.gmail.com>
References: <20180205220316.30236-1-sagi@grimberg.me> <CAJ3xEMgPfchks6wFUL8S1OJwv9JCcTtCmXz5ZdtR2HvKYQAFUg@mail.gmail.com>
 <08889344-db9d-cf46-6cfb-56764042f578@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <08889344-db9d-cf46-6cfb-56764042f578-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Tal Gilboa <talgi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andy Gospodarek <gospo-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 6, 2018 at 11:25 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> Hey Or,
>
>> not any more, Andy and Tal made the mlx5 AM code a kernel library
>> which is called DIM
>>
>> f4e5f0e MAINTAINERS: add entry for Dynamic Interrupt Moderation
>> 6a8788f bnxt_en: add support for software dynamic interrupt moderation
>> 8115b75 net/dim: use struct net_dim_sample as arg to net_dim
>> 4c4dbb4 net/mlx5e: Move dynamic interrupt coalescing code to include/linux
>> 9a31742 net/mlx5e: Change Mellanox references in DIM code
>> b9c872f net/mlx5e: Move generic functions to new file
>> f5e7f67 net/mlx5e: Move AM logic enums
>> 138968e net/mlx5e: Remove rq references in mlx5e_rx_am
>> f58ee09 net/mlx5e: Move interrupt moderation forward declarations
>> 98dd1ed net/mlx5e: Move interrupt moderation structs to new file
>>
>> can you make use of that? cc-ing them in case you have questions/comments
>
>
> Thanks a lot for the pointer, I'm not following net-next regularly.
> This seems to be a copy of the mlx5 code.

Just to make it clear, the code was moved to a library and not copied... so
there's single instance of the code upstream and lets try to find a way for
your use case to take advantage of it possibly under some modifications.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
