From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] svcrdma: RDMA support not yet compatible with RPC6
Date: Mon, 5 Apr 2010 12:16:18 -0400
Message-ID: <20100405161618.GI16370@fieldses.org>
References: <4BB74241.4060308@ogc.us> <4BB9F9D0.1040203@oracle.com> <20100405154850.GG16370@fieldses.org> <4BBA06B8.3090201@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4BBA06B8.3090201-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 05, 2010 at 10:50:16AM -0500, Tom Tucker wrote:
> J. Bruce Fields wrote:
>> On Mon, Apr 05, 2010 at 10:55:12AM -0400, Chuck Lever wrote:
>>   
>>> On 04/03/2010 09:27 AM, Tom Tucker wrote:
>>>     
>>>> RPC6 requires that it be possible to create endpoints that listen
>>>> exclusively for IPv4 or IPv6 connection requests. This is not currently
>>>> supported by the RDMA API.
>>>>
>>>> Signed-off-by: Tom Tucker<tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>>>> Tested-by: Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>>>>       
>>> Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>     
>>
>> Thanks to all.  I take it the problem began with 37498292a "NFSD: Create
>> PF_INET6 listener in write_ports"?
>>
>>   
>
> Yes.

Thanks.  I'll pass along

	git://linux-nfs.org/~bfields/linux.git for-2.6.34

soon.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
