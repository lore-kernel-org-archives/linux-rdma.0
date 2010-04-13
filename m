From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Socket Direct Protocol: help (2)
Date: Tue, 13 Apr 2010 09:28:14 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1246722.1271082830120.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd@cis
List-Id: linux-rdma@vger.kernel.org

>I add that in kernel space SDP debug the error is:
>
>command line: dmesg
>sdp_init_qp:95 sdp_sock( 2100:2 40720:0): recv sge's. capability: 4
>needed: 9
>sdp_init_qp:95 sdp_sock( 2100:2 41203:0): recv sge's. capability: 4
>needed: 9
>
>The structure sdp_init_qp() is defined in
>/usr/src/ofa_kernel-1.5.1/drivers/infiniband/ulp/sdp/sdp_cma.c (lines 76
>- 141)

NE020 supports 4 SGEs.  I don't know enough about SDP to know why it is
using this calculation for # of send_sge:

#define SDP_MAX_RECV_SKB_FRAGS (PAGE_SIZE > 0x8000 ? 1 : 0x8000 / PAGE_SIZE)


>Could be a firmware problem?

This is not a firmware problem.

Chien


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
