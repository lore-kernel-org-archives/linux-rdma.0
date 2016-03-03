From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v4 4/4] IB/iser: Use ib_drain_sq()
Date: Thu, 3 Mar 2016 09:17:30 -0600
Message-ID: <00a401d1755f$ce1c5040$6a54f0c0$@opengridcomputing.com>
References: <cover.1455741336.git.swise@chelsio.com> <269ab4c6de9c30bb6beba249302d5f1d1db9b924.1455741337.git.swise@chelsio.com> <56D80D8F.7070700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D80D8F.7070700-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Steve, I prefer that iser will call ib_drain_qp(). It's
> harmless from that point of view.
> 
> Given that Doug pulled it into his github, I can send an
> incremental patch.

Sounds good.

Steve

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
