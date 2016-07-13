From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: NVMe over RDMA latency
Date: Wed, 13 Jul 2016 10:25:55 -0700
Message-ID: <CAF1ivSZV1h3y2KYjGxo3nba_Qpn-5nsN8SVmCW3Rafzc4tsH4Q@mail.gmail.com>
References: <1467921342.24395.12.camel@ssi> <57860EBA.5010103@grimberg.me> <CABgxfbEa077L6o-AxEqMr1WMuU-gC8_qc4VrrNs9nAkKLrysdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbEa077L6o-AxEqMr1WMuU-gC8_qc4VrrNs9nAkKLrysdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 13, 2016 at 10:22 AM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2) Could anyone pass the pointer on how to check whether a block device
> supports the polling mode (and how to turn it on) ?

Example:

echo 0 > /sys/block/nvme0n1/queue/io_poll
echo 1 > /sys/block/nvme0n1/queue/io_poll
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
