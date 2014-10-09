From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NFSoRDMA developers bi-weekly meeting minutes (10/9)
Date: Thu, 09 Oct 2014 09:29:15 -0700
Message-ID: <5436B7DB.1050204@oracle.com>
References: <5411D79A.4000908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5411D79A.4000908-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Charles EDWARD Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, jeffrey.c.becker-NSQ8wuThN14@public.gmane.org, Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Attendees:

Yan Burman (Mellanox)
Rupert Dance (Soft Forge)
Steve Dickson (Red Hat)
Chuck Lever (Oracle)
Doug Ledford (RedHat)
Shirley Ma (Oracle)
Sachin Prabhu (RedHat)
Devesh Sharma (Emulex)
Anna Schumaker (Net App)
Steve Wise (OpenGridComputing, Chelsio)

Moderator:
Shirley Ma (Oracle)

NFSoRDMA developers bi-weekly meeting is to help organizing NFSoRDMA development and test effort from different resources to speed up NFSoRDMA upstream kernel work and NFSoRDMA diagnosing/debugging tools development. Hopefully the quality of NFSoRDMA upstream patches can be improved by being tested with a quorum of HW vendors.

Today's meeting notes: (Chuck, SteveD, Yan)
1. Follow-ups for Engineer resource allocation to speed up IB stack review process: in progress.

2. OFED update and bug status (Rupert):
OFED 3.12-1-RC3 is expected to be released next Monday after an update for infinipatch-psm which prevented RHEL 7.0 build.
Thanks for Steve Wise to resolve some NFSoRDMA issues. Two outstanding bugs:

http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2489
"Bug 2489 - System crash during cable pull test with Active NFS-RDMA share"
Bug 2489 is outstanding but is resolved in 3.17 RC6, need to bisect the right patch for OFED 3.12-1.

http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2507
The panic stack reported it's backport patch issue. To confirm that Steve Wise suggested to reproduce it with upstream 3.12 kernel. Devesh will build 3.12 kernel and test it.
 
http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2502
Bug 2502 is RDS bug, which will talk to Oracle directly.

3. mainline kernel update and bug status: (Chuck, SteveW, Devesh)

https://bugzilla.linux-nfs.org/show_bug.cgi?id=269
Bug 269 xfstests generic/113 on NFSv4.1 causes connection drops
It was found in ConnectX-2. The number of outstanding completions is limited to 87. When exceeding this, post_send will fail. The SQ depth is 256. Whether this is a limitation on ConnectX-2? It's better to try on different HCAs to see the difference.

https://bugzilla.linux-nfs.org/show_bug.cgi?id=271
Steve Wise is making progress on this one.

Devesh suggested to use same approach on client side to reduce Server side signaling, he filed a bug to track this to see any performance difference.
https://bugzilla.linux-nfs.org/show_bug.cgi?id=272

4. Bake-a-thon NFSoRDMA conclave update: Chuck, SteveD gave update on 10/8 Linux Enterprise NFSoRDMA
-- RHEL7.0 NFSoRDMA server is disabled, we still couldn't locate resource for NFSoRDMA server maintainer. NFSoRDMA client is supported.
-- NFSoRDMA test strategies and utilities: add NFSoRDMA test
-- NFSoRDMA future directions and features

5. 3.17-rc5 NFSoRDMA performance discussion: (Shirley)
Shirley has presented IOZone WRITE NFS performance numbers for NFSoIPoIB, NFSoRDMA FMR and FRWR mode on connectX-2. The discuss focus was on NFS WRITE. There are couple areas need to do further research:
-- NFS WRITE overhead: what limits NFS WRITE performance in NFS protocol?
-- Unexpected latency increase and BW drop in large I/O write
-- How much gain from IPoIB-CM SG, cheksum offloading patch
-- Yan suggested the test to move to ConnectX-3 since ConnectX-2 is out.

Feel free to reply here for anything missing. See you on Oct.23.

10/9/2014
@7:30am PDT
@8:30am MDT
@9:30am CDT
@10:30am EDT
@Bangalore @8:00pm
@Israel @5:30pm

Duration: 1 hour

Call-in number:
Israel: +972 37219638
Bangalore: +91 8039890080 (180030109800)
France  Colombes +33 1 5760 2222    +33 176728936
US: 8666824770,  408-7744073

Conference Code: 2308833
Passcode: 63767362 (it's NFSoRDMA, in case you couldn't remember)

Thanks everyone for joining the call and providing valuable inputs/work to the community to make NFSoRDMA better.

Shirley
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
