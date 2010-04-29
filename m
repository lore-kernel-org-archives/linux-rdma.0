From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] ib_core: implement XRC RCV qp's
Date: Thu, 29 Apr 2010 12:46:22 -0700
Message-ID: <adavdbaxcs1.fsf@roland-alpha.cisco.com>
References: <201002281102.21207.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201002281102.21207.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (Jack Morgenstein's
	message of "Sun, 28 Feb 2010 11:02:21 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Note that for users who do not wish to utilize the reg/unreg verbs,
 > a destroy_xrc_rcv_qp verb is also provided.  Thus, usage is:
 > Either: create/destroy_xrc_rcv_qp
 > Or: create/reg/unreg_xrc_rcv_qp (the unreg is used in place of destroy) 

I don't really understand the semantics here.  What is supposed to
happen if I do create/reg/destroy?  What happens if one process does
destroy while another process is still registered?  To make everything
even more confusing, mlx4 defines unreg_rxc_rcv_qp to be equivalent to
destroy_xrc_rcv_qp.  I'm not even clear why the low-level driver has two
entry points for these two methods -- shouldn't the uverbs core be
handling the counting/listing of xrc rcv qps and just ask the low-level
driver to destroy the QP when it's really done with it?

(By the way, should we use the name "target QP" instead of "rcv QP" to
match the actual IB spec?)

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
