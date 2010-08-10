From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: API for Proposal for adding ib_usa to the Linux Infiniband
 Subsystem
Date: Tue, 10 Aug 2010 12:43:05 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9600FA9@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D2CF@MNEXMB1.qlogic.org>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D4355170@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D4355170-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> enum ibv_event_type {
>         ...
> +       IBV_EVENT_GID
>         ...
> struct ibv_async_event {
>         union {
> +               struct ibv_gid_event *gid_event;
>                 ...
> + int ibv_reg_gid_event(struct ibv_context *context, uint8_t port_num);

We need to get Roland's thoughts on this, since he maintains libibverbs.  As just a thought, I think you can still use a more generic API with kernel checks to verify that an application has permission to register for certain types of events.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
