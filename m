From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: possible core cq bug
Date: Mon, 4 Dec 2017 20:41:52 +0200
Message-ID: <456aef15-a5a7-6dc8-478b-9fc7f75ff1fb@grimberg.me>
References: <052101d36ba2$7e5b4120$7b11c360$@opengridcomputing.com>
 <be658098-28a6-e5a8-cebf-5865096f99ce@grimberg.me>
 <006c01d36c4a$c79cfb50$56d6f1f0$@opengridcomputing.com>
 <e7782921-b55a-a628-02d4-874d88049ec5@grimberg.me>
 <007c01d36c5a$9d20df30$d7629d90$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <007c01d36c5a$9d20df30$d7629d90$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> That would at least log the issue, but the thread in ib_drain_qp() will be stuck forever continually blocking for 1/10sec and then polling.  Perhaps the drain logic should detect this, and then return?

I don't think returning is a better choice here..

> Is there a reason we don't get rid of ib_create_cq()?   Or just make it call ib_alloc_cq()...

We could do that, it also makes sense to me. Thoughts from others?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
