From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/13] Request for Comments on SoftiWarp
Date: Thu, 12 Oct 2017 14:05:39 -0400
Message-ID: <dd0e915d-2ab7-9912-b000-bcca1acee256@intel.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006122853.16310-1-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/6/2017 8:28 AM, Bernard Metzler wrote:
> It is a re-posting of yesterdays misformatted patch and splits it into
> consumable pieces. Furthermore, it fixes formatting issues as
> indicated by checkpatch.

You should also remove the following:

1. All BUG/BUG_ON - just scrub all files
2. Remove all goto return stuff
3. TODO/XXX - either add the functionality or it's not needed
4. Extra whitespace, don't skip more than 1 line

It would be nice to see some commit messages too. Describe a bit about 
how things are working even if in just a few lines.

If we were using the staging tree still, I'd say it's in good enough 
shape to send there and let it get hacked on, but we aren't going down 
that road in this subsystem again I don't think. So the bar is a little 
higher I for getting in to mainline.

You also have a large number of debugging prints. While it's nice for 
development and can be turned off, I think alot of those are 
unnecessary. The RDMA subsystem on the whole needs a better strategy for 
dealing with debugging and logging, we just aren't there yet.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
