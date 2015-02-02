From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: CUDA not working with ib_write_bw
Date: Mon, 2 Feb 2015 09:59:10 -0600
Message-ID: <000f01d03f01$2eb315b0$8c194110$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Bates <Stephen.Bates-PwyqCcigF0Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Gil,

I'm trying to test iWARP RDMA <-> GPU memory and I compiled CUDA into the top-o-tree perftest repo.  My Nvidia setup is working
because I have verified it with another gpu rdma package (donard from pmc).  But when using ib_write_bw the server gets an error
registering the gpu memory with the device.  Below is the output from ib_write_bw.  I instrumented the kernel registration path and
I find that get_user_pages() is returning -14 (-EFAULT) when called by ib_umem_get(). 

Q:  Is this supposed to work with the upstream RDMA drivers?   I'm using a 3.16.3 kernel.org kernel.

Thanks,

Steve
---

[root@stevo1 perftest]# ./ib_write_bw -R --use_cuda

************************************
* Waiting for client to connect... *
************************************
---------------------------------------------------------------------------------------
                    RDMA_Write BW Test
 Dual-port       : OFF          Device         : cxgb4_1
 Number of qps   : 1            Transport type : IW
 Connection type : RC           Using SRQ      : OFF
 CQ Moderation   : 100
 Mtu             : 1024[B]
 Link type       : Ethernet
 Gid index       : 0
 Max inline data : 0[B]
 rdma_cm QPs     : ON
 Data ex. method : rdma_cm
---------------------------------------------------------------------------------------
 Waiting for client rdma_cm QP to connect
 Please run the same command with the IB/RoCE interface IP
---------------------------------------------------------------------------------------
initializing CUDA
There is 1 device supporting CUDA
[pid = 14124, dev = 0] device name = [Tesla K20Xm]
creating CUDA Ctx
making it the current CUDA Ctx
cuMemAlloc() of a 131072 bytes GPU buffer
allocated GPU buffer address at 0000001304260000 pointer=0x1304260000
Couldn't allocate MR
 Unable to create the resources needed by comm struct
Unable to perform rdma_client function
[root@stevo1 perftest]#

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
