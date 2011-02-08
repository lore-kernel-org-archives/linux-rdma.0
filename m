From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rdma_listen() backlog maximum
Date: Tue, 8 Feb 2011 05:51:13 +0200
Message-ID: <AANLkTi==A8pi_EOxJQ8cXi+FF4kz6jmy8Y_SWA2oCz6i@mail.gmail.com>
References: <AANLkTikqiahK1qNc6_wS6X445oUoVUJsE-nd3uC-sPWs@mail.gmail.com>
	<4D4E6112.4060008@voltaire.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25CC26962E@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC26962E-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Mundy <mmundy42-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> The backlog does have an effect for user space. =A0At most backlog co=
nnection request
> events are queued in the kernel. =A0Additional requests that arrive w=
hile the queue is full result > in the request being dropped.

sure, I get it now.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
