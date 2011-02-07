From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma_listen() backlog maximum
Date: Mon, 7 Feb 2011 09:54:21 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC26962E@orsmsx501.amr.corp.intel.com>
References: <AANLkTikqiahK1qNc6_wS6X445oUoVUJsE-nd3uC-sPWs@mail.gmail.com>
 <4D4E6112.4060008@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D4E6112.4060008-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Mike Mundy <mmundy42-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> My understanding is that with the current cma/cm code, under IB/IBoE
> the backlog has no impact, in that environment, you're practically
> limited by the mad layer ability to receive the REQ mads. Sean, am I
> correct?

The backlog does have an effect for user space.  At most backlog connection request events are queued in the kernel.  Additional requests that arrive while the queue is full result in the request being dropped.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
