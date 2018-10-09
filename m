From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v3 1/2] Driver core: add bus_find_device_by_fwnode
Date: Tue, 9 Oct 2018 11:48:19 -0600
Message-ID: <CANLsYkxcUvBBFRFD9Vco559Y5LFw=X0H3Lyzm=nFat6z5yH44g@mail.gmail.com>
References: <1539080245-25818-1-git-send-email-svellattu@mvista.com>
 <20181009172726.GA2182@xps15> <CAJZ5v0gckkg0jyTc7=JYPpUruQQXL_FhEjm03-0mrFcxH60cHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJZ5v0gckkg0jyTc7=JYPpUruQQXL_FhEjm03-0mrFcxH60cHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Silesh C V <svellattu@mvista.com>, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-spi@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>, Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Yisen Zhuang <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Mark Brown <broonie@kernel.org>, David Miller <davem@>
List-Id: linux-rdma@vger.kernel.org

On Tue, 9 Oct 2018 at 11:39, Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Tue, Oct 9, 2018 at 7:27 PM Mathieu Poirier
> <mathieu.poirier@linaro.org> wrote:
> >
> > Hi Silesh,
> >
> > On Tue, Oct 09, 2018 at 03:47:24PM +0530, Silesh C V wrote:
> > > Some drivers need to find the device on a bus having a specific firmware
> > > node. Currently, such drivers have their own implementations to do this.
> > > Provide a helper similar to bus_find_device_by_name so that each driver
> > > does not have to reinvent this.
> > >
> > > Signed-off-by: Silesh C V <svellattu@mvista.com>
> > > ---
> > > Changes since v2:
> > >       - make use of dev_fwnode in match_fwnode.
> > >
> > >  drivers/base/bus.c     | 20 ++++++++++++++++++++
> > >  include/linux/device.h |  3 +++
> > >  2 files changed, 23 insertions(+)
> > >
> > > diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> > > index 8bfd27e..a2f39db 100644
> > > --- a/drivers/base/bus.c
> > > +++ b/drivers/base/bus.c
> > > @@ -17,6 +17,7 @@
> > >  #include <linux/string.h>
> > >  #include <linux/mutex.h>
> > >  #include <linux/sysfs.h>
> > > +#include <linux/property.h>
> > >  #include "base.h"
> > >  #include "power/power.h"
> > >
> > > @@ -373,6 +374,25 @@ struct device *bus_find_device_by_name(struct bus_type *bus,
> > >  }
> > >  EXPORT_SYMBOL_GPL(bus_find_device_by_name);
> > >
> > > +static int match_fwnode(struct device *dev, void *fwnode)
> > > +{
> > > +     return dev_fwnode(dev) == fwnode;
> > > +}
> > > +
> > > +/**
> > > + * bus_find_device_by_fwnode - device iterator for locating a particular device
> > > + * having a specific firmware node
> > > + * @bus: bus type
> > > + * @start: Device to begin with
> > > + * @fwnode: firmware node of the device to match
> > > + */
> > > +struct device *bus_find_device_by_fwnode(struct bus_type *bus, struct device *start,
> > > +                                     struct fwnode_handle *fwnode)
> >
> > I get the following when running checkpatch on your set:
> >
> > mpoirier@xps15:~/work/linaro/coresight/kernel-maint$ ./scripts/checkpatch.pl
> > 0001-Driver-core-add-bus_find_device_by_fwnode.patch
> > WARNING: line over 80 characters
>
> Lines longer than 80 chars often are legitimate.  No need to send
> extra reports about those cases in general.

In this case I don't see a reason not to abide to the guideline.
Wrapping the function declaration to 80 characters would be easy
without effecting code readability.

Mathieu

>
> Thanks,
> Rafael
