From: Bryan Green <bryan.d.green-NSQ8wuThN14@public.gmane.org>
Subject: Re: librdmacm: select() gives false positive on cm channel file descriptor
Date: Thu, 03 Jun 2010 12:06:51 -0700
Message-ID: <20100603190651.188C02270E@vis06.nas.nasa.gov>
References: <adask54ot0s.fsf@roland-alpha.cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: Your message of "Thu, 03 Jun 2010 13:44:35 CDT."
             <adask54ot0s.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier writes:
> This looks a little suspicious:
> 
>  >     nfds = fds;
>  >     res = select(fdcnt, &nfds, 0, 0, 0);
>  >     if (res == -1) {
>  >         perror("select");
>  >         return -1;
>  >     }
>  >=20
>  >     if (FD_ISSET(cb->cm_channel->fd, &fds)) {
>  >         // got a disconnect event?
> 
> you set nfds to fds, pass &nfds into select() and then check if the
> cm_channel fd is set in the original fds.  Seems wrong to me.

That would be it.  I'll be slinking away in embarrassment now.  I guess I
just needed another pair of eyes.

> Not sure why you need two fd_set variables anyway.  (And IMHO select()
> is obsolete and should never be used ... poll() is a better interface in
> every way, and if you can take a bit more complexity epoll is better still)

The fact that there are two fd_set variables is an artifact from the
original program, which has a bit more complexity.  I thought I had
distilled the code down to the essentials, but I obviously had not.
Thanks for the advise about select.  In what way is select obsolete?

Thanks again,
-bryan

> 
>  - R.
> --
> Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
> http://www.cisco.com/web/about/doing_business/legal/cri/index.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
