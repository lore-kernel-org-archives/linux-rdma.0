From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: better understanding rdma-cm UNREACHABLE/ETIMEDOUT scheme
Date: Tue, 21 May 2013 18:07:31 +0300
Message-ID: <519B8DB3.3010500@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dina Leventol <dinal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

We have a user space application which is made of M (clients) x N 
(servers) RC connectivity pattern using librdmacm. Basically, there are 
N nodes, each running M client process and each client connects to all N 
servers.

So under some unknown conditions, many of the clients connection 
attempts fail with RDMA_CM_EVENT_UNREACHABLE event and the status is 
-ETIMEDOUT.  Looking on the rdma-cm kernel code, I see that the only 
location which generates this event is in cma_ib_handler when getting 
IB_CM_REQ_ERROR (or IB_CM_REP_ERROR).

Digging down into the CM, I see that the only place where 
IB_CM_REQ_ERROR is delivered is on cm_process_send_error which is called 
when the status of mad send completion is not success or flush.

Digging down into the MAD code and the CM usage of it,  I see that that 
the mad code will issue a mac send completion handler with the 
IB_WC_RESP_TIMEOUT_ERR status, and that the CM code programs the number 
of retries set by its consumer (rdma-cm in this case) into the mad send 
buffer.

Running this over an M=8 and N=4setup, e.g four nodes, each running one 
server process and eight client processes and sampling the IB CM 
counters before and after the job and adding the numbers from the four 
nodes, we see the following

cm_tx_msgs.req = 395
cm_tx_retries.req= 270
cm_rx_msgs.req= 390

cm_tx_msgs.rep= 375
cm_tx_retries.rep= 255
cm_rx_msgs.rep= 380

cm_tx_msgs.rtu= 108
cm_rx_msgs.rtu= 103

cm_tx_msgs.mra= 540
cm_rx_msgs.mra= 270
cm_tx_retries.mra= 270

In cm_send_handler we see that the CM TX retry counter is incremented 
with the number of retries reported
by the MAD layer, I also see that the RDMA-CM programs the CM to do 15 
retries and the CM further programs this into the MAD send buffers.

 From the RTU counters its clear that at most ~100 connections got 
established out of 128.

One thing seen in the nodes dmesg is a message from an old patch of 
yours which exists in ofed1.5.3 but didn't hit (or wasn't accepted?) 
upstream saying "ib_cm: calculated mra timeout 67584 > 8192, decreasing 
used timeout_ms" does this provides any insight into the problem?

One more piece of info, is that this apps doesn't call rdma_disconnect 
at all, when they are done or if something goes wrong (e.g that 
unreachable event) they simply issue rdma_destroy_id which when I look 
on the rdma-cm/cm code gets to a CM function whic sends a dreq (if the 
ID is in the established state) and puts the ID in the timewait zone.

So it seems we're not loosing mads, also on the stack they use (that 
1.5.3) the ucma backlog size is 128
but each server process gets only 32 request (8x4) so we don't think 
ucma dropping REQs as of no more backlog budget takes place.

Or.







--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
