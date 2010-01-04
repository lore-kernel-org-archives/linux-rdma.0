From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_slvl_map_rcv.c: verify port number values
 received from network
Date: Mon, 4 Jan 2010 22:03:07 +0200
Message-ID: <20100104200307.GL26940@me>
References: <20091201194110.GA26753@comcast.net>
 <20091229150528.GV26940@me>
 <20091229150735.GX26940@me>
 <f0e08f230912300809l7c794daat9490c64a2cf63525@mail.gmail.com>
 <20091230162745.GZ26940@me>
 <f0e08f230912300856v188d5900u9d82c94f5f9ae4a6@mail.gmail.com>
 <20091230194335.GB26940@me>
 <f0e08f230912310648m4b03b9bdq92394a61866f0e26@mail.gmail.com>
 <20100103170236.GF26940@me>
 <f0e08f231001041112k4cb7742bwb5ae7cade8704082@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231001041112k4cb7742bwb5ae7cade8704082-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 14:12 Mon 04 Jan     , Hal Rosenstock wrote:
> >>
> >> If we are worrying about this as a general principle, there are more
> >> places to bullet proof like this.
> >
> > Likely so and it would be good to fix all of them.
> 
> Have you done a code review/inspection for such cases ?

No, I've never hunted this specially, perhaps fixed couple of such
occasionally (like this one).

> I think there are more unprotected cases than protected ones.

Have you done a code review/inspection?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
