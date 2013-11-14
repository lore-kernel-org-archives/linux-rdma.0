From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 00/10] Introduce Signature feature
Date: Thu, 14 Nov 2013 11:21:51 +0200
Message-ID: <5284962F.10506@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237388D031C4@ORSMSX109.amr.corp.intel.com> <52847BF8.60401@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52847BF8.60401-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nicholas Bellinger <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/14/2013 9:30 AM, Or Gerlitz wrote:
> On 14/11/2013 02:19, Hefty, Sean wrote:
>>> The patch series is around for couple of weeks already and went 
>>> through the review of Sean and Bart, with all their feedback being 
>>> applied. Also Sagi and Co enhanced krping to fully cover (and 
>>> test...) the proposed API and driver implementation
>> Somewhat separate from this specific patch, this is my concern.
>>
>> There are continual requests to modify the kernel verbs interfaces.  
>> These requests boil down to exposing proprietary capabilities to the 
>> latest version of some vendor's hardware. In turn, these hardware 
>> specific knobs bleed into the kernel clients.
>>
>> At the very least, it seems that there should be some sort of 
>> discussion if this is a desirable property of the kernel verbs 
>> interface, and if this is the architecture that the kernel should 
>> continue to pursue.  Or, is there an alternative way of providing the 
>> same ability of coding ULPs to specific HW features, versus plugging 
>> every new feature into 'post send'?
>
> Sean,
>
> Being concrete + re-iterating  and expanding what I wrote you earlier 
> on the V1 thread @ 
> http://marc.info/?l=linux-rdma&m=138314853203389&w=2when you said
>
> Sean > Maybe we should rethink the approach of exposing low-level 
> hardware constructs to every
> Sean > distinct feature of every vendor's latest hardware directly to 
> the kernel ULPs.
>
> To begin with T10 DIF **is** industry standard, which is to be used in 
> production storage systems, the feature here is T10 DIF acceleration 
> for upstream kernel storage drivers such as iSER/SRP/FCoE 
> initiator/targets that use RDMA and are included in commercial 
> distributions which are used by customers. Note that this/similar 
> feature is supported by some FC cards too, so we want RDMA to be 
> competitive.
>
> This work is part of larger efforts which are done nowadays in other 
> parts of the kernel such as the block layer, the upstream kernel 
> target and more to support T10, its "just" the RDMA part.
>
> Sagi and team made great effort to expose API which isn't tied to 
> specific HW/Firmware API. And in that respect, the verbs API is 
> coupled with industry standards and by no means with specific HW 
> features. Just as quick example, the specific driver/card (mlx5 / 
> ConnectIB) for which the news verbs are implemented uses three objects 
> for its T10 support, named BSF, KLM and PSV - you can be sure, and 
> please check us  that there is no sign for them in the verbs API, they 
> only live within the mlx5 driver.
>
> If you see a vendor specific feature/construct that appears in the 
> proposed verbs API changes, let us know.
>
> > [...] versus plugging every new feature into 'post send'?
>
> Its a new feature indeed but its a feature which comes into play when 
> submitting RDMA work-requests to the HCA and
> for performance reasons must be subject to pipe-lining in the form of 
> batched posting and hence has very good fit as
> a sub operation of post-send.
>
> Sean > There are continual requests to modify the kernel verbs 
> interfaces. These requests boil down to exposing proprietary capabilities
> Sean >  to the latest version of some vendor's hardware. In turn, 
> these hardware specific knobs bleed into the kernel clients.
>
> non-T10 examples (please) ?!
>
> Or.

Hey Sean,

Just to add on Or's input,
I really don't agree this is some specific HW capability exposed to 
ULPs. This feature allows offloading data-integrity handling over RDMA 
which is a wider concept then just T10-DIF (although we currently expose 
T10-DIF alone).
Signature verbs API does not introduce something specific to Mellanox, 
we think API is generic enough to allow each vendor to support signature 
with some degree of freedom.
Just needs to implement the 3-steps: create signature enabled MR, bind 
MR to signature attributes (work-request) and check for signature status 
at the end of the transaction.

Regarding plugging into post_send, The signature operation is a 
fast-path operation and I agree with Or regarding the value of batching 
work requests.
Moreover, I think this is a separate discussion. If we agree on another 
API posting on the send-queue, it will require work also for migrating 
fastreg and bind_mw extensions.
So how about going with current framework, and start a discussion on 
your concern "taking non-SEND WR extensions out of post_send".

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
