From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core] Verbs: Introduce resource domain
Date: Tue, 19 Sep 2017 17:05:11 +0300
Message-ID: <CAFgAxU9M0MXw371Nh2tviuQHXCJxnFLPtaAcsevigEMMWjUPhA@mail.gmail.com>
References: <1505648922-21346-1-git-send-email-yishaih@mellanox.com> <20170918205411.GB7059@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170918205411.GB7059-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 18, 2017 at 11:54 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Sep 17, 2017 at 02:48:42PM +0300, Yishai Hadas wrote:
>
>> Resource domain represents a collection of IB resources (as of QP, CQ,
>> etc.) which are accessed by an application from the same context (e.g.
>> same thread) and as such can share hardware and software resources to
>> allow smarter management of resources by the provider library and better
>> performance.
>
> This sounds exactly like a PD to me. Why do we need another construct?
> What is wrong with a 'thread-unsafe' flag during PD creation and then
> contain the shared resources in the PD?

PD does not fit good enough. It is does not cover CQ's in allocation
flow, but limited to QP's, SRQ's, WQ's.
Also, using multiple PD's will require to use a dedicated MR per PD,
instead of sharing a single MR for the entire memory used over
multiple threads / QP's.

>
>>       uint32_t                raw_packet_caps; /* Use ibv_raw_packet_caps */
>> +     uint32_t                max_resource_domains;
>
> Even with this approach, not sure a max makes much sense, this value should
> just be hashed into whatever range the provider has on a resource by
> resource basis.

By exposing the max_resource_domains we allow the application to take
the decision of which element will get hurt if it reaches that limit.
If we leave the logic hidden inside the libraries, the application
losses control over the best performance vs average better
performance.

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
