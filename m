From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Tue, 31 Mar 2015 23:28:47 +0300
Message-ID: <CAJ3xEMgm+6t1OSMZFJ41Hr4=8B1cKP+5svwc38Lg0wfpCZMO=g@mail.gmail.com>
References: <20150330.233602.155832546277570456.davem@davemloft.net>
	<CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g@mail.gmail.com>
	<CAJ3xEMjfbxt2Ouh4bhuf3_LMc7qY807h6FryvdCr0rr_gdiZAw@mail.gmail.com>
	<20150331.114824.651005354305268415.davem@davemloft.net>
	<1828884A29C6694DAF28B7E6B8A82373A8FBB790@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBB790-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 31, 2015 at 8:27 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:


> I honestly think part of the issue here is general approach being taken by the rdma stack, which is to expose every hardware specific component that a vendor might define through the interfaces up to the consumers.

Sean,

I must disagree. You made this claim back when we submitted the IB
core patch which adds support for signature, protection etc offloads
(commit 1b01d33560e7 "IB/core: Introduce signature verbs API" and the
detailed replied you got were explaining that

1. this allows to offload SCSI T10 signature for RDMA block storage
protocols such as SRP and iSER
2. SCSI, SRP and iSER are all industry standards
3. T10 offload is done also by competing technologies such as Fibre-Channel
4. nothing, but exactly nothing in the verbs API is tied to specific
HCA implementation
5. etc

Very similar arguments would apply to the ODP submission.

So examples please!

Or.

This results in unwieldy interfaces that are under constant churn,
with no clear direction.  If most submissions to the rdma stack were
contained the lower-level drivers, I don't know that we would have the
issues that we do.  But a significant percentage of rdma patches
modify the rdma core software layer, which threaten the stability of
the entire stack.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
