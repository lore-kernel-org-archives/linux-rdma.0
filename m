From: "Suresh Shelvapille" <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: Qperf and APM
Date: Wed, 6 Mar 2013 10:40:19 -0500
Message-ID: <82EBBE0B04D4427381C29144BE078F2B@md.baymicrosystems.com>
References: <1358891797-14625-1-git-send-email-sean.hefty@intel.com> <1358891797-14625-2-git-send-email-sean.hefty@intel.com> <1828884A29C6694DAF28B7E6B8A8237368B99D59@ORSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A823736F35600F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F35600F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Folks:
The qperf utility has -ap, -lap, -rap options in support of APM. Unfortunately they don't seem to work. Is there a way
to make this work, or if you have any other ideas on testing failover using rdma please let me know. I have successfully
used tcp_bw tests for this purpose already.

Thanks,
Suri

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
