From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: librdmacm: select() gives false positive on cm channel file descriptor
Date: Thu, 03 Jun 2010 11:44:35 -0700
Message-ID: <adask54ot0s.fsf@roland-alpha.cisco.com>
References: <20100603183338.229F222BCB@vis06.nas.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100603183338.229F222BCB-PJ7uzvdTSdjyYnqMeUxRc+1ftBKYq+Ku@public.gmane.org> (Bryan Green's
	message of "Thu, 03 Jun 2010 11:33:38 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Green <bryan.d.green-NSQ8wuThN14@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This looks a little suspicious:

 >     nfds = fds;
 >     res = select(fdcnt, &nfds, 0, 0, 0);
 >     if (res == -1) {
 >         perror("select");
 >         return -1;
 >     }
 > 
 >     if (FD_ISSET(cb->cm_channel->fd, &fds)) {
 >         // got a disconnect event?

you set nfds to fds, pass &nfds into select() and then check if the
cm_channel fd is set in the original fds.  Seems wrong to me.

Not sure why you need two fd_set variables anyway.  (And IMHO select()
is obsolete and should never be used ... poll() is a better interface in
every way, and if you can take a bit more complexity epoll is better still)

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
