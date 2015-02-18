From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: Add support for extended query device caps
Date: Wed, 18 Feb 2015 08:55:50 +0200
Message-ID: <54E43776.9060801@mellanox.com>
References: <1423394932-2965-1-git-send-email-haggaie@mellanox.com>
 <1423394932-2965-2-git-send-email-haggaie@mellanox.com>
 <CAL1RGDU95-xh=KQwaXRGoHkZJjTkXGgT8Y0cwbWbHD8DEWAP=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDU95-xh=KQwaXRGoHkZJjTkXGgT8Y0cwbWbHD8DEWAP=g@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18/02/2015 08:21, Roland Dreier wrote:
>> The verb also checks the user-space provided response buffer size and only
>> fills in capabilities that will fit in the buffer. In attempt to follow the
>> spirit of presentation [2] by Tzahi Oved that was presented during OpenFabrics
>> Alliance International Developer Workshop 2013, the comp_mask bits will only
>> describe which fields are valid.
> 
>> +       if (ucore->outlen < resp.response_length)
>> +               return -ENOSPC;
> 
> So is this really what we want?  A future kernel that adds new fields
> will cause previously working userspace to get an error?

No, the code is intended to only check for the legacy fields, comp_mask
and response_length. At this point though, those are all the fields in
the response struct, so I use sizeof.

The next patch adds more fields to the response struct, and changes the
value of response_length at this point to be the same as it was in this
patch using offsetof:

> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -3318,7 +3318,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
>  	if (cmd.reserved)
>  		return -EINVAL;
>  
> -	resp.response_length = sizeof(resp);
> +	resp.response_length = offsetof(typeof(resp), odp_caps);
>  
>  	if (ucore->outlen < resp.response_length)
>  		return -ENOSPC;

...

> Is there anything wrong with truncating the response to only include
> the fields that userspace asked for? 
Yann had strong objections to that implementation. The main issue is as
I see it is that it can hide user-space bugs where user-space retrieves
a partial field in the response struct.

> Is it just that this is the
> initial implementation of the query_device_ex verb, so the current
> size is also the minimum size?  
Yes.

> If so I think we need at least a
> comment here, so that we remember to fix the ENOSPC code when adding
> more fields in the kernel.

Sure, I'll resend the patches with a comment.

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
