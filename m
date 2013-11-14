From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 00/10] Introduce Signature feature
Date: Thu, 14 Nov 2013 00:19:26 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D031C4@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nicholas Bellinger <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The patch series is around for couple of weeks already and went
> through the review of Sean and Bart, with all their feedback being
> applied. Also Sagi and Co enhanced krping to fully cover (and test...)
> the proposed API and driver implementation @
> git://beany.openfabrics.org/~sgrimberg/krping.git

Somewhat separate from this specific patch, this is my concern.

There are continual requests to modify the kernel verbs interfaces.  These requests boil down to exposing proprietary capabilities to the latest version of some vendor's hardware.  In turn, these hardware specific knobs bleed into the kernel clients.

At the very least, it seems that there should be some sort of discussion if this is a desirable property of the kernel verbs interface, and if this is the architecture that the kernel should continue to pursue.  Or, is there an alternative way of providing the same ability of coding ULPs to specific HW features, versus plugging every new feature into 'post send'?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
