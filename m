From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH RFC v2 02/10] IB/core: Introduce Signature Verbs API
Date: Fri, 01 Nov 2013 08:13:00 -0700
Message-ID: <5273C4FC.4070708@acm.org>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383222255-22699-3-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 31/10/2013 5:24, Sagi Grimberg wrote:
> +/**
> + * struct ib_sig_domain - Parameters specific for T10-DIF
> + * 	domain.
> + * @sig_type: specific signauture type
> + * @sig: union of all signature domain attributes that may
> + * 	 be used to set domain layout.
> + * 	 @dif:
> + * 		@type: T10-DIF type (0|1|2|3)
> + * 		@bg_type: T10-DIF block guard type (CRC|CSUM)
> + * 		@block_size: block size in signature domain.
> + * 		@app_tag: if app_tag is owned be the user,
> + * 			HCA will take this value to be app_tag.
> + * 		@ref_tag: initial ref_tag of signature handover.
> + * 		@type3_inc_reftag: T10-DIF type 3 does not state
> + *			about the reference tag, it is the user
> + *			choice to increment it or not.
> + */
> +struct ib_sig_domain {
> +	enum ib_signature_type 	sig_type;
> +	union {
> +		struct {
> +			enum ib_t10_dif_type	type;
> +			enum ib_t10_dif_bg_type bg_type;
> +			u16			block_size;
> +			u16			bg;
> +			u16			app_tag;
> +			u32			ref_tag;
> +			bool			type3_inc_reftag;
> +		} dif;
> +	} sig;
> +};

My understanding from SPC-4 is that in that when using protection 
information such information is inserted after every protection 
interval. A protection interval can be smaller than a logical block. 
Shouldn't the name "block_size" be changed into something like 
"pi_interval" to avoid confusion with the logical block size ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
