From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 10/12] IB/mlx5: Fix reported max SGE calculation
Date: Fri, 18 Nov 2016 00:36:08 +0200
Message-ID: <CAJ3xEMh0pZAJYjJcG8swbEOg-gcbrAx2-BtQ+iXK6NEn_wQa7A@mail.gmail.com>
References: <1477575407-20562-1-git-send-email-leon@kernel.org> <1477575407-20562-11-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-11-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 27, 2016 at 3:36 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add the 512 bytes limit of RDMA READ and the size of remote
> address to the max SGE calculation.
>
> Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')

Doug, for some reason the above line is different in the commit
present @ your git hub tree, bug somewhere?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
