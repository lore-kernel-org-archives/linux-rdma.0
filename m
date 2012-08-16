From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Thu, 16 Aug 2012 09:24:27 +0300
Message-ID: <502C921B.7000202@mellanox.com>
References: <20120816114443.600553d2fd103a5b2b36e061@canb.auug.org.au> <CAG4TOxNLenjQxZNb7Rpm2G9RNBN77uWgEgfNXgoj+gLFdObuTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxNLenjQxZNb7Rpm2G9RNBN77uWgEgfNXgoj+gLFdObuTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 16/08/2012 07:07, Roland Dreier wrote:
> [...] should be fixed in tomorrow's for-next (added include of 
> <linux/vmalloc.h>). 

thanks for taking care of that.
>> See Rule 1 in Documentation/SubmitChecklist.
>
> Heh, but it compiles fine on x86!

I wonder if there is a way to easily catch such errors when building on x86.

Or.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
