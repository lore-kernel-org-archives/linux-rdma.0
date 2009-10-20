From: stuarts <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Subject: Multicast joins failing on 1.5-rc1?
Date: Tue, 20 Oct 2009 13:16:07 -0500
Message-ID: <A5E1097A-DFEA-4508-A47F-FF07C34EA525@routingdynamics.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



We have a four  box cluster that we just upgraded to RHEL5.4. This  
required an upgrade to the 1.5 version of OFED. We are using bonding  
over two physical links and ipoib. The final detail is that we are  
using IPv4 multicast to push data from 1 box to the other 3.

Under 1.4, this worked. (Yeah!)
Under 1.5, it doesn't.

By "not working" I mean:
  o IB is able to see the mesh.
  o IPv4 over the bond is working (I can ping, scp files, and similar)
  o Multicast does NOT.

When I looked closer, I can see that I get an error -22 on the  
multicast joins (using a qlogic switche's SM) for everything _except_  
the broadcast join.  I switched over to opensm, since it has far  
better debugging abilities and see the same behavior, though the error  
code is opensm logs a message with error 1B11.

When I look through for the code, I found that error code associated  
with an invalid set of component masks:
Oct 20 12:40:05 824130 [44240940] 0x01 -> mcmr_rcv_join_mgrp: ERR  
1B11: method = SubnAdmSet, scope_state = 0x1, component mask =  
0x0000000000010083, expected comp mask = 0x00000000000130c7, MGID:  
ff12:601b:ffff::16 from port 0x0002c90300032431 (x3 HCA-1)

I looked through drivers/infiniband/ulp/ipoib/ipoib_multicast.c and  
found the following interesting bits:
  o The broadcast join is done with the presumption the broadcast  
groups already exist (and they do)
  o In ipoib_mcast_send() data path, ipoib_mcast_sendonly_join() is  
called directly (the multicast task is not used). This path, however,  
does not set the required component_mask bit to clear the 1B11 check  
(check_create_comp_mask())

I looked at the git log (from ofed_kernel_1_5) for ipoib_multicast.c  
and don't see any commits that would appear to be anywhere near this  
area.

Does anyone have any clue to what is going on here?  Thank you, --stuart

p.s. the output from the debugfs:
[root@x3 ipoib]# pwd
/sys/kernel/debug/ipoib
[root@ce-x3 ipoib]# more ib0_mcg
GID: ff12:401b:ffff:0:0:0:0:3a01
   created: 4295351581
   queuelen:         0
   complete:        no
   send_only:      yes

GID: ff12:401b:ffff:0:0:0:ffff:ffff
   created: 4295326209
   queuelen:         0
   complete:       yes
   send_only:       no

--
Stuart Stanley
M: 952-457-3790
stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org
--
"The avalanche has started. It is too late for the pebbles to vote." -  
Kosh in Babylon 5:"Believers"

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
