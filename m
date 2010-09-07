From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: Multicast group pre-creation for TopSpin old stack
Date: Tue, 7 Sep 2010 19:51:13 +0300
Message-ID: <20100907165113.GH11502@me>
References: <4C835DDF.6000809@dev.mellanox.co.il>
 <20100906164327.GD11502@me>
 <AANLkTinG2XEhJkYYf-kZGYx7h8wJnBcywMa4AS-KaVh4@mail.gmail.com>
 <adazkvul8ay.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adazkvul8ay.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17:13 Mon 06 Sep     , Roland Dreier wrote:
>  > It's been carried forward just in case anyone was still running the
>  > old TS stack. It's always hard to determine the negative (when no one
>  > is using it any longer) (with the latest OpenSM) but it may be high
>  > time to deprecate this. Is anyone still using the old TS stack ? If
>  > so, is it used with OpenSM ?
>  > 
>  > Maybe Roland has insight into whether the old TS stack might be being
>  > used with (the latest) OpenSM.
> 
> Seems a fairly remote possibility but on the other hand I guess I could
> see someone buying old Topspin equipment on ebay and wanting to use it
> with modern software.

As far as I could understand this TS multicast group only impacts IPoIB
communication between two TS stack clients. If so then it is likely that
just using old Topspin switch will not activate this flow anyway. Right?

> In any case, if carrying this workaround forward
> costs anything, I think it could be dropped.

Ok, I think we can remove this then.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
