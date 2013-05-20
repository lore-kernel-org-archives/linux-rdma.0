From: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] add RAW Packet QP type
Date: Mon, 20 May 2013 17:43:08 -0500
Message-ID: <20130520224308.GA16639@sbohrermbp13-local.rgmadvisors.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com>
 <4F158ED7.3080405@opengridcomputing.com>
 <4F159AEB.1060603@mellanox.com>
 <4F15A008.9010303@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F15A008.9010303-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Felix Marti <felix-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 17, 2012 at 10:21:28AM -0600, Steve Wise wrote:
> On 01/17/2012 09:59 AM, Or Gerlitz wrote:
> >On 1/17/2012 5:08 PM, Steve Wise wrote:
> >>I think this series should add some new send flags for HW that
> >>does checksum offload [...] also, on ingress, most hardware can
> >>do INET checksum validation, and a way to indicate the results
> >>to the application is needed.  Perhaps flags in the CQE? [...]
> >>another form of HW assist is with VLAN insertion/extraction.
> >>The API should provide a way to specify if a VLAN ID should be
> >>inserted by HW and removed from a packet on ingress (and passed
> >>to the app via the CQE).  In fact, we probably want a way to
> >>associate a VLAN with a RAW QP, maybe as a QP attribute?
> >
> >Hi Steve,
> >
> >Nice to see how a discussion is quickly revived when the subject
> >is close to people's needs... anyway, yep, sure, this submission
> >allows for basic functionality, as I mentioned and there's more to
> >add here, but this could (should...) be done gradually,  i.e in
> >steps that adds on the basic patch. Now to the points you've
> >raised:
> >
> >Sure, we want to be able to do checksum offload on TX and on RX as
> >well. Adding checksum offload support will be done with a patch to
> >libibverbs which is similar in spirit to commit e0605d "IB/core:
> >Add IP checksum offload support" subject to reporting the RX
> >checksum okay through new IB_WC_IP_CSUM_OK bit in ibv_wc->wc_flags
> >along the lines of the patch I sent last week to the kernel. So we
> >will have a new device capability and two new bit flags
> >IB_SEND_IP_CSUM and IB_WC_IP_CSUM_OK, no ABI breaking... happy.
> 
> Sounds good, with the caveat that we need more bits to specify L4 CSUM generation as well as L3 (and L2 CRC).

Hi Or,

I appologize if I missed it, but did any support for L3/L4 CSUM
generation get added?  Doesn't look like the upstream libibverbs has
it, and I don't seem to see any patches floating around.

Thanks,
Shawn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
