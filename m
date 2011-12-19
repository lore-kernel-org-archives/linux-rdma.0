From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ib/cm: fix layout of APR message
Date: Mon, 19 Dec 2011 19:10:48 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325661791@ORSMSX102.amr.corp.intel.com>
References: <20111219074716.GA12058@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111219074716.GA12058@mtldesk30>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Add a missing 16 bit reserved field between ap_status and info fields.
> 
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Thanks for catching this.  Let's hope very few/no people are using APR in such a way that fixing this bug will bite them.

>  drivers/infiniband/core/cm_msgs.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cm_msgs.h
> b/drivers/infiniband/core/cm_msgs.h
> index 7e63c08..686ac1a 100644
> --- a/drivers/infiniband/core/cm_msgs.h
> +++ b/drivers/infiniband/core/cm_msgs.h
> @@ -771,6 +771,7 @@ struct cm_apr_msg {
> 
>  	u8 info_length;
>  	u8 ap_status;
> +	u16 rsvd;

For consistency with the rest of the file, please define this as __be16.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
