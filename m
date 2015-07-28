From: "Rupert Dance" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
Subject: removal of ib_reg_phys_mr()
Date: Tue, 28 Jul 2015 13:51:26 -0400
Message-ID: <010f01d0c95e$06e600f0$14b202d0$@soft-forge.com>
Mime-Version: 1.0
Content-Type: text/plain;
	boundary="----=_NextPart_000_00EF_01D0C93A.6A2489D0";
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Chuck Lever asked the OFA EWG to comment on whether they knew of any code
that was using ib_reg_phys_mr(). Issac Huang from Intel found this instance:

http://lxr.free-electrons.com/source/drivers/staging/lustre/lnet/klnds/o2ibl
nd/o2iblnd.c#L2380 

Thanks

Rupert Dance

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
