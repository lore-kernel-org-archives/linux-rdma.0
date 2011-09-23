From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ib-diags: compatability issue with ibstat
Date: Fri, 23 Sep 2011 08:57:12 -0400
Message-ID: <CAKzyTsw8TKFNPS8QFgjag7XZ77cu=OzofAuAKTr_DQmkPTsogw@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
	<20110921151349.140d95f6.weiny2@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A8237316E6723E@ORSMSX101.amr.corp.intel.com>
	<20110921153254.06c77ebc.weiny2@llnl.gov>
	<20110921223546.GI28454@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110921223546.GI28454-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 21, 2011 at 6:35 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Sep 21, 2011 at 03:32:54PM -0700, Ira Weiny wrote:
>
>> To be clear I am not against using ibverbs on the linux side. =C2=A0=
It
>> sounds like that would be the best move going forward.
>
> Technically umad already needs to use verbs on Linux because that is
> the only way to get the subnet timeout value that is needed to comput=
e
> the MAD RPC timeout. Currently umad ignores this part of IBA ...

Determining the MAD timeout is more complicated than this. Subnet
timeout is insufficient (so you would need more than just this from
verbs - things that would not be part of verbs) if this mechanism were
to be made compliant rather than a configurable timeout as it is now.

-- Hal

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
