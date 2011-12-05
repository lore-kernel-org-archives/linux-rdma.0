From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: sparse endianness complaints for drivers/infiniband
Date: Mon, 5 Dec 2011 18:43:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325653495@ORSMSX102.amr.corp.intel.com>
References: <CAO+b5-q97ri0YhKcbO1RBOGHXeJh2YMRjShtNDzihU7QjN+UVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-q97ri0YhKcbO1RBOGHXeJh2YMRjShtNDzihU7QjN+UVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Has anyone had a look recently at the sparse endianness complaints
> about the code under drivers/infiniband ? I haven't analyzed these
> messages closely yet - these might indicate real bugs.

Yes - I looked last week, and I plan on submitting patches for these this week.  Apparently the sparse output gets lost piping the output of make into tee and then examining the resulting file.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
