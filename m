From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Help with strange problem passing mlx4 device into kvm guests
Date: Wed, 28 Mar 2012 09:42:31 -0700
Message-ID: <CAL1RGDWw9RDiWfdepkq2nNRkXx5Lch9pKtLGjat4YpXh86ZZyg@mail.gmail.com>
References: <CAL1RGDWeDeua-_nVOC7xh5t7E76CJVNGXaMfBxnG==9Wj5z=RQ@mail.gmail.com>
 <CAL1RGDXXhW84NELRDKfcS8esXzoK8idLXhFjC_YQu01T=dMrQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXXhW84NELRDKfcS8esXzoK8idLXhFjC_YQu01T=dMrQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2012 at 3:24 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>=
 wrote:
> Just to follow up on this, it turns out this is a bug in how the
> Mellanox firmware deals with FLR (function level reset). =A0The
> FW will be fixed in a future release, but in the meantime I've
> been able to work around this with the following hack (probably
> going to be whitespace destroyed by the gmail web interface
> I'm using, but you should be able to recreate it if you care):
>
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3085,6 +3085,12 @@ static int reset_intel_82599_sfp_virtfn(struct
> pci_dev *dev, int probe)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +static int reset_mellanox_dev(struct pci_dev *dev, int probe)
> +{
> + =A0 =A0 =A0 /* skip FLR, it busts the Mellanox FW */
> + =A0 =A0 =A0 return 0;
> +}
> +
> =A0#define PCI_DEVICE_ID_INTEL_82599_SFP_VF =A0 0x10ed
>
> =A0static const struct pci_dev_reset_methods pci_dev_reset_methods[] =
=3D {
> @@ -3092,6 +3098,8 @@ static const struct pci_dev_reset_methods
> pci_dev_reset_methods[] =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 reset_intel_82599_sfp_virtfn },
> =A0 =A0 =A0 =A0{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reset_intel_generic_dev },
> + =A0 =A0 =A0 { PCI_VENDOR_ID_MELLANOX, 0x673c,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 reset_mellanox_dev },
> =A0 =A0 =A0 =A0{ 0 }
> =A0};

And just to be clear, this is in the host kernel to avoid FLR there.
The guest running the standard kernel would never do FLR anyway,
so with the hack above in the host, the standard driver works fine.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
