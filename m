From: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Subject: Upstream support for multicast IBoE
Date: Tue, 22 Nov 2011 16:38:12 -0600
Message-ID: <20111122223812.GB2131@BohrerMBP.rgmadvisors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It appears the upstream libmlx4/libibverbs currently do not support
multicast IBoE traffic.  For example:

$ mckey -m 239.1.1.1 -b 10.0.202.3
mckey: starting server
mckey: joining
mckey: joined dgid: ff0e::ffff:ef01:101 mlid 0x0 sl 0
mckey: failure creating address handle
test complete
return status 0

Debugging this I can see it fails in libmlx4 in mlx4_create_ah().  In
this case mlx4_resolve_grh_to_l2() returns 1.  Comparing with the OFED
libmlx4/libibverbs I've found the relevant differences are in the
following patch:

http://git.openfabrics.org/git?p=ofed_1_5/libmlx4.git;a=blob;f=fixes/rocee_add_support.patch;h=017b075d639aa2f349424ec94e0089de631470fd;hb=HEAD

This OFED patch seems to partially overlap and conflict with upstream
libmlx4 commits:

902aa188c156e8e2832f5afdf76eb2655fa80582 Add IBoE support
3e73678e88d2ea414a9f4ae187f6412593bd0a1f Add IBoE UD/VLANs support

In general it is very unclear to me what the development work flow is
between the OFED and upstream versions of these libraries.  Is there a
plan to add multicast IBoE support to the upstream versions?

Thanks,
Shawn


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
