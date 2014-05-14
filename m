From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NFSoRDMA developers bi-weekly meeting summary (5/14)
Date: Wed, 14 May 2014 11:57:09 -0700
Message-ID: <5373BC85.3030804@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, Allen Andrews <Allen.Andrews-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "<yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>" <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, David Stevens <dls0904-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Cayton, Phil" <phil.cayton-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Attendees:
Allen Andrews (Emulex)
Jeff Beck (NASA)
Yan Burman (Mellanox)
Wendy Cheng (Intel)
Rupert Dance (Soft Forge)
Chuck Lever (Oracle)
Doug Ledford (RedHat)
Shirley Ma (Oracle)
Anna Schumaker (Net App)
Steve Wise (OpenGridComputing, Chelsio)

Moderator:
Shirley Ma (Oracle)

NFSoRDMA developers bi-weekly meeting is to help organizing NFSoRDMA 
development and test effort from different resources to speed up 
NFSoRDMA upstream kernel work and NFSoRDMA diagnosing/debugging tools 
development. Hopefully the quality of NFSoRDMA upstream patches can be 
improved by being tested by a quorum of HW vendors.

Today's meeting notes:
1. Flesh out the process for testing and reviewing upstream patch sets:

What kind of test cases to run?
The upstream patch sets are required to test and pass functional test 
suites. In long run, performance test suites will be required. The 
performance test suites will be added later. Link to NFSoRDMA test wiki:
http://wiki.linux-nfs.org/wiki/index.php/NfsRdmaClient/Home#Submitting_patches 


How would linux-nfs git tree help NFSoRDMA patch sets upstream to 
mainline kernel?
Steve Wise will create linux-nfs NFSoRDMA server git tree with the help 
from Anna Schumaker. Chuck Lever's client branch git tree includes all 
client patch sets to be tested. Anna Schumaker maintains all client 
patches to be pulled into upstream which have passed the test suites 
(Sign-off: Tested-by). Steve Wise will create a branch to include both 
client and server patch sets in case you use the same node for both 
client and server.

How these tests to be done?
Each developer has his/her own hardware to test before submitting the 
patch sets. IOL has a broad variety of hardware, Rupert Dance would 
check how they can help in additional to OFED stack test. The test build 
process will be defined later.

2. Identify a long term resource for maintaining the linux NFSoRDMA server

Oracle has allocated resource to support NFSoRDMA client. Linux 
community needs funds to support NFSoRDMA server. There are engineer 
resources but not the money. Any third parties are interested in 
supporting NFSoRDMA server?

3. Follow ups from last meeting:

NFSoRDMA debugging and diagnosis tools?
Yan has started to look at NFSoRDMA dissector. Chelsio packets can be 
monitored when turning on switch port mirroring.
Chuck has created linux-nfs bugzilla for NFSoRDMA: server component is 
"svcrdma", client component is "xprtrdma" . Here is the link for you to 
check/submit bugs
https://bugzilla.linux-nfs.org/

4. NFSoRDMA visualization validation:
Yan and Shirley are working on validating ConnectX SRIOV on both Xen and 
KVM. They hit couple issues which need further debugging.

Next meeting topics proposal:
1. Follow up the work has been discussed from this meeting.

2. Walk through some of the stories on pivotal, link is as below:
https://www.pivotaltracker.com/s/projects/958376

3. Invite some of the developers to discuss some of their requirements 
and features.

Meeting time: one hour discussion every other Wed (next meeting will be 
on 5/14). A reminder will be sent out to both linux-nfs and linux-rdma 
mailing list:

5/28/2014
@8:00am PST
@9:00am MST
@10:00am CST
@11:00am EST
@Bangalore @9:00pm
@Israel @6:00pm

Duration: 1 hour

Call-in number:
Israel: +972 37219638
Bangalore: +91 8039890080 (180030109800)
US: 8666824770,  408-7744073
Conference Code: 2308833
Passcode: 63767362 (it's NFSoRDMA, in case you couldn't remember)

Thanks everyone for joining the call and providing valuable inputs/work 
to the community to make NFSoRDMA better.

Shirley
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
