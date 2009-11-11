From: David Brean <David.Brean-UdXhSnd/wVw@public.gmane.org>
Subject: Re: strong ordering for data registered memory
Date: Wed, 11 Nov 2009 16:37:41 -0500
Message-ID: <4AFB2EA5.4030804@Sun.COM>
References: <4AF9CACE.8070700@Sun.COM> <adaskclvta4.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <adaskclvta4.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I decided to minimize the impact of an API change on the class of 
applications that use the current verbs interface because those 
applications can safely run on platforms that deliver optimal 
performance using weak ordering for data buffers.  New binaries aren't 
required for this class of application.

I thought it would be more appropriate to put the burden of added 
complexity on the class of applications that bypass the verbs to access 
special features in the hardware.  In fact, those applications are 
selective about memory regions that need this special handling and would 
register lots of memory without the "strong ordering' bit.  How 
applications determine that the platform is capable of performing the 
request would be beyond the scope of the verbs, however, I suppose that 
the verbs framework could check and return an error.

If there are applications that expect the hardware to support "strong 
ordering" and don't check the hardware, then these might be a problem.  
Do any of these exists?

By the way, if I had proposed this bit several years ago, then I would 
have chosen a "weak ordering" flag.  Instead, I decided to try 
protecting the existing base of verbs-based software.

-David

Roland Dreier wrote:
>  > Some time ago there was an email sent to this group with the subject
>  > "weak ordering for data registered memory".  I don't recall any action
>  > resulting from this thread.  So, I have a question.  If a bit were
>  > defined to specify "strong ordering", perhaps as a "access" flag (see
>  > ibv_access_flags) and used with ibv_reg_mr(), would that be sufficient
>  > for (1) client applications that need a HW "guarantee" of writing the
>  > last byte of an RDMA last and (2) platform implementations that need
>  > to deliver that feature?
>
> What would happen if an application asked for strong ordering and the
> adapter and/or platform is not capable of that?
>
> Weak ordering is a bit easier to handle -- the app is saying "if you can
> make things go faster, don't worry about ordering here" and a platform
> where it doesn't matter can just ignore it.
>
>  - R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
