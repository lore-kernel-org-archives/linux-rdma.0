From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v3 1/2] Driver core: add bus_find_device_by_fwnode
Date: Tue, 9 Oct 2018 12:20:29 +0200
Message-ID: <CAJZ5v0joQi-N=-6TUMUQXQbxYtvS2AOLJD3KUqUAL-w9hJTQeg@mail.gmail.com>
References: <1539080245-25818-1-git-send-email-svellattu@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1539080245-25818-1-git-send-email-svellattu@mvista.com>
Sender: netdev-owner@vger.kernel.org
To: svellattu@mvista.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-i2c <linux-i2c@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-spi <linux-spi@vger.kernel.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Wolfram Sang <wsa@the-dreams.de>, oulijun@huawei.com, xavier.huwei@huawei.com, yisen.zhuang@huawei.com, salil.mehta@huawei.com, srinivas.kandagatla@linaro.org, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Mark Brown <broonie@ke>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 9, 2018 at 12:18 PM Silesh C V <svellattu@mvista.com> wrote:
>
> Some drivers need to find the device on a bus having a specific firmware
> node. Currently, such drivers have their own implementations to do this.
> Provide a helper similar to bus_find_device_by_name so that each driver
> does not have to reinvent this.
>
> Signed-off-by: Silesh C V <svellattu@mvista.com>

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
> Changes since v2:
>         - make use of dev_fwnode in match_fwnode.
>
>  drivers/base/bus.c     | 20 ++++++++++++++++++++
>  include/linux/device.h |  3 +++
>  2 files changed, 23 insertions(+)
>
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 8bfd27e..a2f39db 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -17,6 +17,7 @@
>  #include <linux/string.h>
>  #include <linux/mutex.h>
>  #include <linux/sysfs.h>
> +#include <linux/property.h>
>  #include "base.h"
>  #include "power/power.h"
>
> @@ -373,6 +374,25 @@ struct device *bus_find_device_by_name(struct bus_type *bus,
>  }
>  EXPORT_SYMBOL_GPL(bus_find_device_by_name);
>
> +static int match_fwnode(struct device *dev, void *fwnode)
> +{
> +       return dev_fwnode(dev) == fwnode;
> +}
> +
> +/**
> + * bus_find_device_by_fwnode - device iterator for locating a particular device
> + * having a specific firmware node
> + * @bus: bus type
> + * @start: Device to begin with
> + * @fwnode: firmware node of the device to match
> + */
> +struct device *bus_find_device_by_fwnode(struct bus_type *bus, struct device *start,
> +                                       struct fwnode_handle *fwnode)
> +{
> +       return bus_find_device(bus, start, (void *)fwnode, match_fwnode);
> +}
> +EXPORT_SYMBOL_GPL(bus_find_device_by_fwnode);
> +
>  /**
>   * subsys_find_device_by_id - find a device with a specific enumeration number
>   * @subsys: subsystem
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 8f88254..09384f6 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -171,6 +171,9 @@ struct device *bus_find_device(struct bus_type *bus, struct device *start,
>  struct device *bus_find_device_by_name(struct bus_type *bus,
>                                        struct device *start,
>                                        const char *name);
> +struct device *bus_find_device_by_fwnode(struct bus_type *bus,
> +                                      struct device *start,
> +                                      struct fwnode_handle *fwnode);
>  struct device *subsys_find_device_by_id(struct bus_type *bus, unsigned int id,
>                                         struct device *hint);
>  int bus_for_each_drv(struct bus_type *bus, struct device_driver *start,
> --
> 1.9.1
>
