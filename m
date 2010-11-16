From: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Is multicast only available with UD Transport mode?
Date: Tue, 16 Nov 2010 11:03:06 -0700
Message-ID: <4CE2C75A.3000006@redhat.com>
References: <20101112101223.44mbsbnygwcw0008@peddycoart.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B852237B@orsmsx501.amr.corp.intel.com> <20101116100940.uxjift8pwwg40osc@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101116100940.uxjift8pwwg40osc-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/16/2010 10:09 AM, ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org wrote:
> According to a document I have, "RDMA Aware Networks Programming User
> Manual" from Mellanox, the max message size for UD is the MTU.  Is the
> MTU tweakable?  What are the limits of tweakability?
> 
> E
> 

Some systems have a network MTU of 2048 other cards/switches are 4096.
Don't forget you will need the header in the message which consumes some
of the MTU room available.

Regards
-steve

> 
> Quoting "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
> 
>>> Is multicast only available with UD Transport mode?
>>
>> yes
>>
> 
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
