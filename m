From: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Sun, 29 Oct 2017 14:35:23 -0500
Message-ID: <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA@mail.gmail.com>
References: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg@mail.gmail.com>
 <20171029191114.GO16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171029191114.GO16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 29, 2017 at 2:11 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Do you have CONFIG_SECURITY_INFINIBAND in your .config?
>
> Thanks
>

Hello,

CONFIG_SECURITY_INFINIBAND is enabled on my kernel. All infiniband
config settings can be found here [0].

Thanks,
Chris Blake

[0]: https://gist.github.com/riptidewave93/b3b83c13e93ab3be4254c855885f5b3a
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
