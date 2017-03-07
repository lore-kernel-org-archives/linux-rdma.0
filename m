From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 1/2] device: Stop requiring that struct device is embedded
 in struct pci_dev
Date: Tue, 7 Mar 2017 03:21:24 +0000
Message-ID: <VI1PR0502MB3008F125A4E754A1505663A1D12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
 <20170307003549.3872-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170307003549.3872-2-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> Sent: Monday, March 6, 2017 6:36 PM
> To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>; Sebastian Ott
> <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>; Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Bart Van Assche
> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>;
> Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>; David Woodhouse
> <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; H . Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>; Ingo Molnar
> <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
> Subject: [PATCH 1/2] device: Stop requiring that struct device is embedde=
d in
> struct pci_dev
>=20
> The dma mapping operations of several architectures and also of several I=
/O
> MMU implementations need to translate a struct device pointer into a stru=
ct
> pci_dev pointer. This translation is performed by to_pci_dev(). That macr=
o
> assumes that struct device is embedded in struct pci_dev. However, that i=
s
> not the case for the device structure in struct ib_device. Since that dev=
ice

Why can't ib subsystem pass device structure that is embedded in pci_dev wh=
en it makes calls to dma_map APIs?
The whole point of clean up was to avoid an if() condition in hot datapath.
If we invoke dma_map_ and friend functions with right device, shouldn't it =
work?
That avoids the if() condition as well and avoids changing core of Linux li=
ke done in this bug fix.
I think ib_device should store the right struct device pointer that needs t=
o go to dma_apis, rather than including pci_dev structure pointer in device=
 core=20
layer.

Pseudo example code:
struct ib_device {
	struct device *dma_device;
};

ib_dma_unmap_single() which had if(), that got removed with dma_unmap_singl=
e() with cleanup patch.

Instead of,
static inline void ib_dma_unmap_single(struct ib_device *dev,
                                       u64 addr, size_t size,
                                       enum dma_data_direction direction)
{
	dma_unmap_single(&dev->dev, addr, size, direction);
}

Why can't we do this?

static inline void ib_dma_unmap_single(struct ib_device *dev,
                                       u64 addr, size_t size,
                                       enum dma_data_direction direction)
{
	dma_unmap_single(dev->dma_device, addr, size, direction);
}

This avoids increasing all device size by 8 bytes in system.
It also clean approach where core device structure doesn't have to bother f=
or pci_dev.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
