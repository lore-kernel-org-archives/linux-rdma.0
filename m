From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Tue, 31 Mar 2015 17:27:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FBB790@ORSMSX109.amr.corp.intel.com>
References: <20150330.233602.155832546277570456.davem@davemloft.net>
	<CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g@mail.gmail.com>
	<CAJ3xEMjfbxt2Ouh4bhuf3_LMc7qY807h6FryvdCr0rr_gdiZAw@mail.gmail.com>
 <20150331.114824.651005354305268415.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150331.114824.651005354305268415.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> It doesn't take a lot of time to do this work, especially if you use
> the correct tools.  I can review and apply 100 patches a day, even
> when I'm on vacation.  I'm an extreme example, but what you're doing
> right now Roland is not acceptable and is not in agreement with your
> claims about how much you care about this subsystem.

I honestly think part of the issue here is general approach being taken by the rdma stack, which is to expose every hardware specific component that a vendor might define through the interfaces up to the consumers.  This results in unwieldy interfaces that are under constant churn, with no clear direction.  If most submissions to the rdma stack were contained the lower-level drivers, I don't know that we would have the issues that we do.  But a significant percentage of rdma patches modify the rdma core software layer, which threaten the stability of the entire stack.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
