From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: API for Proposal for adding ib_usa to the Linux Infiniband
 Subsystem
Date: Tue, 8 Jun 2010 14:24:39 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE7DE@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D2CF@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D2CF-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Now, given that this API is stand-alone right now, it could still be added
> to either libibumad or to libibverbs - but I like Sean's suggestion that it
> be added to verbs, since the current security model restricts libibumad to
> root access and because the existing API already makes use of libibverbs'
> ibv_context data structure.

Did we ever reach any consensus on this? 

> int ibv_sa_register_inform_info(struct ibv_sa_event_channel *channel,
>                                 struct ibv_context *device, uint8_t
> port_num,
>                                 uint16_t trap_number, void *context,
>                                 struct ibv_sa_id **id);

Would something like this work for you?

enum ibv_event_type {
	...
+	IBV_EVENT_SA
	...

struct ibv_async_event {
        union {
+		struct ibv_sa_event *sa_event;
		...

+ int ibv_reg_sa_event(struct ibv_context *context, uint8_t port_num,
			uint16_t trap_number);

This would tie in with the libibverbs async event reporting and provide a simple registration API.  (Deregistering would just be done automatically when closing the ibv_context.)

Roland, do you have any thoughts about extending libibverbs/uverbs in this way?

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
