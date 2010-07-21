From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: NULL pointer dereference in rdma_ucm
Date: Wed, 21 Jul 2010 11:13:10 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAA57@orsmsx501.amr.corp.intel.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  [<ffffffff88407850>] :rdma_cm:rdma_init_qp_attr+0xed/0x13f
>  [<ffffffff8841725e>] :rdma_ucm:ucma_init_qp_attr+0x97/0xe4
>  [<ffffffff8008a461>] default_wake_function+0x0/0xe
>  [<ffffffff8008a461>] default_wake_function+0x0/0xe
>  [<ffffffff800d66d2>] shmem_file_write+0x23f/0x251
>  [<ffffffff88416326>] :rdma_ucm:ucma_write+0x73/0x91
>  [<ffffffff8001659e>] vfs_write+0xce/0x174
>  [<ffffffff80016e6b>] sys_write+0x45/0x6e
>  [<ffffffff8005d116>] system_call+0x7e/0x83

Here's a guess at what may be happening:

The rdma_cm receives a REQ, in cma_req_handler() we have:

	ret = conn_id->id.event_handler(&conn_id->id, &event);
	if (!ret) {
		/*
		 * Acquire mutex to prevent user executing rdma_destroy_id()
		 * while we're accessing the cm_id.
		 */
		mutex_lock(&lock);
		if (cma_comp(conn_id, CMA_CONNECT) &&
		    !cma_is_ud_ps(conn_id->id.ps))
			ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);

Note that the call to ib_send_cm_mra() is after the event has been reported to the user.  I'm guessing that the connection is getting established before the call to ib_send_cm_mra() is invoked.  ib_send_cm_mra() does this:

	case IB_CM_ESTABLISHED:
		cm_state = cm_id->state;
		lap_state = IB_CM_MRA_LAP_SENT;
		msg_response = CM_MSG_RESPONSE_OTHER;
		break;
	...

	cm_id->state = cm_state;
	cm_id->lap_state = lap_state;
	cm_id_priv->service_timeout = service_timeout;

If the cm_id state is established when ib_send_cm_mra() is called, the lap_state is changed.  This would result in cm_init_qp_rts_attr() incorrectly falling into:

		if (cm_id_priv->id.lap_state == IB_CM_LAP_UNINIT) {
			...
		} else {
---> here

where the alt_av.port would not be set.

If this is what is happening, then removing the call to ib_send_cm_mra() from cma_req_handler() should eliminate the crash.  The drawback is that connections may begin timing out under load, but it may be worth trying.  I'll see if I can come up with a better fix.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
