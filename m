From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: better understanding rdma-cm UNREACHABLE/ETIMEDOUT scheme
Date: Tue, 21 May 2013 15:24:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD29AE3@ORSMSX109.amr.corp.intel.com>
References: <519B8DB3.3010500@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519B8DB3.3010500-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dina Leventol <dinal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> So under some unknown conditions, many of the clients connection
> attempts fail with RDMA_CM_EVENT_UNREACHABLE event and the status is
> -ETIMEDOUT.  Looking on the rdma-cm kernel code, I see that the only
> location which generates this event is in cma_ib_handler when getting
> IB_CM_REQ_ERROR (or IB_CM_REP_ERROR).

Does the server continue to run and accept connections during the running of this test?
 
> Digging down into the CM, I see that the only place where
> IB_CM_REQ_ERROR is delivered is on cm_process_send_error which is called
> when the status of mad send completion is not success or flush.
> 
> Digging down into the MAD code and the CM usage of it,  I see that that
> the mad code will issue a mac send completion handler with the
> IB_WC_RESP_TIMEOUT_ERR status, and that the CM code programs the number
> of retries set by its consumer (rdma-cm in this case) into the mad send
> buffer.

Correct - it appears that the connection requests are timing out.
 
> Running this over an M=8 and N=4setup, e.g four nodes, each running one
> server process and eight client processes and sampling the IB CM
> counters before and after the job and adding the numbers from the four
> nodes, we see the following

This is such a small number of nodes/clients, that it shouldn't be related to scaling.  The normal timeout/retry mechanism should work fine.
 
> cm_tx_msgs.req = 395
> cm_tx_retries.req= 270
> cm_rx_msgs.req= 390
> 
> cm_tx_msgs.rep= 375
> cm_tx_retries.rep= 255
> cm_rx_msgs.rep= 380
> 
> cm_tx_msgs.rtu= 108
> cm_rx_msgs.rtu= 103
> 
> cm_tx_msgs.mra= 540
> cm_rx_msgs.mra= 270
> cm_tx_retries.mra= 270
> 
> In cm_send_handler we see that the CM TX retry counter is incremented
> with the number of retries reported
> by the MAD layer, I also see that the RDMA-CM programs the CM to do 15
> retries and the CM further programs this into the MAD send buffers.
> 
>  From the RTU counters its clear that at most ~100 connections got
> established out of 128.
> 
> One thing seen in the nodes dmesg is a message from an old patch of
> yours which exists in ofed1.5.3 but didn't hit (or wasn't accepted?)
> upstream saying "ib_cm: calculated mra timeout 67584 > 8192, decreasing
> used timeout_ms" does this provides any insight into the problem?

I don't remember this patch at all.  The upstream kernel will respond to duplicate CM REQs by sending an MRA, which should increase the connection timeout.  This was added to handle servers which were slow to accept connection requests.

> One more piece of info, is that this apps doesn't call rdma_disconnect
> at all, when they are done or if something goes wrong (e.g that
> unreachable event) they simply issue rdma_destroy_id which when I look
> on the rdma-cm/cm code gets to a CM function whic sends a dreq (if the
> ID is in the established state) and puts the ID in the timewait zone.

Calling rdma_disconnect shouldn't matter.  Destroy will send the DREQ/DREP if the user hasn't disconnected.
 
> So it seems we're not loosing mads, also on the stack they use (that
> 1.5.3) the ucma backlog size is 128
> but each server process gets only 32 request (8x4) so we don't think
> ucma dropping REQs as of no more backlog budget takes place.

My first guess is that the server isn't responding to new requests.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
