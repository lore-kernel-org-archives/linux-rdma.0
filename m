From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/4] IP based RoCE GID Addressing
Date: Fri, 14 Jun 2013 23:35:15 +0300
Message-ID: <CAJZOPZKMf+HOompez2+3rkqz7jCS=-HEJo9q0quZOc8i7KpLmQ@mail.gmail.com>
References: <1371135704-5712-1-git-send-email-ogerlitz@mellanox.com>
	<20130613170011.GA21570@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130613170011.GA21570-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> Can you talk abit about compatibility please? What happens when nodes
> with this patch are on the same network as nodes without it?

The CM on the passive side would send a reject with the reason being
"invalid gid" so this will not go unnoticed.


> Does this patch remove the encoding of the VLAN from the GID?

YES, and I explained in argument #1 why the vlan being there doesn't
work in many environments, in other words, its something that needs to
be fix, and this series addresses that.


> How is the destination MAC derived now?

as it was before, using address resolution, e.g ARPs sent by the RDMA-CM.


> There is a RoCE standard, it doesn't say much, but how the MAC and GRH
> GID are related/derived really should be specified...
>
> Not sure about copying the IP/IPv6 address from the interface into the
> HW, there has always been pressure to keep verbs separate from the net
> stack.. At the very least patch #2 should have its change log updated
> to actually reflect what is in the patch.

Sure, I'll see what needs to be better explained in the change-log.
Note that the inbox RoCE implementation is tightly coupled to
net-devices, e.g the GID table population is based on netevents of
related netdevices.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
