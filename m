From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: CMA handler status code
Date: Tue, 27 Jul 2010 01:11:11 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A8D7FBFB@orsmsx501.amr.corp.intel.com>
References: <AANLkTik2eOWELUAwjL+tfjMb28L3OjWB57iMyvDpOWDm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik2eOWELUAwjL+tfjMb28L3OjWB57iMyvDpOWDm-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eldad Zinger <eldadz-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> drivers/infiniband/core/cma.c : 2204
> drivers/infiniband/core/cma.c : 976
> 
> event.status = ib_event->param.sidr_rep_rcvd.status
> event.status = ib_event->param.rej_rcvd.reason

The original intent was to expose the transport specific status values to the user, rather than trying to map them.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
