From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: question on the timewait event of the rdma-cm
Date: Mon, 14 Nov 2011 19:16:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9AA8E@ORSMSX101.amr.corp.intel.com>
References: <4EC13EE9.1070103@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EC13EE9.1070103-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'm debugging some disconnect related race in iser - and wanted to check
> with you something re the CM/RDMA-CM state machine: I see that when a
> disconnected is initiated by the passive side (iser target) of a
> connection, such that the active side (iser initiator) gets
> RDMA_CM_EVENT_DISCONNECTED, later we call rdma_disconnect (e.g to move
> the QP into error state, send DREP, etc) - SOMETIMES the active side
> gets also RDMA_CM_EVENT_TIMEWAIT_EXIT event, AFAIK this should happen
> if the rdma-cm ID isn't destroyed within X time, correct? if yes, so
> what is that X? if this description isn't accurate what would be the
> correct phrasing for the condition to get the timewait event?

After disconnecting, the QP should enter the timewait state for twice the packet lifetime.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
