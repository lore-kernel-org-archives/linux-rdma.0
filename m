From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 12/12] IB/mlx5: Limit mkey page size to 2GB
Date: Fri, 28 Oct 2016 16:02:09 +0300
Message-ID: <CAJ3xEMidqSMWs5TsxC9KBNcc_Li4nH9sb_-oUg-cKz8D_VtEdw@mail.gmail.com>
References: <1477575407-20562-1-git-send-email-leon@kernel.org> <1477575407-20562-13-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-13-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 27, 2016 at 4:36 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The maximum page size in the mkey context is 2GB.
>
> Until today, we didn't enforce this requirement in the code,
> and therefore, if we got a page size larger than 2GB, we

got a page size larger than 2GB? who are those pages?

> have passed zeros in the log_page_shift instead of the actual value
> and the registration failed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
