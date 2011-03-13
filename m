From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Converting from RC to UC
Date: Sun, 13 Mar 2011 11:56:56 +0200
Message-ID: <4D7C94E8.6070906@mellanox.com>
References: <loom.20110311T192125-878@post.gmane.org>	<AANLkTimM0PDiWuHFJfn3s-JVEKWHVVfL4+2Kcc4+G5C7@mail.gmail.com> <loom.20110311T224601-402@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110311T224601-402-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  Alan Cook wrote:
> Roland Dreier<roland@...>  writes:
>> How are you setting up the connection? My understanding is that the RDMA CM (ie librdmacm) does not handle UC, so if you are using that, it shouldn't work.  Sean could confirm this.
>
> I am using RDMA CM.  I have not seen any documentation that states it does not support UC, although I have not seen any documentation that says it does either.   I have seen documentation regarding RDMA CM that talks about a connection not  actually being established between queue pairs when using unreliable datagram (UD), but nothing regarding support for UC.

Alan, you haven't specified if you app is user space or kernel space 
based,  I assume the former, I believe that it either just works or can 
be just made to work... e.g maybe a minor error on your side, or maybe 
something small to change/complete on the rdma-cm side...

I'm copying the maintainer of the kernel rdma-cm and librdmacm, Sean - 
should there any problem for librdmacm consumers to use UC at their apps?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
