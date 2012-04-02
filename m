From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't return EINVAL from sysfs rate attribute
 for invalid speeds
Date: Mon, 2 Apr 2012 22:48:24 +0300
Message-ID: <CAJZOPZJQg=CQ99zUB5EL-oRFWo4yoHFimSwRHtZGdJx4kjMfjw@mail.gmail.com>
References: <CAL1RGDVH28u1tY3K8Mw29wfzXVeYR-mNDDvfpABsoSTmZA56Ww@mail.gmail.com>
	<1333395332-17982-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1333395332-17982-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 2, 2012 at 10:35 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> I think I'd rather just add this, to get back closer to the original
> behavior even for non-fixed drivers (but I'll still merge the mlx4
> patch, since that makes sense too).

okay, makes sense
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
