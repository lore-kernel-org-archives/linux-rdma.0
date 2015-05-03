From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH v3] IB/core: Fix unaligned accesses
Date: Sun, 3 May 2015 14:27:07 +0000
Message-ID: <AM3PR05MB0935B250A67FB723DAA93640DCD30@AM3PR05MB0935.eurprd05.prod.outlook.com>
References: <1430515349-183903-1-git-send-email-david.ahern@oracle.com>
 <AM3PR05MB093528DFDBBA39DD7977CC85DCD30@AM3PR05MB0935.eurprd05.prod.outlook.com>
 <554626A2.20302@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <554626A2.20302-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: David Ahern [mailto:david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> 
> On 5/3/15 4:20 AM, Shachar Raindel wrote:
> > Hi,
> >
> > The patch is broken - you did not update
> 
> --verbose. I did not update what?

Had a slight brain-body sync issue.
Was meaning to point out that IB_CM_COMPARE_SIZE changed, but
Some of its users were not updated.

> >
> >
> >> -----Original Message-----
> >> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> >> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of David Ahern
> >> Sent: Saturday, May 02, 2015 12:22 AM
> 
> That is filled in by git and the time on the server is proper. So what
> do you disagree with?
> 

No disagreement there, was just meaning to help everyone find the 
relevant original e-mail without a doubt. My MTA is bit "special."

> >
> > <snipped>
> >
> >>
> >>   static int cm_compare_data(struct ib_cm_compare_data *src_data,
> >>   			   struct ib_cm_compare_data *dst_data)
> >>   {
> >> -	u8 src[IB_CM_COMPARE_SIZE];
> >> -	u8 dst[IB_CM_COMPARE_SIZE];
> >> +	u32 src[IB_CM_COMPARE_SIZE];
> >> +	u32 dst[IB_CM_COMPARE_SIZE];
> >>
> >>   	if (!src_data || !dst_data)
> >>   		return 0;
> >> @@ -460,10 +459,10 @@ static int cm_compare_data(struct
> >> ib_cm_compare_data *src_data,
> >>   	return memcmp(src, dst, IB_CM_COMPARE_SIZE);
> >
> > You added a BUG here - you should use (IB_CM_COMPARE_SIZE *
> sizeof(u32)).
> 
> Thank you for pointing that out. Changed those to sizeof(src) and
> sizeof(compare_data->mask).
> 

This sounds good.

Thanks,
--Shachar

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
