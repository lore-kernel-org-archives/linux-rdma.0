From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: update the official rdma git repo
Date: Tue, 12 May 2015 16:30:44 +0300
Message-ID: <CAJ3xEMj6Hz+C=-CWwkefE+eDtcpUx=q74FhBbk-H2D+sOu2U_w@mail.gmail.com>
References: <2936ae04aa5d7ebfd9921e363a8e8686f8bb5936.1431393236.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2936ae04aa5d7ebfd9921e363a8e8686f8bb5936.1431393236.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 12, 2015 at 4:13 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Linus prefers kernel.org repos to github repos for security.
>
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 40c14f14204d..c1911a7adb4f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5048,7 +5048,7 @@ M:        Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>  L:     linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  W:     http://www.openfabrics.org/
>  Q:     http://patchwork.kernel.org/project/linux-rdma/list/
> -T:     git git://github.com/dledford/linux.git
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git

Hi Doug,

Could you upload your for-4.2 branch from github to the new spot?

Also, re the series from Michael, is the review done or still some open issues?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
