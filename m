From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsocket library and dup2()
Date: Wed, 5 Sep 2012 23:12:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8C503@ORSMSX101.amr.corp.intel.com>
References: <CAKb08J+ZApm-GXGUu--NZV31PvGK-tRrqPGFU4aMhWC50nmYow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKb08J+ZApm-GXGUu--NZV31PvGK-tRrqPGFU4aMhWC50nmYow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Couvrard <acouvrard2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I found the following code in dup2():
> 
> 	oldfdi = idm_lookup(&idm, oldfd);
> 	if (oldfdi && oldfdi->type == fd_fork)
> 		fork_passive(oldfd);
> 
> In that code the file descriptor type ("type") is compared with a fork
> state enum value ("fd_fork"). Is that on purpose ??

On purpose?  I'll have to go with no.

It's a bug resulting from working on different patches at the same time and not updating the dup2 patch to account for the change where I added a state to the fd.  Thanks for catching this.  I'll fix it up later this week or early next week and push out an update.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
