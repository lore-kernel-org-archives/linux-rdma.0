From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: IB errors with openMPI
Date: Sun, 21 Feb 2010 21:46:53 -0800
Message-ID: <4B821A4D.2000409@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We are trying run openMPI with OFED-1.5 on the 2.6.31-rt11-preempt-rt kernel and see the following errors:

[[45393,1],8][../../../../../ompi/mca/btl/openib/btl_openib_component.c:2951:handle_wc]
from elm3b107 to: elm3b17 error polling HP CQ with status WORK REQUEST FLUSHED
ERROR status number 5 for wr_id 1289846528 opcode -1782678528  vendor error 244
qp_idx 0

At this point I looked at the mlx4 diag counters and saw some non-zero values. Since we were attempting 
a series of runs, we don't know when the counters increased from 0. Do these counters have any correlation 
to the above MPI error?

[root@elm3b17 diag_counters]# pwd
/sys/class/infiniband/mlx4_0/diag_counters
[root@elm3b17 diag_counters]#

[root@elm3b17 diag_counters]# cat rq_num_rnr
19
[root@elm3b17 diag_counters]# cat rq_num_wrfe 
2009
[root@elm3b17 diag_counters]# cat sq_num_tree 
12
[root@elm3b17 diag_counters]# cat sq_num_wrfe
12
[root@elm3b17 diag_counters]#

Similarly on 3b107 let us look at the counters.

[root@elm3b107 diag_counters]# cat rq_num_wrfe
5156
[root@elm3b107 diag_counters]# cat sq_num_rnr
18
[root@elm3b107 diag_counters]# cat sq_num_tree
20
[root@elm3b107 diag_counters]# cat sq_num_wrfe
20
[root@elm3b107 diag_counters]#


We are using ConnectX dual port DDR HCAs (FW version 2.6). What does the vendor error 244 mean? Any suggestions to 
debug this further?

Thanks
Pradeep
