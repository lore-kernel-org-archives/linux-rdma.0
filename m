From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Writing RDMA applications on Linux
Date: Fri, 24 Aug 2012 15:40:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8ACB1@ORSMSX101.amr.corp.intel.com>
References: <CAJycT5rf_SGPh2Gfg9C9aK2wm4uR6ZMsXeh1WD1gWGb-oqgnLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJycT5rf_SGPh2Gfg9C9aK2wm4uR6ZMsXeh1WD1gWGb-oqgnLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gaetano Mendola <mendola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> post a message receive
> rdma connection
> wait for rdma connection event
> <<at this point transfer tx flow starts>>
> start:
>    register memory containing bytes to transfer
>    wait remote memory region addr/key ( I wait for a ibv_wc)
>    send data with ibv_post_send (IBV_WR_RDMA_WRITE)
>    post a message receive
>    wait for ibv_post_send event ( I wait for a ibv_wc) (this lasts
> 13.3 ms transfering 8MB)

Try spinning for completions, rather than blocking, here...

>    send message "DONE"
>    unregister memory
> goto start
> 
> 
> Passive side:
> 
> post a message receive
> rdma accept
> wait for rdma connection event
> <<at this point transfer rx flow starts>>
> start:
>    register memory that has to receive the bytes
>    send addr/key of memory registered
>    wait "DONE" message

and here.

>    unregister memory

Remove all registration / unregistration calls outside of any performance loop.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
