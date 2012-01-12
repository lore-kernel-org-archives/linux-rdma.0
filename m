From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] IB/qib: detour pcie_caps for certain chip sets
Date: Wed, 11 Jan 2012 23:06:09 -0800
Message-ID: <CAL1RGDXOO6baaET_fCFT3YUsK9aqGkODoHnd1FNwOp_szZO4Gw@mail.gmail.com>
References: <20120112030049.31831.62692.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120112030049.31831.62692.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2012 at 7:00 PM, Mike Marciniszyn
<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> + =A0 =A0 =A0 if (!qib_pcie_caps) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u16 devid =3D parent->device;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((devid >=3D 0x25e2 && devid <=3D 0x=
25fa) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (devid >=3D 0x65e2 && devid <=3D=
 0x65fa) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (devid >=3D 0x4021 && devid <=3D=
 0x402e))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 caps =3D 0;
> + =A0 =A0 =A0 } else

Does this work on systems where the broken chipset might
not be the immediate parent of the qib device (ie there are
some PCIe switches in between)?

Pushing knowledge of completely unrelated devices out into
every device driver looks it will be impossible to maintain.
If you need to know about the whole PCIe fabric to do this
type of tuning, the only way I can see to make this work
is to add some helper functions to set these values for
a given device, and then add all the workaround handling
to the core PCI driver.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
