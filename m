From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NFSoRDMA developers bi-weekly meeting minutes (6/11)
Date: Fri, 13 Jun 2014 08:40:33 -0700
Message-ID: <539B1B71.40208@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "<Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>" <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "<yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>" <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Attendees:

Jeff Beck (NASA)
Susan Coulter (LANL)
Rupert Dance (Soft Forge)
Chuck Lever (Oracle)
Doug Ledford (RedHat)
Shirley Ma (Oracle)
Devesh Sharma (Emulex)
Anna Schumaker (Net App)
Steve Wise (OpenGridComputing, Chelsio)

Moderator:
Shirley Ma (Oracle)

NFSoRDMA developers bi-weekly meeting is to help organizing NFSoRDMA development and test effort from different resources to speed up NFSoRDMA upstream kernel work and NFSoRDMA diagnosing/debugging tools development. Hopefully the quality of NFSoRDMA upstream patches can be improved by being tested by a quorum of HW vendors.

Today's meeting notes:
1. Rupert gave an update of OFED 3.12-1 
OFED 3.12-1 will support RedHat 7.0. It will include Intel MPSS OFED packages and Intel Xeon support, recent NFSoRDMA patches from Shirley, Chuck, which Jeff has backported, Steve Wise Chelsio code as well as Intel iWARP code. OFED 3.12-1 will be GAed in 1-2 month. It will be backword compatible with RHEL7.

2. Follow-up on last week's soft RoCE / soft iWARP discussion
Chuck Lever gave an update of Soft RoCE, which has no update and no resource for maintenance, only userspace memory registration, therefore our kernel NFSoRDMA implementation is not supported
Steve Wise gave an update of Soft iWARP, which has been used with our kernel NFSoRDMA implementation before, and will be merged to upstream soon.

3. Reviews of patches going into 3.16
Anna has checked in Chuck's 24 client patches, Steve Wise refactoring patch for large I/O is also in the upstream merge tree.
Devesh has run cthon and IOzone test of 3.15 kernel and all the tests have been passed, no issue found.
Good news, the most recent upstream NFSoRDMA is much more stable now!

4. Anna gave an update on upstream merge process. Developers will test/validate the QA tree branch Steven is going to build again RC2 or later based up Chuck's client tree and Steve's server tree. Anna will pull patches once the patches blessed by developers. Trond/Bruce can merge these patches to upstream.

5. Jeff gave an update of merging NFSoRDMA patches into OFED-3.12-1. Jeff will manually pull Steve Wise patches into OFED tree.

6. Shirley still had trouble to make guest VF working for NFSoRDMA. There was no SRIOV test in IOL lab. Rupert will pass SRIOV questions Shirley raised to get help from Mellanox.

Meeting time: one hour discussion every other Wed (next meeting will be
on 6/25). A reminder will be sent out to both linux-nfs and linux-rdma
mailing list:

6/25/2014
@8:00am PST
@9:00am MST
@10:00am CST
@11:00am EST
@Bangalore @8:00pm
@Israel @6:00pm

Duration: 1 hour

Call-in number:
Israel: +972 37219638
Bangalore: +91 8039890080 (180030109800)
US: 8666824770,  408-7744073
Conference Code: 2308833
Passcode: 63767362 (it's NFSoRDMA, in case you couldn't remember)

Thanks everyone for joining the call and providing valuable inputs/work to the community to make NFSoRDMA better.

Shirley
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
