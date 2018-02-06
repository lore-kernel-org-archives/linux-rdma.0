From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rfc 0/5] generic adaptive IRQ moderation library for I/O devices
Date: Tue, 6 Feb 2018 10:54:18 +0200
Message-ID: <CAJ3xEMi0KzOMJt7d01ohHW-ZpmdwvfzZCLN0qA-LLFwROeVseQ@mail.gmail.com>
References: <20180205220316.30236-1-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205220316.30236-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Tal Gilboa <talgi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 6, 2018 at 12:03 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:

> The main reason why this implementation is different then the common networking devices
> implementation (and kept separate) is that in my mind at least, network devices are different
> animals than other I/O devices in the sense that:

Oh, I see now  that you do refer to the netdev library, I was confused
by "In the networking stack, each device driver
implements adaptive IRQ moderation on its own" comment.

> (a) network devices rely heavily on byte count of raw ethernet frames for adaptive moderation
>     while in storage or I/O, the byte count is often a result of a submission/completion transaction
>     and sometimes even known only to the application on top of the infrastructure (like in the
>     rdma case).

> (b) Performance characteristics and expectations in representative workloads.
> (c) network devices collect all sort of stats for different functionalities (where adaptive moderation
>     is only one use-case) and I'm not sure at all that a subset of stats could easily migrate to a different
>     context.

I think Tal has idea/s on how the existing library can be changed to
support more modes/models
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
