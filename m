From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/4] ib_core: implement XRC RCV qp's
Date: Sat, 8 May 2010 10:28:19 +0300
Message-ID: <201005081028.20327.jackm@dev.mellanox.co.il>
References: <201002281102.21207.jackm@dev.mellanox.co.il> <201005050945.05729.jackm@dev.mellanox.co.il> <adaeihqas5y.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaeihqas5y.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org, ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dr. Panda, Jeff, and Ishai,

We are trying to get XRC integrated into the next mainstream kernel.

For the kernel submission, I added a destroy_xrc_rcv_qp method (to be
used if the application did not require persistence of the xrc_rcv qp
after the creating process terminated -- per Diego Copernicoff's request).
This did not affect the core API of create/modify/unreg that you have
been using until now.

However, even without the new destroy method (as I suggest below),
having the creating process call unreg is still a bit counterintuitive,
since it calls create, and registration is a side-effect.

Roland is now intensively reviewing the XRC patches, and a made suggestion
to simplify the API which Tziporet and I agree with (see Roland's comments below).

Please comment on this suggestion (which is to have reg_xrc_rcv_qp do create
as well).
This is a minor change, that would require two changes in your current calls:
1. Instead of calling create_xrc_rcv_qp(), as is done currently, MPI would call
   u32 qp_num = 0xFFFFFFFF;
	err = reg_xrc_rcv_qp(xrcd, &qp_num);
   and would have the created qp number returned in qp_num;
   (the qp_init attributes in the old create_xrc_rcv_qp are all ignored except for
   the xrc domain handle anyway)

2. instead of calling reg_xrc_rcv_qp(xrcd, qp_num), you would need to set the
   qp number in a u32 variable, and call reg_xrc_rcv_qp(xrcd, &qp_num).

The other xrc_rcv_qp verbs would work as they work now.

Regarding OFED, this change would not affect OFED 1.5.x ; it would only enter
OFED at 1.6.x.

Please comment.

-Jack

P.S. You can see the submission/discussion of XRC starting at:
	http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg02792.html
On Thursday 06 May 2010 01:40, Roland Dreier wrote:
>  > > I don't really understand the semantics here.  What is supposed to
>  > > happen if I do create/reg/destroy?> What happens if one process does 
>  > > destroy while another process is still registered?
> 
>  > Maybe we can simply assert that the unreg IS the destroy method of the
>  > IB_SPEC, and get rid of the destroy method.
>  > 
>  > The xrc target qp section of the spec was not written with QP persistence
>  > (after the creating process exited) in mind.  That requirement surfaced
>  > at the last minute as a result of testing by the MPI community during the
>  > implementation phase (as far as I know).  Unfortunately, this created
>  > a semantic problem.
> 
> Yes, I think we should try to simplify things here.
> 
> It's very unfortunate to diverge from the API that's been shipped for a
> while now, but I really think we don't want all these different ways of
> saying the same thing, with little difference between create and reg,
> and between destroy and unreg.
> 
> In fact the smallest possible API would be just
> 
>   register_xrc_rcv_qp(xrcd, *qp_num)
> 
> where the user can pass in an invalid qp_num (say, -1 aka ffffffff) and
> have a new QP created, or a valid one to take a new ref on the existing
> rcv QP, and
> 
>   unregister_xrc_rcv_qp(xrcd, qp_num).
> 
> (along these lines, the structure in these patches:
> 
> +struct ib_uverbs_create_xrc_rcv_qp {
> +	__u64 response;
> +	__u64 user_handle;
> +	__u32 xrcd_handle;
> +	__u32 max_send_wr;
> +	__u32 max_recv_wr;
> +	__u32 max_send_sge;
> +	__u32 max_recv_sge;
> +	__u32 max_inline_data;
> +	__u8  sq_sig_all;
> +	__u8  qp_type;
> +	__u8  reserved[6];
> +	__u64 driver_data[0];
> +};
> 
> has many fields we don't need.  Pretty much all the fields after
> xrcd_handle are ignored, except sq_sig_all is used -- and that is highly
> dubious since the rcv QP has no SQ!  So I would propose something like
> just having:
> 
> +struct ib_uverbs_reg_xrc_rcv_qp {
> +	__u64 response;
> +	__u32 xrcd_handle;
> +	__u32 qp_num;
> +	__u64 driver_data[0];
> +};
> 
> where response is used to pass back the qp_num in the create case.
> 
> And then we just have unreg_xrc_rcv_qp and no destroy method (since they
> are synonymous anyway).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
