From: David Dai <zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: rds-stress command with "-D" option failure.
Date: Mon, 29 Feb 2016 19:47:24 -0600
Message-ID: <1456796846-8596-1-git-send-email-zdai@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

[PATCH 1/2] rds-tools user space part of change for rds-stress -D option failure
[PATCH 2/2] rds kernel space part of change for rds-stress -D option failure

Problem descrption:
The rds-stress command with "-D" optoin causes error.

Hardware: IBM Power 7 box.

OS: RHEL 6.7
# uname -a
Linux juno-ioxc1-lp5.austin.ibm.com 2.6.32-548.el6.ppc64 #1 SMP Sat Mar 28 00:59:47 EDT 2015 ppc64 ppc64 ppc64 GNU/Linux

rds-tools level: rds-tools-2.0.6-3.el6

To recreate:
Server side:
# rds-stress -r 10.1.1.136 -D 1K
waiting for incoming connection on 10.1.1.136:4000
accepted connection from 10.1.1.157:48021
negotiated options, tasks will start in 2 seconds
Starting up..sendto() truncated - 1..
tsks   tx/s   rx/s  tx+rx K/s    mbi K/s    mbo K/s tx us/c   rtt us cpu %
child pid 2762 exited with status 1

Client side:
# rds-stress -r 10.1.1.157 -s 10.1.1.136 -D 1K
connecting to 10.1.1.136:4000
negotiated options, tasks will start in 2 seconds
Starting up..sendto() truncated - 1..
tsks   tx/s   rx/s  tx+rx K/s    mbi K/s    mbo K/s tx us/c   rtt us cpu %
   1      0      0       0.00       0.00       0.00    0.00     0.00 -1.00
child pid 2560 exited with status 1
[root@jupiter-ioxc1-lp5 ~]# echo $?
1


After applying the proposed patch, here is the expected output:
# rds-stress -r 10.1.1.136 -D 1k
waiting for incoming connection on 10.1.1.136:4000
accepted connection from 10.1.1.131:37186
negotiated options, tasks will start in 2 seconds
Starting up....
tsks   tx/s   rx/s  tx+rx K/s    mbi K/s    mbo K/s tx us/c   rtt us cpu %
   1   5850   5710   12224.73    5774.04    5774.04    4.72   163.00 -1.00
   1   5874   5701   12239.82    5780.67    5781.67    4.74   162.37 -1.00
   1   5827   5662   12149.04    5737.79    5738.79    4.61   163.82 -1.00
   1   5860   5702   12230.70    5776.86    5776.86    4.64   162.59 -1.00
   1   5840   5668   12169.24    5747.83    5747.83    4.76   163.16 -1.00
   1   5880   5711   12257.07    5789.82    5788.82    4.80   162.02 -1.00
   1   5884   5726   12277.15    5798.80    5798.80    4.75   161.95 -1.00
   1   5823   5668   12151.27    5739.85    5738.85    4.64   163.80 -1.00
   1   5955   5780   12409.27    5860.71    5861.70    4.65   160.82 -1.00
   1   5799   5620   12075.02    5703.83    5702.83    4.85   164.70 -1.00
   1   5841   5705   12209.26    5765.74    5767.74    4.63   163.24 -1.00
   1   5871   5682   12216.68    5770.74    5769.74    4.62   162.50 -1.00
   1   5876   5720   12262.20    5791.74    5791.74    4.77   162.27 -1.00
   1   5861   5695   12219.90    5771.76    5771.76    4.62   162.41 -1.00
   1   5865   5693   12222.11    5772.81    5772.81    4.83   162.53 -1.00
---------------------------------------------
   1   5854   5690   12220.90    5772.20    5772.27    4.71   162.91 -1.00
(average)
[root@jupiter-ioxc1-lp6 /]#

Client side:
# rds-stress -r 10.1.1.131 -s 10.1.1.136 -D 1k
connecting to 10.1.1.136:4000
negotiated options, tasks will start in 2 seconds
Starting up....
tsks   tx/s   rx/s  tx+rx K/s    mbi K/s    mbo K/s tx us/c   rtt us cpu %
   1   5700   5841   12216.19    5770.51    5769.51    5.83   164.57 -1.00
   1   5684   5857   12215.29    5769.08    5770.08    6.01   165.13 -1.00
   1   5655   5820   12146.00    5737.36    5736.36    5.86   165.91 -1.00
   1   5703   5861   12240.11    5781.31    5781.31    5.88   164.41 -1.00
   1   5671   5841   12185.13    5755.34    5755.34    5.98   165.38 -1.00
   1   5710   5880   12267.62    5794.30    5794.30    6.01   164.19 -1.00
   1   5727   5884   12289.88    5804.32    5805.31    5.90   163.71 -1.00
   1   5654   5811   12135.33    5732.32    5731.32    5.82   165.97 -1.00
   1   5769   5944   12397.86    5856.31    5855.31    5.80   162.32 -1.00
   1   5630   5808   12106.92    5718.37    5719.37    6.07   166.76 -1.00
   1   5694   5828   12195.56    5760.29    5759.29    5.87   164.76 -1.00
   1   5671   5858   12203.10    576
Ctrl-C out
#

In addition to the proposed patch, it's recommened to run proposed patch with the following patch which is already pushed upstream:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5c240fa2ab394af1dbde280e00cc038cbc7f0409

Please let us know if this patch is not submitted to the correct place.
And tell us the the the correct email list if you have it.

Signed-off-by: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Tested-by: David Dai <zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
