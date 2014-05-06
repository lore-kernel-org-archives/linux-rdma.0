From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/mad: add new ioctl to user space to support new
 registration options
Date: Mon, 5 May 2014 21:04:41 -0600
Message-ID: <20140506030441.GD2307@obsidianresearch.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
 <1399340690-27677-5-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1399340690-27677-5-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 05, 2014 at 09:44:49PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

> +struct ib_user_mad_reg_req2 {
> +	__u32	id;
> +	__u32	qpn;
> +	__u8	mgmt_class;
> +	__u8	mgmt_class_version;
> +	__u16   res;
> +	__u32   flags;
> +	__u64   method_mask[2];
> +	__u8    oui[3]; /* network order */
> +	__u8	rmpp_version;
> +};

Please make the padding on 64 bit explicit so we don't have weird
problems mixing 32 and 64 bit code.

Similar comment as for userspace using a host order uint for the oui.

It would also be good to verify that a 32 bit binary can successfully
execute the ioctl on a 64 bit kernel.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
