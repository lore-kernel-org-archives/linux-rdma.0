From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: question on the timewait event of the rdma-cm
Date: Mon, 14 Nov 2011 18:16:41 +0200
Message-ID: <4EC13EE9.1070103@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean,

I'm debugging some disconnect related race in iser - and wanted to check 
with you something re the CM/RDMA-CM state machine: I see that when a 
disconnected is initiated by the passive side (iser target) of a 
connection, such that the active side (iser initiator) gets 
RDMA_CM_EVENT_DISCONNECTED, later we call rdma_disconnect (e.g to move 
the QP into error state, send DREP, etc) - SOMETIMES the active side 
gets also RDMA_CM_EVENT_TIMEWAIT_EXIT event, AFAIK this should happen  
if the rdma-cm ID isn't destroyed within X time, correct? if yes, so 
what is that X? if this description isn't accurate what would be the 
correct phrasing for the condition to get the timewait event?

Or.

the call to rdma_disconnect was made on jiffies count 4295608818

> Nov 14 17:57:50 iser: iser_cma_handler:event 10 status 0 conn 
> ffff88060c8fb2b0 id ffff88061054dc00 jiffies 4295608742
> Nov 14 17:57:50 connection399:0: detected conn error (1011)
> Nov 14 17:57:50 iser: iser_disconnected_handler:more 32 rx 1 tx 
> completions to reap
> Nov 14 17:57:50 iser: iscsi_iser_ep_disconnect:ib conn 
> ffff88060c8fb2b0 state 3 jiffies 4295608818
> Nov 14 17:57:51 Kernel reported iSCSI connection 399:0 error (1011) 
> state (3)
> Nov 14 17:57:52 iser: iser_cma_handler:event 15 status 0 conn 
> ffff88060c8fb2b0 id ffff88061054dc00 jiffies 4295609333
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
