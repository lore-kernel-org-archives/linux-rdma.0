From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 00/10] Introduce Signature feature
Date: Wed, 11 Dec 2013 19:26:17 +0200
Message-ID: <CAJZOPZLctOXBJN596gr5sCWQ8F=QQPJ_9VpoZmMhJVc2XwS9qA@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237388D031C4@ORSMSX109.amr.corp.intel.com>
	<52847BF8.60401@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388D0463F@ORSMSX109.amr.corp.intel.com>
	<CAJZOPZLpy8a-uUFhT+bvzd51T7jyV0Osdpz-Muc-1q0du7td3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLpy8a-uUFhT+bvzd51T7jyV0Osdpz-Muc-1q0du7td3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nicholas Bellinger <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 14, 2013 at 10:11 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Nov 14, 2013 at 9:03 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>> To begin with T10 DIF **is** industry standard, which is to be used in
>>> production storage systems, the feature here is T10 DIF acceleration for
>>> upstream kernel storage drivers such as iSER/SRP/FCoE initiator/targets
>>> that use RDMA and are included in commercial distributions which are
>>> used by customers. Note that this/similar feature is supported by some
>>> FC cards too, so we want RDMA to be competitive.
>
>> I wasn't talking about whether T10 DIF is a standard.  I was talking about *how* it is exposed through verbs.  That 'how' is what's vendor specific.  The same is true of flow steering, SRQ is standard but IB specific, the same with XRC - which was vendor specific first then standardized, the IP CSUM send flag is vendor specific, 'fast' registration is vendor specific...
>
> Again, for T10 we claim that nothing in how its exposed through the
> proposed verbs is specific to vendor (e.g Mellanox) or to a specific
> hardware brand (e.g ConnectIB) of a vendor, and if you think
> otherwise, we'll love to hear that.

Hi Roland, these patches are in the air for two months (V0 posted Oct
15th http://marc.info/?l=linux-rdma&m=138185152212490&w=2)
and not a word from you. Sean raised some concerns for which we
replied in detail and we'd like to get your maintainer say, 3.14 is
coming
closer, if something needs to be changed/fixed we need to know that
asap so there's enough time to do that  for 3.14, if its helps
this is the V3 thread with the latest discussion
http://marc.info/?t=138383972100009&r=1&w=2 , we have some minor fixes
which
can be posted in the form of V4, but I don't see the point to do that
before we get any feedback from you on the current debate.

Or.


>
> As for the other examples (and yes it makes sense to chase them one by
> one here even if we end up little lengthy):
>
> SRQ is for all IB cards and IB/IBoE are central enough in the RDMA
> stack... such that even if (say) 5-10 features (and there are less)
> features are IB/IBoE specific it makes sense to expose them through
> the verbs API. We have device capabilities for that end, so the
> ULP/Application never asks "hey, what vendor/card is that?" but rather
> "is the driver supporting feature X?".
>
> As you said XRC was standardized through IBTA so nothing to bother.
>
> I don't see why you consider IP CSUM to be vendor specific. To compete
> with any Ethernet card dated to the last 10 years, if IB HW vendor
> wants to support TCP/IP networking ala IPoIB they pretty much need to
> implement TCP/IP stateless offloads, namely TX/RX checksum, LSO and
> RSS. And same goes for drivers that support RAW_PACKET Ethernet QP for
> user space applications that offloads TCP/IP.
>
> Fast registration is all but vendor specific being part of both iWARP
> and IB specs (see the BMME - Base Memory Management Extensions section
> in the IBTA spec).
>
>
>> I'm not suggesting that these features shouldn't exist, I'm just questioning if the goal of verbs should simply be to expose every hardware knob that a ULP can fiddle.  Maybe the answer is yes, but let's at least ask the question.
>
> Indeed some HW special knobs might not play well into verbs and in
> that case the vendor might need to give them away or support them only
> on prop. stacks or whatever solution we can think of, but not T10...
>
>> As a random, made up on the spot thought, what if IPoIB were architected so that there was a device specific component to it, instead of it pretending that some vendor feature exposed through verbs was a generic RDMA capability?  IPoIB acceleration features could still be used.
>
> Could be, IPoIB is there for almost ten years (since 2.6.12) and if we
> don't make it to bring the driver into providing 56/100/200Gbs in the
> next 1-2 years this could be nice out of the box direction to go to.
>
> But I don't think it applies to the T10 case, at least where it stands
> now. Its a new feature whose related verbs are not tied to some
> vendor, so lets get it in, and if after some time we see some
> performance drawbacks who originate in the embedding into verbs, we
> can do this possible breakdown you suggest.
>
>
>>> This work is part of larger efforts which are done nowadays in other
>>> parts of the kernel such as the block layer, the upstream kernel target
>>> and more to support T10, its "just" the RDMA part.
>
>> How does the RDMA part tie into any of the other work being done in other parts of the kernel?
>
> T10 touches few areas in the storage stack, T10 && RDMA is when you
> look on  SAN (Storage Area Networks) drivers. E.g in the same manner
> that FC driver needs to play well with back-end storage drivers when
> the FC code submits the the pages received from the network that
> contain data and signature blocks into the block layer, RDMA has to do
> that too. Since this area is under development and things need to play
> well, there is interaction between the RDMA T10 developer to the
> upstream SCSI target maintainer to folks which are involved with the
> block layer and more storage drivers.
>
> Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
