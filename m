From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: InfiniBand HCA loopback on a single host (subnet manager needed?)
Date: Wed, 9 Mar 2011 13:24:36 -0500
Message-ID: <AANLkTimTm2UgUr4A_XJYGJpGBnRAFE74Eu6At+n9Xnfd@mail.gmail.com>
References: <alpine.LRH.2.00.1103090903140.15803@pub1.ifh.de>
	<20110309173005.GN22729@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110309173005.GN22729-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Boyanov <boyanov-/DgOsau14IQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 9, 2011 at 12:30 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Mar 09, 2011 at 09:04:39AM +0100, Konstantin Boyanov wrote:
>
>> I think this is achievable on a single host by using the loopback
>> capabilities of the InfiniBand HCA. The problem is, that I was not
>> able to find a comprehensive description of how one sets up such
>> loopback operation on the HCA chip.
>
> To enable loopback I'm pretty sure you need an IB link on the
> card, and a running SM to set the link the ACTIVE.

Also, bringing the link to active, etc. can be done via ibportstate if
you want to avoid SM for some reason. Also, you will need a loopback
plug or cable the port to something otherwise the link won't come up,
etc.

-- Hal

>
> Also, be aware that in my experience loopback is a special case on IB
> cards and the performance is not good, so testing in this manner may
> not be valid.
>
> If you have a dual port card you'd be better off connecting the ports
> together and doing your test from port 1 to port 2.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
