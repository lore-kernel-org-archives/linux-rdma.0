From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch] ib/mlx4: Fix build error on platforms where UL is not 64bit
Date: Thu, 18 Oct 2012 10:33:41 -0700
Message-ID: <CAL1RGDVuOK67Ko7zJGbdTDfzjjqOu5L5xy-etxNcvww3izhrbw@mail.gmail.com>
References: <6517a144c4ab826f66fcde6ac05cfd17d641811c.1350444206.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6517a144c4ab826f66fcde6ac05cfd17d641811c.1350444206.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> -               return  (__force __be64) ((u64) 0xFFFFFFFFFFFFFFFFUL);
> +               return  (__force __be64) ((u64) 0xFFFFFFFFFFFFFFFFULL);

Thanks, applied, although I tweaked the expression

    ((u64) 0xFFFFFFFFFFFFFFFFULL)

to be just

    -1

The final "(__force __be64) -1" should be correct and work right on both
32-bit and 64-bit.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
