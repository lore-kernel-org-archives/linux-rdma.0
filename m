From: "Xiaoyi Lu-DXvelMOp12CVc3sceRu5cw@public.gmane.org" <luxi-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: RDMA (InfiniBand and RoCE) Support for Hadoop 1.2.1
Date: Tue, 12 Nov 2013 23:42:19 -0500
Message-ID: <CAO+LYDWk+vUQvfd=1q1UKwvJzbbDkqMsQWb_7LMGiccHLf4K6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Hadoop-RDMA team is pleased to announce the release of Hadoop-RDMA 0.9.8
(technology preview) package with the following features and bug-fixes:

* Hadoop-RDMA 0.9.8 Features

   - Based on Apache Hadoop 1.2.1
   - High performance design with native InfiniBand and RoCE support
     at the verbs-level for HDFS, MapReduce, and RPC components
   - Compliant with Apache Hadoop 1.2.1 APIs and applications
   - Easily configurable for native InfiniBand, RoCE and the traditional
     sockets-based support (Ethernet and InfiniBand with IPoIB)
   - HDFS over native InfiniBand and RoCE
       - RDMA-based write
       - RDMA-based replication
       - Tuned packet size
   - MapReduce over native InfiniBand and RoCE
       - RDMA-based shuffle
       - Pre-fetching and caching of map outputs
       - In-memory merge
       - Overlapping of merge and reduce
   - RPC over native InfiniBand and RoCE
       - JVM-bypassed buffer management
       - On-demand InfiniBand connection setup
       - RDMA or send/recv based adaptive communication
   - Tested with
       - Mellanox InfiniBand adapters (DDR, QDR, and FDR)
       - RoCE
       - Various multi-core platforms
       - Different file systems with disks and SSDs

* Bug Fixes (since 0.9.1)

   - MapReduce over InfiniBand
     - Reducing the waiting time for the pre-fetch cache read
     - Enabling Reduce tasks to randomize the shuffle pattern
   - HDFS over InfiniBand
     - Fix an issue in processing multiple blocks concurrently in a
       single task

For downloading Hadoop-RDMA 0.9.8 package and the associated user guide,
please visit the following URL:

http://hadoop-rdma.cse.ohio-state.edu

Sample performance numbers for benchmarks using Hadoop-RDMA 0.9.8
version can be viewed by visiting the `Performance' tab of the above website.

All questions, feedbacks and bug reports are welcome. Please post it
to the hadoop-rdma-discuss mailing list (hadoop-rdma-discuss at
cse.ohio-state.edu).

Thanks,

The Hadoop-RDMA Team
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
