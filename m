From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups -
 suggesting BOF during OFA conf to further discuss that
Date: Wed, 24 Apr 2013 02:24:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD1E64F@ORSMSX109.amr.corp.intel.com>
References: <CAJZOPZLVyYODJ=z6KDfx0UJtaHpA7nUt2kwadEugpV1LWxhEMw@mail.gmail.com>
	<CAJZOPZKwH66uEukqDSvV+4-z+RhroOB1a0AiWBvdq7D3mso7gQ@mail.gmail.com>
 <CAJZOPZL1eminwg+MVAC+8y4Pg3Nff=aeMN9ic57SB3cRAg8Hnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZL1eminwg+MVAC+8y4Pg3Nff=aeMN9ic57SB3cRAg8Hnw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org \"Shlomo Pongratz\"" <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Mon, Apr 22, 2013 at 7:46 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Sean, Tzahi -- I understand now that there have been few talkings @
> > the OFA meeting re this patch set. So what's the way to move forward,
> > any concrete feedback that needs to be addressed here?  This series is
> > hanging since May 2012 and I'd like to see it gets in for 3.10, now if
> > indeed Sean is OK with the general framework, please suggest.
> 
> Sean,
> 
> I understand that following some conversations help at the OFA
> meetings you kind of took back the concerns you raised regarding the
> concept of the verbs level QP group which is used by this series to
> implement RSS and TSS, can you acknoledge that?

No - I agree with the RSS/TSS concept.  That I've never had an issue with.  My issue is that the current verbs API appears to be a poor fit.  I don't have a good answer for an alternative.

Conceptually, RSS/TSS are a set of send/receive work queues all belonging to the same transport level address.  There's no parent-child relationship or needed pairing of send and receive queues together in order to form a group.

Personally, I'd like to see a way that better captures the notion of a 'set of work queues with the same address'.  For example, it makes more sense to me if a user created/destroyed the work queues together, and if the WQs were viewed as being in a single state (INIT, RTR, RTS...).

I'm just thinking out loud here, hoping that it spurs ideas, but if we added a call like:

struct ib_qp *ib_create_wq_array/set/group(...);

then added the ability to specify which WQ a specific send or receive should be posted to, it may do a better job of capturing RSS/TSS concepts, but still make use of the existing calls.  (Underneath this, the driver can allocate actual QPs  with sequential QPNs or whatever is required, but that's not exposed.)  Obviously, I haven't thought through specifics.

I'll try to meet up with Diego and Tzahi tonight or tomorrow to discuss this further.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
