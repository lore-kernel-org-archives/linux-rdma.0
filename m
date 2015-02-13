From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 18/22] IB/ipoib: cleanup a couple debug messages
Date: Fri, 13 Feb 2015 18:40:46 +0200
Message-ID: <CAJ3xEMi2yvaL6QGPFXDcJavnnw4Lxk64bdkZnm--FE8NiKQmbg@mail.gmail.com>
References: <cover.1423703861.git.dledford@redhat.com>
	<7aeffef3862526da5a472c15f94564897a4d7537.1423703861.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7aeffef3862526da5a472c15f94564897a4d7537.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 12, 2015 at 3:43 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The one I removed in particular can prevent progress in the driver from
> happening because it isn't rate limited.

So isn't the right thing to do would be to rate-limit that?! note you
need not solve the whole world (ipoib...)
problems for 3.20-rc1, this can be 3.20-rc fix


In my testing, I have seen the
> flood of messages from that debug message delay multicast joins for in
> excess of 30 seconds.
>
> The added debug message was just so I would know when we were leaving a
> multicast group that we didn't fully join.

so squash them to downstream patches of the series?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
