From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 2/4] rsockets: retry for completion events upon
 interruption
Date: Wed, 17 Sep 2014 16:27:05 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DD4395@ORSMSX109.amr.corp.intel.com>
References: <66c7c361d03a72de6a216fd1d6ffa0bc@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <66c7c361d03a72de6a216fd1d6ffa0bc-FJGp5E75HVmZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +resume_get_cq_event:
>   	ret = ibv_get_cq_event(rs->cm_id->recv_cq_channel, &cq, &context);
>   	if (!ret) {
>   		ibv_ack_cq_events(rs->cm_id->recv_cq, 1);
>   		rs->cq_armed = 0;
> +	} else if (restart_onintr == 1 && errno == EINTR) {
> +		errno = 0;
> +		goto resume_get_cq_event;

I'm not convinced that this is desirable behavior.  If the thread waiting for an event was interrupted, why does it make sense to ignore the interrupt and return to waiting?  Couldn't the app detect the return code and call back into rsockets in this case?

If this is desired behavior, why add a config option?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
