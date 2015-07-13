From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: How to RoCE v2?
Date: Mon, 13 Jul 2015 16:50:59 +0000
Message-ID: <9C6B67F36DCAFC479B1CF6A967258A8C7D207932@ORSMSX110.amr.corp.intel.com>
References: <3CBF78CA47A0D542A0094940BB0205E762D284@AVMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3CBF78CA47A0D542A0094940BB0205E762D284-yWqByQLCgs06wu3ARrlbmA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ram Amrani wrote, 
>In the latest OFED (3.18-rc3) I don't see any RoCE v2 code, albeit it being introduce in 2014. How come?

These patches have not yet been accepted upstream and since OFED now pulls the kernel code from upstream,
It is not yet in OFED-3.18 that was based on the kernel.org 3.18 kernel.
I am hoping that the RoCE v2 patches will be ready for the next major OFED, that will likely be based on the kernel.org
4.2 or 4.3 kernel. 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
