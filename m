From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/8] IPoIB: Make the carrier_on_task race aware
Date: Tue, 19 Aug 2014 15:05:45 -0700
Message-ID: <CABgxfbEYa0inGuN5u0Eck5v96FUpzeTPrUV5ytqm6swp+7t-Hg@mail.gmail.com>
References: <cover.1407885724.git.dledford@redhat.com>
	<d05cdce70f1312f35f8be2d14bafd2a06809b137.1407885724.git.dledford@redhat.com>
	<CABgxfbE6edfZZ58=mTvhGqWSkCxsik0XuQPR0L-yayze=803cg@mail.gmail.com>
	<2CC1794B-10CD-49A2-8F5D-0C66A6684DBC@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2CC1794B-10CD-49A2-8F5D-0C66A6684DBC-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 19, 2014 at 1:32 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Whether or not the core network code is OK with us dropping the rtnl lock while manipulating the interface is the issue here.  However, I did consider changing the mcast_mutex to a per interface lock instead.  The are various optimizations that can be made now that the locking is correct and race free and that we don't flush from the workqueue we are flushing.  I didn't go into those changes in this set.  As for 20ms, I did that because checkpatch complains about shorter waits and I don't like to busy loop, especially since it's not like this is a performance sensitive section of code.
>

I'm acking this patch for now. However, I want to remind everyone that
rntl is a "BIG" global lock that has been used by other net devices
such as Ethernet. It is particularly troublesome for us since the
IPOIB needs to co-exist with Ethernet interface that has non-trivial
amount of traffic as well. Imaging everyone tries to bring their
interfaces up/down all together in a large cluster environment that
needs to worry about power consumption. It would be "cool" if we can
see less of this lock !

Acked-by: Wendy Cheng <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
