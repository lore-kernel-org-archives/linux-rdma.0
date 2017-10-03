From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [GIT PULL 0/2] infiniband hfi1 PREEMPT_RT_FULL changes
Date: Tue,  3 Oct 2017 12:49:18 -0300
Message-ID: <20171003154920.31566-1-acme@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bigeasy@linutronix.de
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Julia Cartwright <julia@ni.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

Hi,

	Please consider pulling into the linux-4.11.y-rt branch,

	It was tested with a simple netperf script found below (that I
intercepted from PeterZ :-)), systems with default kernel tunables, with
the following results:

# Both machines:
[root@opa0-qa-06 ~]# getconf _NPROCESSORS_ONLN
40
[root@opa0-qa-06 ~]# ./netpeterz 
                  3.10.0-716         3.10.0-716.rt56.644.test   
TCP_SENDFILE-1 :  Avg: 18014.7       Avg: 16443.6
TCP_SENDFILE-10 : Avg:  1691.76      Avg:  2070.77
TCP_SENDFILE-20 : Avg:   833.356     Avg:  1090.62
TCP_SENDFILE-40 : Avg:   409.206     Avg:   560.65
TCP_SENDFILE-80 : Avg:   197.961     Avg:   216.654
TCP_STREAM-1 :    Avg: 21648.3       Avg: 18678.7  
TCP_STREAM-10 :   Avg:  1804.94      Avg:  1683.76
TCP_STREAM-20 :   Avg:   839.943     Avg:   857.156
TCP_STREAM-40 :   Avg:   399.508     Avg:   428.413
TCP_STREAM-80 :   Avg:   191.331     Avg:   203.931
TCP_MAERTS-1 :    Avg: 21363         Avg: 21082.8
TCP_MAERTS-10 :   Avg:  1626.78      Avg:  2145.71
TCP_MAERTS-20 :   Avg:   699.969     Avg:   960.48
TCP_MAERTS-40 :   Avg:   378.719     Avg:   496.143
TCP_MAERTS-80 :   Avg:   183.864     Avg:   251.155
TCP_RR-1 :        Avg: 37258.7       Avg: 27904.7
TCP_RR-10 :       Avg: 14880.6       Avg: 12176.9
TCP_RR-20 :       Avg:  7482.94      Avg:  5964.42
TCP_RR-40 :       Avg:  3762.57      Avg:  2937.66
TCP_RR-80 :       Avg:  1909.16      Avg:  1468.5
UDP_RR-1 :        Avg: 40755.8       Avg: 30205
UDP_RR-10 :       Avg: 15197.6       Avg: 13460.7
UDP_RR-20 :       Avg:  7552.46      Avg:  6553.47
UDP_RR-40 :       Avg:  3798.78      Avg:  3134.96
UDP_RR-80 :       Avg:  1922.08      Avg:  1533.69
UDP_STREAM-1 :    Avg: 18385.7       Avg: 17827.5
UDP_STREAM-10 :   Avg: 27855.9       Avg:  1641.97
UDP_STREAM-20 :   Avg: 11650.8       Avg:  1309.35
UDP_STREAM-40 :   Avg:  3824.01      Avg:   669.287
UDP_STREAM-80 :   Avg:  3465.8       Avg:   441.299
[root@opa0-qa-06 ~]#

[root@opa0-qa-06 ~]# cat netpeterz
#!/bin/bash

addrs="-L 172.31.20.6 -H 172.31.20.5"

for test in TCP_SENDFILE TCP_STREAM TCP_MAERTS ; do
	for i in 1 10 20 40 80 ; do
		echo -n $test-$i ": "
		(
		  for ((j=0; j<i; j++)) ; do
			netperf $addrs -t $test -4 -c -C -l 60 -P0 | head -1 &
		  done
		  wait
		) | awk '{ n++; v+=$5; } END { print "Avg: " v/n }'
	done
done

for test in TCP_RR UDP_RR UDP_STREAM ; do
	for i in 1 10 20 40 80 ; do
		echo -n $test-$i ": "
		(
		  for ((j=0; j<i; j++)) ; do
			netperf $addrs -t $test -4 -c -C -l 60 -P0 | head -1 &
		  done
		  wait
		) | awk '{ n++; v+=$6; } END { print "Avg: " v/n }'
	done
done
[root@opa0-qa-06 ~]#

The following changes since commit 327e86929bbc08ddb4b9bd6d5d222ef052eaa4a8:

  v4.11.12-rt14 (2017-09-22 11:12:56 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git infiniband-4.11.y-rt

for you to fetch changes up to 3f59a2ba5bdbf28f4dfe43fe0b713c7574d2baaa:

  IB/hfi1: Handle packets in the theaded handler only (2017-10-03 12:34:39 -0300)

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      IB/hfi1: Use preempt_{dis,en}able_nort()
      IB/hfi1: Handle packets in the theaded handler only

 drivers/infiniband/hw/hfi1/chip.c     | 10 +++++++---
 drivers/infiniband/hw/hfi1/pio.c      |  2 +-
 drivers/infiniband/hw/hfi1/pio_copy.c |  4 ++--
 3 files changed, 10 insertions(+), 6 deletions(-)
