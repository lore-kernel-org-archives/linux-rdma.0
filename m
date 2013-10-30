From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v1 00/10] Introduce Signature feature
Date: Wed, 30 Oct 2013 17:55:16 +0200
Message-ID: <52712BE4.3060103@mellanox.com>
References: <1382970376-13776-1-git-send-email-sagig@mellanox.com> <5270DF90.8000802@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237388CF28A5@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CF28A5-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 30/10/2013 17:20, Hefty, Sean wrote:
>> The team here enhanced krping to fully cover (and test...) the proposed
>> >API and driver implementation, its (free) under
>> >git://beany.openfabrics.org/~sgrimberg/krping.git
>> >
>> >We'd like to see this landing in 3.13 such that the development of the
>> >upper layers can run for 3.14 and and later kernels. Sagi will postV2
>> >with the two minor changes that came up in Sean's review of V1, thoughts?
> If the upper layers won't be ready until 3.14, why can't these changes go in then?

I explained, we want to see this landing in sooner rather than later to 
avoid triple/quadruple way merge, e.g merge
of code from multiple kernel sub-components in one kernel cycle which is 
complex.

> My biggest issue is that the kernel verbs API is becoming more and more unwieldy, and I have heard requests that even the kernel interfaces need to be easier to use.  The main work request structure used to send a message is around 84 bytes long.  This patch bumps that up another 24 bytes or so.  That's over 100 bytes of control data just to send a message!
>
> Maybe we should rethink the approach of exposing low-level hardware constructs to every distinct feature of every vendor's latest hardware directly to the kernel ULPs.

T10 DIF is industry standard, and it used in advanced commercial 
production storage systems, the feature here is T10 DIF acceleration for 
layers (e.g iser/srp/fcoe initiator/targets) that use RDMA. This feature 
is supported by some FC cards too, so we want RDMA to be competitive. We 
made great effort to expose API which is not tied to specific 
HW/Firmware API.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
