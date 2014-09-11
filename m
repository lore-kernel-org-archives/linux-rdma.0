From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NFSoRDMA developers bi-weekly meeting minutes (9/11)
Date: Thu, 11 Sep 2014 10:10:50 -0700
Message-ID: <5411D79A.4000908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Charles EDWARD Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org" <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dominique.martinet-KCE40YydGKI@public.gmane.org" <dominique.martinet-KCE40YydGKI@public.gmane.org>, "jeffrey.c.becker-NSQ8wuThN14@public.gmane.org" <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "skc-YOWKrPYUwWM@public.gmane.org" <skc-YOWKrPYUwWM@public.gmane.org>, "sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Attendees:

Yan Burman (Mellanox)
Wendy Cheng (Intel)
Rupert Dance (Soft Forge)
Steve Dickson (Red Hat)
Chuck Lever (Oracle)
Doug Ledford (RedHat)
Shirley Ma (Oracle)
Devesh Sharma (Emulex)
Anna Schumaker (Net App)
Steve Wise (OpenGridComputing, Chelsio)
Dominique Martinet(CEA France)

Moderator:
Shirley Ma (Oracle)

NFSoRDMA developers bi-weekly meeting is to help organizing NFSoRDMA development and test effort from different resources to speed up NFSoRDMA upstream kernel work and NFSoRDMA diagnosing/debugging tools development. Hopefully the quality of NFSoRDMA upstream patches can be improved by being tested with a quorum of HW vendors.

Today's meeting notes:
1. Merge plan for 3.18, 3.19 (Chuck, Steve):
-- Bug fixes from NFSoRDMA bugzilla 
	- https://bugzilla.linux-nfs.org/buglist.cgi?quicksearch=rdma
	- shutdown issue problem from unmount point (Devesh/Chuck)
-- NFS 4.1 support: 
	- Server and client are under testing, Oracle is doing client/server interoperability test
	- Bi-directional RPCs
	- backchannel, second transport TCP

2. Linux development tree unbootable with IPoIB for nearly one month. (Chuck,Doug/SteveD,Yan)
-- How to help upstream test and stable
	- Any vendors can fund UNH to zero-day Linux upstream test?
	- Allocate Engineer resource to help reviewing code to speed up upstream acceptance?
-- Discussed about NFSoRDMA dependency of IPoIB (Wendy)

3. Performance issues arising (SteveW, Shirley)
-- Scalability test for 4 - 16 clients, each client has 4 mount points
-- Single eventQ bottle neck after splitting send/recv queue completion, two eventQ per QP
-- How to avoid inconsistent performance evaluation: hyper threads, NUMA, cache ...
-- RDMA vs. IPoIB iWARP, ROCE performance test

4. UNL interoperability bug discussion between PPC (64K page) and X86 (4K page) (Rupert, Chuck, SteveW)
-- http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2494
   - cloned https://bugzilla.linux-nfs.org/show_bug.cgi?id=270
	
Actions:
1. Chuck talks to Oracle for possibility to join OFLG and fund UNH for linux development tree test
2. Allocate Engineer resource to help reviewing upstream code and speed up the process: RedHat (Doug), Mellanox(Yan),Oracle(Chuck)

Feel free to reply here for anything missing. See you 9/25.

9/11/2014
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
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
