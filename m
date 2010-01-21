From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma_bind failure over iWarp
Date: Thu, 21 Jan 2010 08:06:52 +0200
Message-ID: <4B57EEFC.3090301@Voltaire.com>
References: <382A478CAD40FA4FB46605CF81FE39F44FE7B5EE@orsmsx507.amr.corp.intel.com>	<603F8A3875DCE940BA37B49D0A6EA0AE58CFBB79@azsmsx501.amr.corp.intel.com>	<603F8A3875DCE940BA37B49D0A6EA0AE58CFBE7F@azsmsx501.amr.corp.intel.com>	<4B576195.6000402@mellanox.co.il>	<382A478CAD40FA4FB46605CF81FE39F44FE7C052@orsmsx507.amr.corp.intel.com>	<061D067A03094FC09E4A0933A9262BEA@amr.corp.intel.com> <382A478CAD40FA4FB46605CF81FE39F44FE7C1AC@orsmsx507.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <382A478CAD40FA4FB46605CF81FE39F44FE7C1AC-osO9UTpF0URzLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Woodruff, Robert J wrote:
> [woody@det-17 src]$ ucmatose -b 192.168.0.17
> cmatose: starting server
> cmatose: bind address failed: No such file or directory
> return status -1

A case were rdma_bind returns -ENOENT was debugged here this week with the problem being the same IP assigned to two interfaces where one of them not being of a HCA/RNIC. I just tried assigning the same IP to on-board 1Gbs and IB HCA and couldn't hit the ucmatose error (2.6.33-rc4 and librdmacm-1.0.8-5.el5).

Moni, anything you can add?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
