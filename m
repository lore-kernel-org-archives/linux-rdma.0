From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Dapltest test error DAT_CONN_QUAL_IN_USE
Date: Fri, 23 Nov 2012 13:54:09 +0000
Message-ID: <BE1D1D812551174182F280D7A4AEC90B357C04@nice.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Kumar A S <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Abhishek Agrawal <abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

I was running dapltest between my client and server machines with OFED-3.5. While running the test it dapltest server throws an error DAT_CONN_QUAL_IN_USE if I increase number of threads and endpoints.

Dapltest server:
--------------- 
dapltest -T S -D chelsio1

Dapltest client:
---------------
dapltest -T T -s 102.1.1.2 -D chelsio1 -R BE -i 1 -t 16 -w 8 server SR 8192 4 client SR 8192 4


Once I run the above test i get the following error on server side and client side stalls.

$# dapltest -T S -D chelsio1
Dapltest: Service Point Ready - chelsio1
Test[b13f]: dat_psp_create #6 error: DAT_CONN_QUAL_IN_USE
Test[b13f]: Warning: dat_ep_disconnect (abrupt) #0 error DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE DAT_INVALID_STATE_EVD_IN_USE
Test[b13f]: Warning: dat_ep_disconnect (abrupt) #1 error DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE DAT_INVALID_STATE_EVD_IN_USE
Test[b13f]: Warning: dat_ep_disconnect (abrupt) #2 error DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE DAT_INVALID_STATE_EVD_IN_USE
Test[b13f]: Warning: dat_ep_disconnect (abrupt) #3 error DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE DAT_INVALID_STATE_EVD_IN_USE
Test[b13f]: Warning: dat_ep_disconnect (abrupt) #4 error DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE DAT_INVALID_STATE_EVD_IN_USE
Test[b13f]: Warning: dat_ep_disconnect (abrupt) #5 error DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE DAT_INVALID_STATE_EVD_IN_USE
Test[b13f]: Warning: dat_ep_disconnect (abrupt) #6 error DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED

Following link says DAT_CONN_QUAL_IN_USE error can come if rdma_cm returns an error due to bind failure. 
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01297.html

rdma_cm from OFED-3.5 does not provide module parameter 'unify_tcp_port_space'. So, just to narrow down I installed OFED-1.5.4.1 and ran the same test with unify_tcp_port_space=1. However with that also I was able to reproduced the same issue.

Please note that if I decrease the numbers of endpoints to 4 then test works fine. i.e. If I give '-w 4' instead of '-w 8' in command line then test runs fine.

I am using dapltest version 2.0.36 which comes from OFED-3.5.

Can anyone give any pointers on this?


Thanks,
Vipul
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
