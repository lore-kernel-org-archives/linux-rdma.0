From: Usha Srinivasan <usha.srinivasan-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: ib receive completion error
Date: Tue, 9 Nov 2010 13:22:28 -0600
Message-ID: <7866DA1F8D2D4541B87FEE88E633ABAA2BBE305046@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,
Can someone from Mellanox tell me what the vendor error 0x32 means?   I am getting this error for wc.opcode 128 (IB_WC_RECV) wc.status 4 (IB_WC_LOC_PROT_ERR).  I am running ofed 1.5.2 and am getting it on both rhel5 and sles11

Thanks in advance!
Usha

___________________
Usha Srinivasan
Software Engineer
QLogic Corporation
780 5th Ave, Suite A
King of Prussia, PA 19406
(610) 233-4844
(610) 233-4777 (Fax)
(610) 233-4838 (Main Desk)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
