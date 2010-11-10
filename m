From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: ib receive completion error
Date: Wed, 10 Nov 2010 11:34:48 +0200
Message-ID: <4CDA6738.1030409@voltaire.com>
References: <7866DA1F8D2D4541B87FEE88E633ABAA2BBE305046@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7866DA1F8D2D4541B87FEE88E633ABAA2BBE305046-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Usha Srinivasan <usha.srinivasan-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Usha Srinivasan wrote:
> Can someone from Mellanox tell me what the vendor error 0x32 means? I am getting this error for wc.opcode 128 (IB_WC_RECV) wc.status 4 (IB_WC_LOC_PROT_ERR). I am running ofed 1.5.2 and am getting it on both rhel5 and sles11
>   
You can't count on the wc.opcode when the status isn't success (0), and 
yes, we're also saw tons on "ib0: failed recv event status=4, wrid=154 
vend_err 32)" errors when running iscsi/tcp over IPoIB stress from 
windows client to linux node acting as the iscsi target and using ofed 
1.5.2, it starts to look like DoS attack is possible here.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
