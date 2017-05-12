From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 5/5] libbnxt_re: reset head and tail when moving to RST
Date: Fri, 12 May 2017 10:08:24 -0600
Message-ID: <20170512160824.GA28142@obsidianresearch.com>
References: <1494584666-11064-1-git-send-email-devesh.sharma@broadcom.com>
 <1494584666-11064-6-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494584666-11064-6-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 12, 2017 at 06:24:26AM -0400, Devesh Sharma wrote:

>  		ibvwc->wc_flags |= IBV_WC_WITH_IMM;
> +		/* Completion reports the raw-data in LE format, While
> +		 * user expects it in BE format. Thus, swapping on outgoing
> +		 * data is needed. On a BE platform le32toh will do the swap
> +		 * while on LE platform htobe32 will do the job.
> +		 */
>  		ibvwc->imm_data = htobe32(le32toh(rcqe->imm_key));

Just to be clear, getting this right is an interop requirement.

Code like the above means the hardware takes byte 0 of the ImmDt
header and writes to byte 3 of rcqe->imm_key.

verbs requires that byte 0 of the ImmDt header is written to byte 0 of
wc->imm_data

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
