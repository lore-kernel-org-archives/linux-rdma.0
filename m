From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: rdma-core soon in Debian
Date: Fri, 14 Jul 2017 16:13:11 +0200
Message-ID: <1500041591.3563.31.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi everyone,

a few weeks passed since my last status update regarding rdma-core in
Debian. We made good progress in getting it ready. Only three items are
left:

1) I sent three patches for the ibacm and iwpmd service to the mailing
list. They need to be reviewed and accepted:

$ git log --oneline master..bdrung
c3654500 ibacm: Add systemd service file
562d5a00 iwpmd: Support Debian/Ubuntu in sysvinit service
9744e8d2 ibacm: Fix service start_daemon call on Debian

2) Common infrastructure for auto loading rdma modules: See the "Add
rdma service for kernel boot support" thread on this mailing list.
Jason Gunthorpe made a very good proposal were I made some comments on
it.

3) Get rid of openibd and rdma service dependencies:

$ git grep openibd
ibacm/CMakeLists.txt:set(rdmascript "openibd")
srp_daemon/CMakeLists.txt:set(RDMA_SERVICE "openibd" CACHE STRING
"init.d file service name to order srpd after")
$ git grep rdma.service -- ibacm/
ibacm/ibacm.service.in:Requires=rdma.service
ibacm/ibacm.service.in:After=rdma.service opensm.service

openibd is not part of rdma-core and rdma.service will go away with the
 changes in point 2.


I expect to see progress on these points in the coming days / next
week. When all changes are in master, will we create a new release?
Otherwise I will have to base my upload on v14 and cherry-pick all
relevant changes.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
