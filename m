From: Tzahi Oved <tzahio.lists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 00/10] Introduce Signature feature
Date: Thu, 14 Nov 2013 23:39:13 +0200
Message-ID: <52854301.8060509@gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237388D031C4@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D031C4-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nicholas Bellinger <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14/11/2013 02:19, Hefty, Sean wrote:
>> The patch series is around for couple of weeks already and went
>> through the review of Sean and Bart, with all their feedback being
>> applied. Also Sagi and Co enhanced krping to fully cover (and test...)
>> the proposed API and driver implementation @
>> git://beany.openfabrics.org/~sgrimberg/krping.git
> Somewhat separate from this specific patch, this is my concern.
>
> There are continual requests to modify the kernel verbs interfaces.  These requests boil down to exposing proprietary capabilities to the latest version of some vendor's hardware.  In turn, these hardware specific knobs bleed into the kernel clients.
Disagree, the verbs changes proposal in the signature case where 
submitted as an RFC for few weeks so all vendors may comments and ask 
for changes. Isn't that what open source development is all about. We 
can't stop progress, we open new functionalists and features for 
everyone to comment and agree on mutual interface. Is there other way u 
had in mind we should define non vendor specific API? we will be glad to 
collaborate but please come with alternate process u think is best. Such 
comments only hold back new functionalities from being accepted and 
backs down Verbs API progress.
> At the very least, it seems that there should be some sort of discussion if this is a desirable property of the kernel verbs interface, and if this is the architecture that the kernel should continue to pursue.  Or, is there an alternative way of providing the same ability of coding ULPs to specific HW features, versus plugging every new feature into 'post send'?
Current Verbs semantics define post send as the operation aggregator 
that enables posting list of WQE in single call so users can serialize 
multiple operation requests and post in single API call. Since signature 
is mainly an enhancement of existing RDMA operation, seems like it fits 
best there. Defining more specific APIs per application type: Storage, 
Cloud, HPC, .. is indeed important and in the process of being defined 
as part of the Open Framework working group u r co-chairing. Thus, it 
doesn't make sense to break the post send verbs semantics in this case.

Tzahi
>
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
