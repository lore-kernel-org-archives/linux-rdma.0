From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NFSoRDMA bi-weekly developers meeting minutes (4/16/15)
Date: Thu, 16 Apr 2015 12:00:15 -0700
Message-ID: <553006BF.6050306@oracle.com>
References: <53BC2123.4070206@oracle.com> <54063CB7.6060503@oracle.com> <54C7D09D.3000600@oracle.com> <54C937BA.9020606@oracle.com> <552EE56E.5060705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552EE56E.5060705-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "<Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>" <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "<yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>" <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Attendees:


Jeff Becker (NASA)
Wendy Cheng (Intel)
Chuck Lever (Oracle)
Doug Ledford (RedHat)
Shirley Ma (Oracle)
Anna Schumaker (Net App)
Steve Wise (OpenGridComputing, Chelsio)

Today's meeting notes:

NFSoRDMA server support:
-----------------------
NFSoRDMA Server is still technology preview in RHEL 7.2, since customers are looking for Linux NFSoRDMA server support, there is possible to open NFSoRDMA server support in the future. Jeff from NASA has some plan to deploy Linux NFSoRDMA, Mellanox OFED stack release might not support it, move to upstream OFED 3.18 is an option. Their fabrics is InfiniBand.

NFSoRDMA test plan (Doug, Wendy, Chuck)
------------------
Doug talked about future NFSoRDMA test infrastructure in RedHat. He has completed SCSI disk drivers characterization, the BW is around 3.9GB/s, next is file system, then NFSoRDMA and storage RDMA. Performance work will be investigated in both HW and software stack to see where to optimize it. He is open to take inputs on which particular file system to test, people can give suggests on which file systems they are interested. Chuck suggested NFSoRDMA performance work should include tempfs test since persistent disk is too slow for NFSoRDMA transport layer performance evaluation. The fabrics is mixed with DDR, QDR and EDR.
  
Wendy also talked about the possibility NFSoRDMA test in Intel. Currently they don't include NFSoRDMA in SPECNFS test, she asked whether it's possible to include it. Chuck replied the test client doesn't support NFSoRDMA client. He will talk to the maintainer to see whether NFSoRDMA can be supported, but needs to good reason to add it. Intel's test set up is RHEL 7.1, if enables NFSoRDMA test, the kernel should move to 3.18.

NFS bake-a-thon planning: (Doug, Chuck)
-------------------------
Chuck and Doug talked about incoming bake-a-thon plan, Doug has a small IB test et up, he can bring it to test. Solaris requires particular HCAs to work. They will talk to SteveD about several different possibilities to make it work.

NFSoRDMA performance: (Shirley, Chuck, SteveW)
---------------------
>From ftrace function-graph report, both large I/O workload and intensive CPU workload showed that the interrupts and scheduling are two key contributes to NFS operations (READ, WRITE, GETATTR...). In CPU intensive workload like make kernel in the background, wake_up_bit is too costly. Is that possible to replace wake_up_bit? Chuck mentioned that it used to be wait queue, wake up queue. We could try it to see any performance difference. To reduce the interrupts, Shirley is trying to see the performance gain from disabling interrupts and wait a bit, there are some throughput gain with heavy cpu utilization. She will continue to investigate it. Chuck has tried to move completion up call from CQ to WQ context. There is no more items queuing in receiving queue, only saw one or two. SteveW repli
 ed that the queue should be built in this scenarios. Shirley thinks without addressing the scheduling issue in this workload, it might not be possible to see any other improvement.

Doug works on performance evaluation work in his large system test bed. He will set up more accurate baseline performance, then investigate where to optimized in the stack as well as the HW.

We are looking for good tools to simulate real workloads, like database workload. Right now we are using fio to simulate. We need to define real workloads. If anybody has any suggestion, that would be great. Shirley will send a separated email thread to discuss it.

Storage RDMA technology (Shirley, Chuck, Doug)
-----------------------
Whether can we use this call to cover iSCSI/iSER/SRP work? The performance issues will be different, however both of they use RDMA as transport, so it might be helpful to discuss storage RDMA work here as long as NFSoRDMA is still the focus and we have time to discuss about the work.


Feel free to reply here for anything missing or incorrect. Thanks everyone for joining the call and providing valuable inputs/work to the community to make NFSoRDMA better.

Cheers,
Shirley




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
