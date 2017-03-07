From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 1/2] device: Stop requiring that struct device is embedded
 in struct pci_dev
Date: Tue, 7 Mar 2017 05:08:58 +0000
Message-ID: <VI1PR0502MB3008BEC2FB8747DDA40A10FCD12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
 <20170307003549.3872-2-bart.vanassche@sandisk.com>
 <20170307045236.GC3913@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170307045236.GC3913-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Greg,

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> Sent: Monday, March 6, 2017 10:53 PM
> To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Sebastian Ott
> <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>; Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Bjorn Helgaas
> <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Benjamin Herrenschmidt
> <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>; David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>;
> H . Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>; Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>;
> Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
> Subject: Re: [PATCH 1/2] device: Stop requiring that struct device is
> embedded in struct pci_dev
>=20
> On Mon, Mar 06, 2017 at 04:35:48PM -0800, Bart Van Assche wrote:
> > The dma mapping operations of several architectures and also of
> > several I/O MMU implementations need to translate a struct device
> > pointer into a struct pci_dev pointer. This translation is performed
> > by to_pci_dev(). That macro assumes that struct device is embedded in
> > struct pci_dev. However, that is not the case for the device structure
> > in struct ib_device.
>=20
> Then don't blindly cast it backwards!  Fix that up, an ib device should h=
ave
> access to the dma structures that the PCI device it depends on has.
> If not, you need to set that up properly in the IB core, don't mess with =
the
> driver core for this at all.
>=20
I replied with pseudo code in previous reply to Bart to bring back dma_devi=
ce member in the ib_device.
dma_device member was already present in near past of few weeks.
It should be able to work using it without performance impact and without t=
ouching driver core layer like in this patch.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
