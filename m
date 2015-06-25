From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] Networking
Date: Thu, 25 Jun 2015 13:40:14 +0300
Message-ID: <CAJ3xEMj34d-+vtkZ1nELrdG1pw89uxvPBRx3wp6WM_uoAa5oZA@mail.gmail.com>
References: <20150624.063911.1220157256743743341.davem@davemloft.net>
	<CA+55aFybr6Fjti5WSm=FQpfwdwgH1Pcfg6L81M-Hd9MzuSHktg@mail.gmail.com>
	<2807E5FD2F6FDA4886F6618EAC48510E110A2D71@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E110A2D71-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Jason Gunthorpe (jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org)" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 25, 2015 at 4:52 AM, Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Linus,
>
>>
>> On the *other* side of the same conflict, I find an even more offensive commit,
>> namely commit 4cd7c9479aff ("IB/mad: Add support for additional MAD info
>> to/from drivers") which adds a BUG_ON() for a sanity check, rather than just
>> returning -EINVAL or something sane like that.
>>
>> I'm getting *real* tired of that BUG_ON() shit. I realize that infiniband is a
>> niche market, and those "commercial grade" niche markets are more-than-
>> used-to crap code and horrible hacks, but this is still the kernel. We don't add
>> random machine-killing debug checks when it is *so* simple to just do
>>
>>         if (WARN_ON_ONCE(..))
>>                 return -EINVAL;
>>
>> instead.
>
> Please accept my apologies.  The original patch used WARN_ON but I was advised to use BUG_ON in a review and I should have thought about it more rather than blindly make the change.


Ira,

Can you please point me to the review thread where this advise was
made? I can't track it. In internal reviews I always fight with
developers that put BUG_ON assertions whenever something goes wrong,
I'd like to see on what context this feedback was provided to you.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
