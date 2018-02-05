From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 05/24] ibtrs: client: main functionality
Date: Mon, 5 Feb 2018 16:14:43 +0200
Message-ID: <f0c64f7f-2870-0657-11ec-123a3e99b7a7@grimberg.me>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-6-roman.penyaev@profitbricks.com>
 <1517590473.2675.21.camel@wdc.com>
 <CAJrWOzD0YXWGCpR+BTOAJ7HhuVG_cjuomBK7vpGeTYu3H+DE4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJrWOzD0YXWGCpR+BTOAJ7HhuVG_cjuomBK7vpGeTYu3H+DE4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Indeed, seems sbitmap can be reused.
> 
> But tags is a part of IBTRS, and is not related to block device at all.  One
> IBTRS connection (session) handles many block devices

we use host shared tag sets for the case of multiple block devices.

> (or any IO producers).

Lets wait until we actually have this theoretical non-block IO
producers..

> With a tag you get a free slot of a buffer where you can read/write, so once
> you've allocated a tag you won't sleep on IO path inside a library.

Same for block tags (given that you don't set the request queue
otherwise)

> Also tag
> helps a lot on IO fail-over to another connection (multipath implementation,
> which is also a part of the transport library, not a block device), where you
> simply reuse the same buffer slot (with a tag in your hands) forwarding IO to
> another RDMA connection.

What is the benefit of this detached architecture? IMO, one reason why
you ended up not reusing a lot of the infrastructure is yielded from the
attempt to support a theoretical different consumer that is not ibnbd.
Did you actually had plans for any other consumers?

Personally, I think you will be much better off with a unified approach
for your block device implementation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
