From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ipoib: fix hard_header return value
Date: Wed, 27 Mar 2013 10:04:50 -0400
Message-ID: <5152FC82.6000106@redhat.com>
References: <3fde29b99442969e59a7a9cf4f63a26858f00a0a.1364315061.git.dledford@redhat.com> <5151CF60.3010100@acm.org> <CAG4TOxPa+B1=N8DUPf4E1AT-a__Yx=3d83d1xA6H5pPW=9TabA@mail.gmail.com> <20130326181634.GB22775@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130326181634.GB22775-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/26/2013 02:16 PM, Jason Gunthorpe wrote:
> On Tue, Mar 26, 2013 at 09:46:28AM -0700, Roland Dreier wrote:
>>> Checkpatch recommends since some time to use sizeof(e) instead of sizeof e,
>>> isn't it ?
>>
>> I actually prefer "sizeof e" since sizeof is an operator, not a
>> function.  "sizeof(e)" looks just as silly as "return(e)" to me.
> 
> Sizeof is used as an expression, return is not.
> 
> They have different precedence rules:
>  return e + 1; // == return (e + 1)
> vs
>  sizeof e + 1;  // == sizeof(e) + 1
> 
> Or weirder:
>  return (void *)x; // OK
> vs
>  sizeof (void *)x; // <-- compile error
> 
> Coding sizeof as a function call frees the reader from having to
> check/know the obscure precedence rules for sizeof.

Personally, I couldn't care less.  But about 5 lines outside of the
context of this patch in the same function is another use of that same
expression.  The real reason I used the form I did was to match the
style of that other instance.  I prepared a separate patch to convert
both of them to the checkpatch preferred style until I saw Roland say he
didn't want it.  But what I wouldn't have done is submitted a patch that
caused a single function to have two different styles within 8 lines of
each other just because some nanny state nag script tells me too.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
