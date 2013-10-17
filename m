From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC 2/9] IB/core: Introduce Signature Verbs API
Date: Thu, 17 Oct 2013 22:51:18 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CE2BFF@ORSMSX109.amr.corp.intel.com>
References: <1381851510-17290-1-git-send-email-sagig@mellanox.com>
 <1381851510-17290-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381851510-17290-3-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -885,6 +901,19 @@ struct ib_send_wr {
>  			u32                      rkey;
>  			struct ib_mw_bind_info   bind_info;
>  		} bind_mw;
> +		struct {
> +			struct ib_sig_attrs    *sig_attrs;
> +			struct ib_mr	       *sig_mr;
> +			int			access_flags;
> +			/* Registered data mr */
> +			struct ib_mr	       *data_mr;
> +			u32			data_size;
> +			u64			data_va;
> +			/* Registered protection mr */
> +			struct ib_mr	       *prot_mr;
> +			u32			prot_size;
> +			u64			prot_va;
> +		} sig_handover;

At what point do we admit that this is a ridiculous structure?

Help me understand what this WR is doing.  Is this telling the HCA to copy data between local MRs?  What is a 'data MR' versus a 'protected MR'?  (I'm not hip on T10-DIF.)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
