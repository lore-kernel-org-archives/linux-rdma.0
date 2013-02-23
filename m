From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibumad: add string functions for various enums
Date: Fri, 22 Feb 2013 20:46:50 -0800
Message-ID: <20130222204650.aad3b1b2c30edfc44f782e72@llnl.gov>
References: <20130222091333.57b91bbb5957928eeb0e62a7@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A823736F352A97@ORSMSX101.amr.corp.intel.com>
	<20130222111908.2f8b1e56a8f67396a91a3893@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A823736F352B11@ORSMSX101.amr.corp.intel.com>
	<20130222150713.ca761aa639c497c483d9a938@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A823736F352C29@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F352C29-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 23 Feb 2013 00:53:47 +0000
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > > These return values seem mutually exclusive.  Surely we're not going to see a
> > MAD with status 'busy - redirection required - bad version - success'?
> > 
> > They are mutually exclusive now but because the spec defines separate fields it
> > might not always be that way.  That is what I meant when I said "status is not
> > defined to be a strict enum".
> 
> Is there some other option here?  The user doesn't know how large this buffer needs to be.
> 
> - Per thread internal static variable, so the user doesn't need to allocate the buffer?
> - Since status is defined as multiple fields, have calls for each field?

This is probably the most correct and flexible.  Furthermore, we could define separate calls for the class status as needed.

> - Two status string calls, one to return enum type values, and the other to deal with fields?
> 
> This basically tries to output a single string from multiple fields, which seems confusing.  But I dislike saying "not busy, no redirection required, and no invalid fields" rather than "success", even if it is technically more correct.
> 
> Is it acceptable to treat status as an enum, and switch to per thread static variables or multiple calls later if the need ever arises?
> 

We could do this with separate calls for class status.

Ira

> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
