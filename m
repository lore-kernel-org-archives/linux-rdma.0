From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma_listen() backlog maximum
Date: Thu, 3 Feb 2011 09:26:10 -0800
Message-ID: <AANLkTi=Po2LAPQj9hqHarTW7aO7Er5YsswmUfr5X9bPs@mail.gmail.com>
References: <AANLkTikqiahK1qNc6_wS6X445oUoVUJsE-nd3uC-sPWs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikqiahK1qNc6_wS6X445oUoVUJsE-nd3uC-sPWs-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Mundy <mmundy42-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 3, 2011 at 8:40 AM, Mike Mundy <mmundy42-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I'm prototyping a server that needs to accept a large number of
> simultaneous incoming RDMA CM connections. I noticed that
> drivers/infiniband/core/ucma.c limits the backlog to 128. Is there a
> reason why the limit is 128? Or to put it another way, what breaks if
> the limit is increased to a larger value (say 256)?

In the current kernel the backlog defaults to 1024 and there is a sysctl to
change it at runtime.

So I think you are completely safe increasing your backlog on older
kernels.  (The commit to backport is 97cb7e40c696)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
