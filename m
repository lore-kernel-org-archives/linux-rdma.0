From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCHv1] RDMA/ocrdma: Fixed CONFIG_VLAN_8021Q.
Date: Wed, 15 Aug 2012 21:10:53 -0700
Message-ID: <CAL1RGDWC1fCb-NCkuS64RWkvN2hrkfoohEYyJSBQrvyp=3kmEQ@mail.gmail.com>
References: <79b2796a-f2a1-4ca4-8f19-17729e18af48@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <79b2796a-f2a1-4ca4-8f19-17729e18af48-nbYkmrCdWxmgMrCBcu8zE0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 11, 2012 at 6:28 AM, Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> +static struct net_device *ocrdma_get_real_netdev(struct net_device *netdev)
> +{
> +#if IS_ENABLED(CONFIG_VLAN_8021Q)
> +       return vlan_dev_real_dev(netdev);
> +#else
> +       return netdev;
> +#endif
> +}

As I said before, I don't think this wrapper is needed, and even if it were,
it would be much better to write it without using the preprocessor (as I said,
you can do "if (IS_ENABLED(...))" in C code now too).

I'm going to stick to my simpler version unless there is something wrong
with it...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
