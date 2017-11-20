From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 1/5] verbs: Introduce thread domain and its
 related verbs
Date: Mon, 20 Nov 2017 16:05:16 +0200
Message-ID: <CAFgAxU9YoEN51rNwsbn+zDpMqUY-YeMRk8d4qz1cS9yGozJMjw@mail.gmail.com>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-2-git-send-email-yishaih@mellanox.com> <20171113195822.GD22610@ziepe.ca>
 <3719edfc-282a-db5b-2474-3cf1355fb301@dev.mellanox.co.il> <20171114191754.GI4263@ziepe.ca>
 <774e2f74-8361-6941-a015-27a2014d8cc9@dev.mellanox.co.il> <20171117184248.GN4276@ziepe.ca>
 <CAFgAxU_m=i9kG1h2Rbqe+YtVYpea8-Ez5qvm6dQU4tZPgOUqhA@mail.gmail.com> <20171119153219.GZ4276@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171119153219.GZ4276-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 19, 2017 at 5:32 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> On Sun, Nov 19, 2017 at 08:43:16AM +0200, Alex Rosenbaum wrote:
>
> So I'd like to see:
>
>   struct ibv_parent_domain_init_attr {
> -         struct ibv_pd *pd; /* referance to a protection domain, or NULL */
> +         struct ibv_pd *pd; /* referance to a protection domain, can not be NULL */
>
> And even if we did use the PD for consistency, it doesn't hurt at all
> to pass in a PD&TD to the CQ object and then have the CQ ignore the
> PD portion.

I see no problem with this direction.
We'll take it to next step now.

Thanks,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
