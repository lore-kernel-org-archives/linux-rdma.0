From: Wei Lin Guay <weilin-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: RE: Question on statistics per port VL - performance management
Date: Sun, 19 Jun 2011 19:51:29 +0200
Message-ID: <876fb18a9d5b877013acd7a22ce49fe7@mail.gmail.com>
References: <c2cf411ce0324c1074597e49ffc6daa6@mail.gmail.com> <4DFD8417.90309@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFD8417.90309-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks, Or!

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
Sent: Sunday, June 19, 2011 7:08 AM
To: Wei Lin Guay
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Question on statistics per port VL - performance management

Wei Lin Guay wrote:
> Is there a quick way to obtain the performance counter for each VL on
each
> port? I saw there are optional performance management attributes (such
as
> PortVLOpPackets, PortVLOpData) from IB spec. Do Mellanox CX2 PMA and
> Infiniscale-IV switch support those performance management MAD?

For IS4 you can query per SL receive/transmit counters, see the man
pages of vendstat for the initialization and perfquery for the usage

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
