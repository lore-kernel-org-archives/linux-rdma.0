From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: IB / MLX setup issues
Date: Mon, 3 May 2010 15:24:11 -0700
Message-ID: <DE26A35E22BF4C659D3A3708CEE1843C@amr.corp.intel.com>
References: <4BDF48BB.4070209@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BDF48BB.4070209-YJJp1DzrooEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Todd Strader' <tstrader-YJJp1DzrooEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Also, and I'm unsure if this is related, the link between machines C and
>A is in the initializing state when I bring up the machine.  Machine A
>has the subnet manager running, so I would think that should be enough.
>If I run another subnet manager on machine C, I get an active link, but
>I wouldn't think I need to be running two subnet managers.

Assuming directly connected links between machines A <-> C and A <-> B, then
these are separate subnets and each requires a subnet manager.  The SM is bound
to a specific port when run, so one instance of the SM is not enough.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
