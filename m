From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: When is it safe to release connection resources?
Date: Wed, 4 Jan 2012 16:04:33 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823732566B26E@ORSMSX101.amr.corp.intel.com>
References: <4EFC987B.6070901@list-group.com>
 <1828884A29C6694DAF28B7E6B8A8237325662B63@ORSMSX102.amr.corp.intel.com>
 <4F041F19.1070608@list-group.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F041F19.1070608-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> So in order to safely call ibv_destroy_cq, I should call ibv_ack_cq_events
> *after* ibv_poll_cq? The example on the man
> page for ibv_get_cq_event calls it before, is it an error?

You should call ibv_ack_cq_events after ibv_get_cq_events but before ibv_destroy_cq.  That can come before or after calling ibv_poll_cq.  And, although it's probably easiest to call ack after get, note that you don't need a 1:1 call ratio between get/ack.  You can keep a count of the number of times that ibv_get_cq_events returns a specific cq, and then call ibv_ack_cq_events for that amount just before calling ibv_destroy_cq.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
