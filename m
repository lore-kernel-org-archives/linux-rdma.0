From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Possibly serious bug in ib_mad: processing packets from ibping can
 consume 100% of CPU and may leave user processes locked in umad_recv
Date: Wed, 8 Feb 2012 16:41:43 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5AD8E9A@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

So, take a set of 3 or 4 hosts on a fabric, and run

# ibping -S

on each.

Then, on each, run the ibping client in a loop so that each host sends a few packets to each other host. For example:


# while true; do echo; date; echo; ibping -c 3 -L 3; ibping -c 3 -L 5; ibping -c 3 -L 1; sleep 1; done

What you will discover is that ib_mad on one or more of the hosts will begin consuming 100% of the cpu on that host:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  919 root       1 -19     0    0    0 R 100.0  0.0  29:23.82 ib_mad1

Even more interesting, ib_mad will continue to consume 100% of that cpu core even if the ibping processes are stopped. In fact, you may not be able to completely terminate the ibping processes on the affected machine - they become trapped inside umad_recv().

When in this situation, ib_mad will continue to consume 100% of cpu even if the SM is stopped and all activity on the fabric has been terminated - and even though the HCA is reporting that it is not sending or receiving packets.

This behavior has been demonstrated on 1.5.4 and 1.5.4.1, and on RHEL6.0, 6.1 and 5.7.

I used systemtap to trace ib_mad in an install of OFED 1.5.4.1; filled 15 megs of log in a few seconds. The trace makes it look like a MAD is looping between the receive and send queues:

1328740603      0 ib_mad1(919):-->ib_response_mad
1328740603      2 ib_mad1(919): -->agent_send_response
1328740603      5 ib_mad1(919):  -->ib_create_send_mad
1328740603      7 ib_mad1(919):  <--ib_create_send_mad
1328740603      9 ib_mad1(919):  -->ib_post_send_mad
1328740603     12 ib_mad1(919):   -->ib_send_mad
1328740603     15 ib_mad1(919):   <--ib_send_mad
1328740603     17 ib_mad1(919):  <--ib_post_send_mad
1328740603     19 ib_mad1(919): <--agent_send_response
1328740603     22 ib_mad1(919): -->ib_mad_complete_send_wr
1328740603     24 ib_mad1(919):  -->ib_free_send_mad
1328740603     26 ib_mad1(919):  <--ib_free_send_mad
1328740603     28 ib_mad1(919): <--ib_mad_complete_send_wr
1328740603     30 ib_mad1(919): -->ib_response_mad
1328740603     33 ib_mad1(919):  -->agent_send_response
1328740603     35 ib_mad1(919):   -->ib_create_send_mad
1328740603     37 ib_mad1(919):   <--ib_create_send_mad
1328740603     40 ib_mad1(919):   -->ib_post_send_mad
1328740603     42 ib_mad1(919):    -->ib_send_mad
1328740603     45 ib_mad1(919):    <--ib_send_mad
1328740603     47 ib_mad1(919):   <--ib_post_send_mad
1328740603     49 ib_mad1(919):  <--agent_send_response
1328740603     52 ib_mad1(919):  -->ib_mad_complete_send_wr
1328740603     54 ib_mad1(919):   -->ib_free_send_mad
1328740603     56 ib_mad1(919):   <--ib_free_send_mad
1328740603     59 ib_mad1(919):  <--ib_mad_complete_send_wr
1328740603     61 ib_mad1(919):  -->ib_response_mad
1328740603     63 ib_mad1(919):   -->agent_send_response
1328740603     66 ib_mad1(919):    -->ib_create_send_mad
1328740603     68 ib_mad1(919):    <--ib_create_send_mad
1328740603     70 ib_mad1(919):    -->ib_post_send_mad
1328740603     72 ib_mad1(919):     -->ib_send_mad
1328740603     75 ib_mad1(919):     <--ib_send_mad
1328740603     78 ib_mad1(919):    <--ib_post_send_mad
1328740603     80 ib_mad1(919):   <--agent_send_response
1328740603     82 ib_mad1(919):   -->ib_mad_complete_send_wr
1328740603     85 ib_mad1(919):    -->ib_free_send_mad
1328740603     87 ib_mad1(919):    <--ib_free_send_mad
1328740603     89 ib_mad1(919):   <--ib_mad_complete_send_wr
1328740603     91 ib_mad1(919):   -->ib_response_mad
1328740603     94 ib_mad1(919):    -->agent_send_response
1328740603     96 ib_mad1(919):     -->ib_create_send_mad
1328740603     98 ib_mad1(919):     <--ib_create_send_mad
1328740603    101 ib_mad1(919):     -->ib_post_send_mad
1328740603    103 ib_mad1(919):      -->ib_send_mad
1328740603    106 ib_mad1(919):      <--ib_send_mad
1328740603    109 ib_mad1(919):     <--ib_post_send_mad
1328740603    111 ib_mad1(919):    <--agent_send_response
1328740603    113 ib_mad1(919):    -->ib_mad_complete_send_wr
1328740603    116 ib_mad1(919):     -->ib_free_send_mad
1328740603    118 ib_mad1(919):     <--ib_free_send_mad
1328740603    120 ib_mad1(919):    <--ib_mad_complete_send_wr
1328740603    123 ib_mad1(919):    -->ib_response_mad
.
.
.

I'm going to continue looking at this but I thought it was important enough to post this information now.

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
