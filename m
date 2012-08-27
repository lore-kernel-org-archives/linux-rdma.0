From: "Ian Druch" <Ian.Druch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: completions for unsignalled WRs following rdma_disconnect
Date: Mon, 27 Aug 2012 14:56:04 -0700
Message-ID: <BD76C1FD2DEA4802893C6E5BE6B413F6@us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Good day,

Could someone confirm that rdma_disconnect is supposed to generate 
completion event(s) for all posted work requests, whether signaled or not?

Thanks,
Ian


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
