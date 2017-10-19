From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Thu, 19 Oct 2017 00:20:51 -0600
Message-ID: <20171019062051.GC6555@obsidianresearch.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30086B735FD4B5948B521673D14D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CANjDDBhJK=s28zrdCASUVSSeem=NVRWwsHT=jWS2N4jGh2Uvfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBhJK=s28zrdCASUVSSeem=NVRWwsHT=jWS2N4jGh2Uvfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 19, 2017 at 10:02:17AM +0530, Devesh Sharma wrote:

> > Before I post the patch,
> > We found that bnx_re driver doesn't set IB_WC_WITH_VLAN in the QP1 wc.
> > Fail to set vlan id and IB_WC_WITH_VLAN flag when incoming QP1 packet in vlan, will fail to search the right GID.
> 
> I am under impression that IB_WC_WITH_VLAN flags was supposed to be
> set only if any vendor's WC reports VLAN-ID, otherwise it had to be
> derived from somewhere else. Are we moving away from this notion?

If your hardware does not report the VLAN, then it cannot set the
flag.

The issue here, is that we need a 100% reliable way to go from a WC to
the gid table index that was used to recieve the packet in the
hardware. The spec is defective here, IMHO, because it does not define
how this case should work.

Ideally hardware will report the index directly in the WC, but AFAIK,
no hardware does this.

Parav is looking at mlx hardware which reports the headers, and I
guess, he is planning to search the GID table in software using the
headers from the WC, GRH, etc.

Not sure what broadcom hardware can do here.

But, the basic principle holds, we *MUST* recover the rx GID index the
hardware used. Tell Parav how to do that for your chip.

If brodcom hardware cannot report the GID index directly, and does not
report all the headers (eg vlan) then it *MUST* reject GID table
configurations that create an ambiguity, eg it cannot allow the same
IP on different VLANs. This is horrible and you should try to avoid
that by having a sensible WC..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
