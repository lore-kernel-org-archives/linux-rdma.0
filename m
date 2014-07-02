From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NFSoRDMA developers bi-weekly meeting minutes (6/25)
Date: Wed, 02 Jul 2014 09:11:22 -0700
Message-ID: <53B42F2A.9060205@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry for being late, I just found this email wasn't out. Please add what's missing.

Attendees:

Rupert Dance (Soft Forge)
Chuck Lever (Oracle)
Doug Ledford (RedHat)
Shirley Ma (Oracle)
Anna Schumaker (Net App)
Steve Wise (OpenGridComputing, Chelsio)
Steve Dickson (RedHat)

Jeff is busy on OFED stack work, others are on vacation

Moderator:
Shirley Ma (Oracle)

NFSoRDMA developers bi-weekly meeting is to help organizing NFSoRDMA development and test effort from different resources to speed up NFSoRDMA upstream kernel work and NFSoRDMA diagnosing/debugging tools development. Hopefully the quality of NFSoRDMA upstream patches can be improved by being tested by a quorum of HW vendors.

Today's meeting notes:
1. Follow ups from last week:
Steve has created a test git tree for client and server patches that are heading upstream so interested parties can test out. Here is the link to the git tree for testing:

The branch is named for-test and the repo is at: 
git://git.linux-nfs.org/projects/swise/linux.git

2. Rupert gave an update for NFSoRDMA patches to be included in the coming OFED-3.12-1 release which is targeted in July. Jeff has ported all patches from upstream tree, UNL is testing these patches to see any regression.

3. Chuck created destructive test patch to inject IB verbs errors randomly in NFSoRDMA. This can easily trigger NFSoRDMA bugs. This approach can simulate cable plug/unplug, rpcrdma connect/reconnect stale resource issue... This patch will benefit developers for testing and debugging. Steven mentioned Chelsio has similar test method in userspace.

4. Discussed about Chuck's most recent xprtrdma patchset to upstream, decided to the reference count to memory window buffer list patch is not needed.

5. Shirley discussed NFSoRDMA performance anaylysis tools to measure CPU, bandwidth, latency, lock, interrupts rate, memory foot print. Suggestion is to use current lock_stat, perf to report/monitor cpu, lock statistics, use nfsstat to report NFS statistics first; Shirley suggested to add more statistics in RDMA operations for performance analysis. Shirley will write some documentation on performance analysis tool.

6. NFSoRDMA virtualization doesn't work. Shirley found that VF FRMR reported port error after a successful post_send on connextX-2. It didn't seem an NFSoRDMA issue. Questions are whether VF FRMR is fully tested. Later Yan confirmed VF FRMR doesn't work for NFSoRDMA on connectX-3 either.

7. Mike reported that NFSoRDMA doesn't show same performance as SMB for fio test. Shirley is able to reproduce it, Steve will ask Chelsio engineer to test it as well.

Meeting time: one hour discussion every other Wed (next meeting will be
on 7/6). A reminder will be sent out to both linux-nfs and linux-rdma
mailing list:

6/25/2014
@8:00am PST (summer time)
@9:00am MST (summer time)
@10:00am CST (summer time)
@11:00am EST (summer time)
@Bangalore @8:00pm
@Israel @6:00pm

Duration: 1 hour

Call-in number:
Israel: +972 37219638
France 	Colombes +33 1 5760 2222 	+33 176728936
Bangalore: +91 8039890080 (180030109800)
US: 8666824770,  408-7744073

Conference Code: 2308833
Passcode: 63767362 (it's NFSoRDMA, in case you couldn't remember)

Thanks everyone for joining the call and providing valuable inputs/work to the community to make NFSoRDMA better.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
