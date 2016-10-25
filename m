From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 8/8] IB/mlx5: Add helper mlx5_ib_post_send_wait
Date: Tue, 25 Oct 2016 18:16:17 +0530
Message-ID: <CAHv-k_8nb4LOXYN1z5Ee9SKkPjZcnHxSBYCX8OcDA+Bcx3SP9Q@mail.gmail.com>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
 <1477396919-27669-9-git-send-email-binoy.jayan@linaro.org> <5098701.SVmQeRIiho@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5098701.SVmQeRIiho@wuerfel>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 25 October 2016 at 17:53, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> On Tuesday, October 25, 2016 5:31:59 PM CEST Binoy Jayan wrote:
> Looks reasonable.

Thank you Arnd for looking at it again.

> Did you get a warning about 'bad' being unused here? I would have
> guessed not, since the original code was not that different and
> it does get passed into a function.

I remembered getting a warning like that, but when i remove the unused
attribute now, it does not. It was probably a side effect of some other error.
Will change it.

> Why not move the umr_context variable into this function too?
> The only thing we ever seem to do to is initialize it and
> assign the wr_cqe pointer, both of which can be done here.

I guess it could be done.

Binoy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
