From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: librdmacm: select() gives false positive on cm channel file
 descriptor
Date: Thu, 3 Jun 2010 09:06:04 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4634BE@orsmsx501.amr.corp.intel.com>
References: <20100602000456.A4C10225DA@vis06.nas.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100602000456.A4C10225DA-PJ7uzvdTSdjyYnqMeUxRc+1ftBKYq+Ku@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Green <bryan.d.green-NSQ8wuThN14@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Any insights into what the problem might be?
> I can provide code for a simple client and server that demonstrate the
> problem.
> I've been testing on a system with SLES 10, and the librdmacm version
> appears
> to be 1.0.11.

I believe that uDAPL once (or still does) use poll() to check for CQ, async, and communication events, and I'm not aware of any problems with it.  (It may set the fd's to non-blocking though.)  The only thing different on the server side is that it queues connection request events.

Can you post the code?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
