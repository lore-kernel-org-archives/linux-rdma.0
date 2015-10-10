From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/iser: Enable SG clustering
Date: Sat, 10 Oct 2015 22:35:17 +0300
Message-ID: <CAJ3xEMg3xuNvpetNzmKo2b2QcybjD2v-9ht6Mddw5N+tDeNVxw@mail.gmail.com>
References: <1444436822-6632-1-git-send-email-sagig@mellanox.com>
	<1444436822-6632-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444436822-6632-3-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 10, 2015 at 3:27 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> iser can handle it and it can dramatically reduce the
> number of SG elements. It doesn't make much of a difference at
> the moment,

Right, b/c we would go and break these SGs to 4k chunks.


> but with arbitrary SG list support it will benefit greatly.

Y? please put some wording here to clarify.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
