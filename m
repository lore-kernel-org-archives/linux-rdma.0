From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSoRDMA developers bi-weekly meeting minutes (10/23)
Date: Thu, 23 Oct 2014 16:51:28 -0400
Message-ID: <BB90989C-EBAD-4831-9E19-47D2F970AC97@oracle.com>
References: <54496910.1020100@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54496910.1020100-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dominique.martinet-KCE40YydGKI@public.gmane.org, jeffrey.c.becker-NSQ8wuThN14@public.gmane.org, rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org, skc-YOWKrPYUwWM@public.gmane.org, sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Shirley-

One correction below:


On Oct 23, 2014, at 4:46 PM, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> Attendees:
> 
> Steve Dickson (Red Hat)
> Chuck Lever (Oracle)
> Doug Ledford (RedHat)
> Shirley Ma (Oracle)
> Sachin Prabhu (RedHat)
> Anna Schumaker (Net App)
> Steve Wise (OpenGridComputing, Chelsio)
> 
> Moderator:
> Shirley Ma (Oracle)
> 
> NFSoRDMA developers bi-weekly meeting is to help organizing NFSoRDMA development and test effort from different resources to speed up NFSoRDMA upstream kernel work and NFSoRDMA diagnosing/debugging tools development. Hopefully the quality of NFSoRDMA upstream patches can be improved by being tested with a quorum of HW vendors.
> 
> Today's meeting notes:
> 1. OFED update and bug status (Rupert):
> -- Intel has discovered some issues with infinipath-psm and is working on an update so there will have to be an OFED 3.12-1 rc4
> -- Vlad (Mellanox) has agreed to put together the next version of OFED which will be based on kernel 3.18 rc1. This will be ready will be ready to use in the OFA Interop Debug event next week. This will allow us to test some of these NFSoRDMA bugs that are outstanding.
> 
> 2. NFS 4.1 RDMA client support (Chuck)
> Chuck has submitted the patchset to upstream review. The patch includes bi-directional RPC xprt support and sidecar client support, default is TCP to handle backchannel if not specified in mounting option.

In this patch set, NFSv4.1 backchannel is handled by a separate
TCP connection from the client. The patch set does not include bi-
directional RPC/RDMA support. The e-mail thread below is about
whether it should implement bi-directional RPC/RDMA instead of
using a separate TCP connection.

> Patchset is under review, here is the link:
> http://www.spinics.net/lists/linux-nfs/msg47278.html
> -- NFS 4.1 enables pNFS
> -- bi-redictional RDMA
> 
> 3. Performance tools and test I/O block size:
> -- RPC GETATTR, LOOKUP, ACCESS, READ, WRITE latency are more important than other RPCs: mountstats ouput
> -- I/O latency changes with heavy CPU workload (like kernel build)
> -- direction I/O performance, tmpfs, ramdisk, big file size equal to 80% of physical memory
> -- 8K block size performance in particular for database workload
> -- mixed block size performance
> -- benchmark tools: fio, iozone, dbench, connecthon, xfstest...
> -- scalability: number of mountpoints, number of clients
> 
> 4. RDMA emulate driver for testing if no HW is available: (Steve Wise)
> -- soft iwarp: repo is 
> https://www.gitorious.org/softiwarp/ (maintainer Bernard Metzler)
> 
> 5. Whether we can use RDMA write for both NFS write/read to improve the performance?
> 
> Feel free to reply here for anything missing. See you on Nov.6th.
> 
> 10/23/2014
> @7:30am PDT
> @8:30am MDT
> @9:30am CDT
> @10:30am EDT
> @Bangalore @8:00pm
> @Israel @5:30pm
> 
> Duration: 1 hour
> 
> Call-in number:
> Israel: +972 37219638
> Bangalore: +91 8039890080 (180030109800)
> France  Colombes +33 1 5760 2222    +33 176728936
> US: 8666824770,  408-7744073
> 
> Conference Code: 2308833
> Passcode: 63767362 (it's NFSoRDMA, in case you couldn't remember)
> 
> Thanks everyone for joining the call and providing valuable inputs/work to the community to make NFSoRDMA better.
> 
> Cheers,
> Shirley

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
