From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Registering non-contiguous memory
Date: Tue, 28 Feb 2017 07:31:04 -0500
Message-ID: <f40f326d-e76b-0471-dc7d-e81b7d07db78@talpey.com>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR05MB127817A311C332553E4391AFB9410-79XLn2atqDMOK6E67s+DINqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/5/2017 11:46 AM, Alex Margolin wrote:
> Introduction
> --------------------------------------------------------------------------------
> Numerous applications communicate buffers with a non-contiguous memory layout.
> For example, HPC applications often work on a matrix, and require sending a row or a column. Sending non-contiguous data requires specifying all the buffers being transferred, along with potentially the same amount of memory keys (should the buffers be registered under different memory regions). Extended memory windows are proposed to address complex memory layouts, and allow the user to send and receive them in an efficient manner.
> This RFC proposes an extension for memory windows for the use of non-contiguous buffers.
>
...
> The layout is "switched on" as a bind parameter with an additional access flag, which is somewhat of a misuse, but since struct ibv_mw_bind_info is not easily expandable in the functions using it, the alternative is an additional verb.
>
> We do propose adding a verb for the allocation of such memory windows, which is required since the original memory window allocation function is not easily extendable, and we require an additional parameter to determine the amount of resources to allocate towards it (descriptors). In addition, this number is available for existing windows, in order to determine how to set this for a composite of two existing windows, or to keep track of resource use for it.
>
> Finally, we add the option to obtain a local memory key for memory windows, aside from the currently available remote key. This can be specified in an SGE to send data out of a memory layout. This key will only be valid if local access is requested in the access flags.

How does the application detect whether the adapter supports this new
verb? I don't see an attribute or other bit exposing it above the API.

Also, what applications are likely to use it? It is my understanding
that relatively few applications use Memory Windows-style registration
today. Roughly what performance benefit do you expect they will achieve
from the region descriptor format overall, motivating them to change?

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
