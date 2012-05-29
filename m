From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: NFS/RDMA connection establish/break in loop
Date: Tue, 29 May 2012 13:35:10 -0500
Message-ID: <4FC516DE.1000706@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

When we try to establish a connection with NFS RDMA server, we get the 
following messages with debug enabled -

[ 2937.577657] RPC:       rpcrdma_conn_upcall: established: 
192.168.1.13:20049 (ep 0xffff88012f980628 event 0x9)
[ 2937.597566] RPC:       rpcrdma_conn_upcall: connected
[ 2937.597569] RPC:  6385 __rpc_wake_up_task (now 4295627490)
[ 2937.597572] RPC:  6385 disabling timer
[ 2937.597576] RPC:  6385 removed from queue ffff88012f9802f0 "xprt_pending"
[ 2937.597580] RPC:       __rpc_wake_up_task done
[ 2937.597586] RPC:  6385 sync task resuming
[ 2937.597592] rpcrdma: connection to 192.168.1.13:20049 on mlx4_0, 
memreg 5 slots 32 ird 4
[ 2937.597597] RPC:  6385 marshaling NULL cred ffffffffa0437c60
[ 2937.597603] RPC:  6385 using AUTH_NULL cred ffffffffa0437c60 to wrap 
rpc data
[ 2937.597607] RPC:       rpcrdma_ep_connect: connected
[ 2937.597611] RPC:  6385 sleep_on(queue "xprt_pending" time 4295627490)
[ 2937.597615] RPC:       xprt_rdma_connect_worker: exit
[ 2937.597620] RPC:  6385 added to queue ffff88012f9802f0 "xprt_pending"
[ 2937.597625] RPC:  6385 setting alarm for 60000 ms
[ 2937.597631] RPC:  6385 sync task going to sleep
[ 2937.597812] RPC:       rpcrdma_qp_async_error_upcall: QP error 3 on 
device mlx4_0 ep ffff88012f980628
[ 2937.597817] RPC:  6385 __rpc_wake_up_task (now 4295627490)
[ 2937.597818] RPC:  6385 disabling timer
[ 2937.597821] RPC:  6385 removed from queue ffff88012f9802f0 "xprt_pending"
[ 2937.597824] RPC:       __rpc_wake_up_task done
[ 2937.597830] RPC:       rpcrdma_event_process: event rep 
ffff880139eb7000 status 5 opcode FFFFFFFF length 4294936578
[ 2937.597833] RPC:       rpcrdma_event_process: recv WC status 5, 
connection lost
[ 2937.597841] RPC:  6385 sync task resuming
[ 2937.597844] RPC:  6385 sleep_on(queue "xprt_pending" time 4295627490)
[ 2937.597846] RPC:  6385 added to queue ffff88012f9802f0 "xprt_pending"
[ 2937.597848] RPC:  6385 setting alarm for 60000 ms
[ 2937.597850] RPC:  6385 sync task going to sleep
[ 2937.598207] RPC:       rpcrdma_conn_upcall: disconnected: 
192.168.1.13:20049 (ep 0xffff88012f980628 event 0xa)
[ 2937.598210] RPC:       rpcrdma_conn_upcall: disconnected
[ 2937.598213] rpcrdma: connection to 192.168.1.13:20049 closed (-103)
[ 2967.547845] RPC:       xprt_rdma_connect_worker: reconnect
[ 2967.558976] RPC:       rpcrdma_ep_disconnect: after wait, disconnected
[ 2967.561651] RPC:       rpcrdma_conn_upcall: 4 responder resources (1 
initiator)

This keeps looping until mount is cancelled.
Looking at the code, rpcrdma_qp_async_error_upcall is called with 
event=3 (IB_EVENT_QP_ACCESS_ERROR) and the device name is mlx4_0
This is initated from mlx4_ib_qp_event and it is receiving 
MLX4_EVENT_TYPE_WQ_ACCESS_ERROR.

What could cause this mlx4 driver unable to access the WQ or raise such 
an interrupt? I checked setup of qp in mlx4_ib_create_qp and it returns 
success.

This is SLES11SP1 - kernel 2.6.32.59-0.3

-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
