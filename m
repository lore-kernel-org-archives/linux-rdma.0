From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] ib_core: implement XRC RCV qp's
Date: Wed, 05 May 2010 15:40:41 -0700
Message-ID: <adaeihqas5y.fsf@roland-alpha.cisco.com>
References: <201002281102.21207.jackm@dev.mellanox.co.il>
	<adavdbaxcs1.fsf@roland-alpha.cisco.com>
	<201005050945.05729.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201005050945.05729.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (Jack Morgenstein's
	message of "Wed, 5 May 2010 09:45:05 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, diego-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > > I don't really understand the semantics here.  What is supposed to
 > > happen if I do create/reg/destroy?> What happens if one process does 
 > > destroy while another process is still registered?

 > Maybe we can simply assert that the unreg IS the destroy method of the
 > IB_SPEC, and get rid of the destroy method.
 > 
 > The xrc target qp section of the spec was not written with QP persistence
 > (after the creating process exited) in mind.  That requirement surfaced
 > at the last minute as a result of testing by the MPI community during the
 > implementation phase (as far as I know).  Unfortunately, this created
 > a semantic problem.

Yes, I think we should try to simplify things here.

It's very unfortunate to diverge from the API that's been shipped for a
while now, but I really think we don't want all these different ways of
saying the same thing, with little difference between create and reg,
and between destroy and unreg.

In fact the smallest possible API would be just

  register_xrc_rcv_qp(xrcd, *qp_num)

where the user can pass in an invalid qp_num (say, -1 aka ffffffff) and
have a new QP created, or a valid one to take a new ref on the existing
rcv QP, and

  unregister_xrc_rcv_qp(xrcd, qp_num).

(along these lines, the structure in these patches:

+struct ib_uverbs_create_xrc_rcv_qp {
+	__u64 response;
+	__u64 user_handle;
+	__u32 xrcd_handle;
+	__u32 max_send_wr;
+	__u32 max_recv_wr;
+	__u32 max_send_sge;
+	__u32 max_recv_sge;
+	__u32 max_inline_data;
+	__u8  sq_sig_all;
+	__u8  qp_type;
+	__u8  reserved[6];
+	__u64 driver_data[0];
+};

has many fields we don't need.  Pretty much all the fields after
xrcd_handle are ignored, except sq_sig_all is used -- and that is highly
dubious since the rcv QP has no SQ!  So I would propose something like
just having:

+struct ib_uverbs_reg_xrc_rcv_qp {
+	__u64 response;
+	__u32 xrcd_handle;
+	__u32 qp_num;
+	__u64 driver_data[0];
+};

where response is used to pass back the qp_num in the create case.

And then we just have unreg_xrc_rcv_qp and no destroy method (since they
are synonymous anyway).
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
