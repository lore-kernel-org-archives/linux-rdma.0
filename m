From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: API for Proposal for adding ib_usa to the Linux Infiniband
 Subsystem
Date: Tue, 10 Aug 2010 14:19:29 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D4355170@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D2CF@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D2CF-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry for the massive lag in this conversation - between trying to balance working with Linux-RDMA with the rest of my job, support problems and vacations, this got pushed to the bottom of my queue while I thought about the best approach to the issue.

When we left this, we were discussing the most appropriate API, with Jason suggesting we go through /dev/*umad* and Sean suggesting leveraging the existing async functions in libibverbs:

> Re: Proposal for adding ib_usa to the Linux Infiniband Subsystem
> Jason Gunthorpe
> Fri, 21 May 2010 12:46:22 -0700
>
> My thinking was sort of:
>
> fd = open("/dev/..umad..");
> ioctl(fd, SUBSCRIBE_TRAP, &trap_description)
> read(fd..); // Events arrive
> close(fd);  // Event is unsubscribed
>
> The reason this fits nicely with umad is that you really actually want
> the GMP trap, not some processed version.. So this is like a multicast
> subscribe in IP.

and...

> RE: API for Proposal for adding ib_usa to the Linux Infiniband Subsystem
> Hefty, Sean
> Tue, 08 Jun 2010 14:23:59 -0700
>
> Would something like this work for you?

> enum ibv_event_type {
>         ...
> +       IBV_EVENT_SA
>         ...
>
> struct ibv_async_event {
>         union {
> +               struct ibv_sa_event *sa_event;
>                 ...
> + int ibv_reg_sa_event(struct ibv_context *context, uint8_t port_num,
>                         uint16_t trap_number);
>
> This would tie in with the libibverbs async event reporting and provide a 
> simple registration API.  (Deregistering would just be done automatically when 
> closing the ibv_context.)

I do like Sean's idea quite a lot since it's simple and ties into an existing async interface rather than requiring a new one - but I've also been wondering about security issues and whether it makes sense for most SA/SM traps to be exposed to end-user applications.

Here's what I mean: the list of traps includes GID in/out of service, MC group traps, Path is no longer valid, security notifications like pkey errors, etcetera. However, only 6 of these are valid for the SA/SM even in theory and it's not clear to me that anything except GID in/out of service and MC group created/deleted are actually implemented in the OpenSM. Plus, I don't think unprivileged applications should have access to the other traps in any case.

So, what I'm wondering is should we simplify things so that the application can only register for GID in/out notifications? If we did this correctly, it would be easy to extend the interface later to add other trap types if the need becomes clear. So, my suggestion for the API would be more like this:

enum ibv_event_type {
        ...
+       IBV_EVENT_GID
        ...
struct ibv_async_event {
        union {
+               struct ibv_gid_event *gid_event;
                ...
+ int ibv_reg_gid_event(struct ibv_context *context, uint8_t port_num);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
