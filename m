From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: Send with immediate data completion
Date: Thu, 12 Jan 2012 10:57:14 -0500
Message-ID: <DC666D1E-6636-4E1A-BF5D-5D42F73A7516@ornl.gov>
References: <1828884A29C6694DAF28B7E6B8A82373256758E5@ORSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823732567591B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732567591B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jan 11, 2012, at 5:22 PM, Hefty, Sean wrote:

>> I'm still waiting on feedback from the IBTA, but they are looking into the
>> matter.
> 
> The intent is for immediate data only to be provided on receive work completions.  The IBTA will clarify the spec on this.  I'll submit patches that remove setting the wc flag, which may help avoid this confusion some.

Sean,

Thanks for looking into this.

Scott--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
