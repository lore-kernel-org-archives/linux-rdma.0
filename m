From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Help with strange problem passing mlx4 device into kvm guests
Date: Tue, 27 Mar 2012 15:24:37 -0700
Message-ID: <CAL1RGDXXhW84NELRDKfcS8esXzoK8idLXhFjC_YQu01T=dMrQA@mail.gmail.com>
References: <CAL1RGDWeDeua-_nVOC7xh5t7E76CJVNGXaMfBxnG==9Wj5z=RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWeDeua-_nVOC7xh5t7E76CJVNGXaMfBxnG==9Wj5z=RQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 29, 2012 at 6:29 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>=
 wrote:

> I'm having a strange problem passing an mlx4 device into a kvm guest.
> The device in question is:
>
> =A0 =A005:00.0 InfiniBand [0c06]: Mellanox Technologies MT26428 [Conn=
ectX
> VPI PCIe 2.0 5GT/s - IB QDR / 10GigE] [15b3:673c] (rev b0)
>
> running the latest (I believe) FW version 2.9.1000.
>
> The symptom of the problem is
> that when the mlx4_core driver starts, I get normal output like
>
> =A0 =A0mlx4_core 0000:00:04.0: FW version 2.9.1000 (cmd intf rev 3), =
max
> commands 16
> =A0 =A0mlx4_core 0000:00:04.0: Catastrophic error buffer at 0x1f020, =
size
> 0x10, BAR 0
> =A0 =A0mlx4_core 0000:00:04.0: FW size 385 KB
>
> up until the driver tries to enable interrupts, when I get a long
> stream of
>
> =A0 =A0Completion event for bogus CQ 00000000
>
> and then it gives up because the NOP command interrupt test
> fails.

Just to follow up on this, it turns out this is a bug in how the
Mellanox firmware deals with FLR (function level reset).  The
=46W will be fixed in a future release, but in the meantime I've
been able to work around this with the following hack (probably
going to be whitespace destroyed by the gmail web interface
I'm using, but you should be able to recreate it if you care):

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3085,6 +3085,12 @@ static int reset_intel_82599_sfp_virtfn(struct
pci_dev *dev, int probe)
        return 0;
 }

+static int reset_mellanox_dev(struct pci_dev *dev, int probe)
+{
+       /* skip FLR, it busts the Mellanox FW */
+       return 0;
+}
+
 #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed

 static const struct pci_dev_reset_methods pci_dev_reset_methods[] =3D =
{
@@ -3092,6 +3098,8 @@ static const struct pci_dev_reset_methods
pci_dev_reset_methods[] =3D {
                 reset_intel_82599_sfp_virtfn },
        { PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
                reset_intel_generic_dev },
+       { PCI_VENDOR_ID_MELLANOX, 0x673c,
+               reset_mellanox_dev },
        { 0 }
 };
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
