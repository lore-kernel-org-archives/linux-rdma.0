From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V7 libmlx4 2/2] Add support for XRC QPs
Date: Wed, 24 Jul 2013 15:53:42 +0300
Message-ID: <51EFCE56.60003@dev.mellanox.co.il>
References: <1373555264-1787-1-git-send-email-yishaih@mellanox.com> <1373555264-1787-3-git-send-email-yishaih@mellanox.com> <20130711172535.GC27357@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130711172535.GC27357-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/11/2013 8:25 PM, Jason Gunthorpe wrote:
> On Thu, Jul 11, 2013 at 06:07:44PM +0300, Yishai Hadas wrote:
>
>> +	if (sizeof(*verbs_ctx) -
>> +	    offsetof(struct verbs_context,
>> +		     close_xrcd) <= verbs_ctx->sz)
>> +		verbs_ctx->close_xrcd = mlx4_close_xrcd;
> please put a macro in libibverbs headers for this, all drivers will
> require this tricky test. Eg:
>
>    verbs_set_ctx_op(verbs_ctx, close_xrcd, mlx4_close_xrcd);
     OK, will add as part of V8 that I'm going to send soon.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
