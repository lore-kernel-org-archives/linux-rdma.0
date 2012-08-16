From: <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCHv1] RDMA/ocrdma: Fixed CONFIG_VLAN_8021Q.
Date: Thu, 16 Aug 2012 12:15:55 +0000
Message-ID: <5D6C0ABE6A236946864C45679362BBE20AD79A73@CMEXMB1.ad.emulex.com>
References: <79b2796a-f2a1-4ca4-8f19-17729e18af48@exht1.ad.emulex.com>
 <CAL1RGDWC1fCb-NCkuS64RWkvN2hrkfoohEYyJSBQrvyp=3kmEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWC1fCb-NCkuS64RWkvN2hrkfoohEYyJSBQrvyp=3kmEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: Roland Dreier [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org]
> Sent: Thursday, August 16, 2012 9:41 AM
> To: Pandit, Parav
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCHv1] RDMA/ocrdma: Fixed CONFIG_VLAN_8021Q.
> 
> On Sat, Aug 11, 2012 at 6:28 AM, Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> wrote:
> > +static struct net_device *ocrdma_get_real_netdev(struct net_device
> > +*netdev) { #if IS_ENABLED(CONFIG_VLAN_8021Q)
> > +       return vlan_dev_real_dev(netdev); #else
> > +       return netdev;
> > +#endif
> > +}
> 
> As I said before, I don't think this wrapper is needed, and even if it were, it
> would be much better to write it without using the preprocessor (as I said,
> you can do "if (IS_ENABLED(...))" in C code now too).
> 
> I'm going to stick to my simpler version unless there is something wrong with
> it...
[PP] O.k. I am fine with your solution too.

> 
>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
