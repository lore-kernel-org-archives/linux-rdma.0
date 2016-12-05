From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Use ib_drain_qp instead of ib_drain_rq in ib_srp
Date: Mon, 5 Dec 2016 16:51:02 +0200
Message-ID: <97bc319e-ffa8-17f3-cebb-11d0a7d110d3@mellanox.com>
References: <fa2d38be-bc59-5120-6dfd-f24ab01d6d8f@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fa2d38be-bc59-5120-6dfd-f24ab01d6d8f-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just noticed that send_cq has IB_POLL_DIRECT restriction in srp.

what about iSER then ? we use there ib_drain_sq...


On 12/5/2016 4:43 PM, Max Gurtovoy wrote:
> hi guys,
> I've noticed that we use ib_drain_rq in teardown flow in ib_srp driver.
> Trying to figure out why is this better than ib_drain_qp ?
> BTW, the recv_cq != send_cq in srp so it's even better to use
> ib_drain_qp, isn't it ?
>
> I haven't encountered a bug in this area yet, but just trying to
> understand if it's there.
>
> thanks,
> Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
