From: =?GB2312?B?yPu2+9PjZHd5YW5l?= <dwyane.hust-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: ibv_get_cq_event blocking forever after successful ibv_post_send...
Date: Fri, 17 Dec 2010 13:49:59 +0800
Message-ID: <AANLkTik4jPegBM_YgGsE93JHgA5+pc7VDg5ERGM8LVcv@mail.gmail.com>
References: <AANLkTik3nryZrNBYGXwf45zYjYJcQ9ciwpS=NEVNitjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik3nryZrNBYGXwf45zYjYJcQ9ciwpS=NEVNitjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 mine is a single cs mode program.
 client keep on send messages to server, afte a certain number of
 times, the server just block in ibv_get_cq_event.
 the client receive no reply and keep waiting.if manually stop client,
 server get a completion with wc.status is IBV_WC_WR_FLUSH_ERR.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
