From: David Brean <David.Brean-UdXhSnd/wVw@public.gmane.org>
Subject: Re: strong ordering for data registered memory
Date: Thu, 12 Nov 2009 15:42:28 -0500
Message-ID: <4AFC7334.6010301@Sun.COM>
References: <4AF9CACE.8070700@Sun.COM> <adaskclvta4.fsf@roland-alpha.cisco.com>
 <4AFB2EA5.4030804@Sun.COM> <ada639gvezo.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <ada639gvezo.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some of the SPARC servers from Sun support an IO memory mapping 
mechanism for marking pages for weak or strong ordering.  It has no 
dependency on the HCA.  Marking memory pages for data buffers as weak 
ordered delivers significantly better throughput on IB.

I assumed that there are many more applications using the user verbs 
that don't care about ordering for data buffers, but would need to be 
modified to set a "weak ordering" flag.

Nonetheless, I'm somewhat flexible and willing to go with bit definition 
that that verbs consumers prefer.

-David

Roland Dreier wrote:
>  > I decided to minimize the impact of an API change on the class of
>  > applications that use the current verbs interface because those
>  > applications can safely run on platforms that deliver optimal
>  > performance using weak ordering for data buffers.  New binaries aren't
>  > required for this class of application.
>  > 
>  > I thought it would be more appropriate to put the burden of added
>  > complexity on the class of applications that bypass the verbs to
>  > access special features in the hardware.  In fact, those applications
>  > are selective about memory regions that need this special handling and
>  > would register lots of memory without the "strong ordering' bit.  How
>  > applications determine that the platform is capable of performing the
>  > request would be beyond the scope of the verbs, however, I suppose
>  > that the verbs framework could check and return an error.
>  > 
>  > If there are applications that expect the hardware to support "strong
>  > ordering" and don't check the hardware, then these might be a problem.
>  > Do any of these exists?
>  > 
>  > By the way, if I had proposed this bit several years ago, then I would
>  > have chosen a "weak ordering" flag.  Instead, I decided to try
>  > protecting the existing base of verbs-based software.
>
> I can't really follow this.  Right now Open MPI et al assume that if
> they see a Mellanox adapter, they get the "last byte of RDMA becomes
> visible last" behavior.  And there is not a way that I know of to turn
> this off at all, let alone get any performance difference.  The
> exception being the Cell processor system that started the previous
> discussion, where weak ordering at the platform level helped things.
>
> But given that current software does seem to rely on ordering, it seems
> that opting into weak ordering would break fewer applications.
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
