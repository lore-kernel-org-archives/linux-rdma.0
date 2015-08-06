From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Thu, 6 Aug 2015 19:46:44 +0300
Message-ID: <55C38F74.7070200@dev.mellanox.co.il>
References: <20150804143447.GA22172@infradead.org>
 <20150806162438.GA27608@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150806162438.GA27608-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/6/2015 7:24 PM, Christoph Hellwig wrote:
> I've pushed out a new version.  Updates:
>
>   - the ib_recv_wr change Bart notices has been fixed.
>   - iser and isert have been converted

Thanks Christoph!

>   - the handling of the embedded WR in the qib software queue entry
>     has been fixed.
>
> Which means we're basically done now and the patch could use
> broader testing.

pulling it now...

>
> The full patch will be too much for the list again, so here is the
> git commit:
>
> http://git.infradead.org/users/hch/scsi.git/commitdiff/a0027ed00fc3ae2686d8a843a724b50597115a71
>
> ib_vers.h diff below:
>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 0940051..2f2efdd 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1100,54 +1100,94 @@ struct ib_send_wr {
>   		__be32		imm_data;
>   		u32		invalidate_rkey;
>   	} ex;
> -	union {
> -		struct {
> -			u64	remote_addr;
> -			u32	rkey;
> -		} rdma;
> -		struct {
> -			u64	remote_addr;
> -			u64	compare_add;
> -			u64	swap;
> -			u64	compare_add_mask;
> -			u64	swap_mask;
> -			u32	rkey;
> -		} atomic;
> -		struct {
> -			struct ib_ah *ah;
> -			void   *header;
> -			int     hlen;
> -			int     mss;
> -			u32	remote_qpn;
> -			u32	remote_qkey;
> -			u16	pkey_index; /* valid for GSI only */
> -			u8	port_num;   /* valid for DR SMPs on switch only */
> -		} ud;
> -		struct {
> -			u64				iova_start;
> -			struct ib_fast_reg_page_list   *page_list;
> -			unsigned int			page_shift;
> -			unsigned int			page_list_len;
> -			u32				length;
> -			int				access_flags;
> -			u32				rkey;
> -		} fast_reg;
> -		struct {
> -			struct ib_mw            *mw;
> -			/* The new rkey for the memory window. */
> -			u32                      rkey;
> -			struct ib_mw_bind_info   bind_info;
> -		} bind_mw;
> -		struct {
> -			struct ib_sig_attrs    *sig_attrs;
> -			struct ib_mr	       *sig_mr;
> -			int			access_flags;
> -			struct ib_sge	       *prot;
> -		} sig_handover;
> -	} wr;
>   	u32			xrc_remote_srq_num;	/* XRC TGT QPs only */

I agree that this is a shame to keep in here for everyone to carry...
The only driver I've seen supporting XRC is mlx5 with no consumers.

If people are reluctant to remove it, you can put it in ib_xrc_send_wr
or something...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
