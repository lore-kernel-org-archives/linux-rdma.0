From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 for-next 1/7] IB/core: Extend ib_uverbs_create_qp
Date: Wed, 21 Oct 2015 12:53:25 +0300
Message-ID: <56276095.6020803@dev.mellanox.co.il>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com>
 <1444909482-17113-2-git-send-email-eranbe@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444909482-17113-2-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/15/2015 2:44 PM, Eran Ben Elisha wrote:
> ib_uverbs_ex_create_qp follows the extension verbs
> mechanism. New features (for example, QP creation flags
> field which is added in a downstream patch) could used
> via user-space libraries without breaking the ABI.

This is an important addition, I'll need it soon for stuff
I'm working on...

> +struct ib_uverbs_ex_create_qp {
> +	__u64 user_handle;
> +	__u32 pd_handle;
> +	__u32 send_cq_handle;
> +	__u32 recv_cq_handle;
> +	__u32 srq_handle;
> +	__u32 max_send_wr;
> +	__u32 max_recv_wr;
> +	__u32 max_send_sge;
> +	__u32 max_recv_sge;
> +	__u32 max_inline_data;
> +	__u8  sq_sig_all;
> +	__u8  qp_type;
> +	__u8  is_srq;
> +	__u8 reserved;
> +	__u32 comp_mask;
> +	__u32 create_flags;

Can we please make create_flags u64 to begin with?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
