From: Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 2/2] treewide: use bus_find_device_by_fwnode
Date: Wed, 10 Oct 2018 14:05:43 -0500
Message-ID: <CAL_JsqJsF0Zr=chBQ_Euq+27TJftpSR5dpi-tYyiwEFdsEh6vQ@mail.gmail.com>
References: <1539080245-25818-1-git-send-email-svellattu@mvista.com>
 <1539080245-25818-2-git-send-email-svellattu@mvista.com> <20181009174428.GB2182@xps15>
 <CALabi0FgQWGL8KMpCKt9N6Kkoig77LxOsea3Oe47tk5nOH10-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALabi0FgQWGL8KMpCKt9N6Kkoig77LxOsea3Oe47tk5nOH10-Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: svellattu@mvista.com
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>, Linux I2C <linux-i2c@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org, linux-spi <linux-spi@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>, oulijun@huawei.com, xavier.huwei@huawei.com, Yisen Zhuang <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Frank Rowand <frowand.list@gm>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 9, 2018 at 9:59 PM Silesh C V <svellattu@mvista.com> wrote:
>
> Hello Mathieu,
>
> On Tue, Oct 9, 2018 at 11:14 PM Mathieu Poirier
> <mathieu.poirier@linaro.org> wrote:
> >
> >
> > This doesn't apply on linux-next.  This late in the cycle you may want to rebase
> > your work on that tree.
>
> OK. Will send v4 after rebasing onto linux-next.

That doesn't help anything unless you are targeting 4.21. If you are
it would be easiest to apply patch 1 in 4.20 and split this patch by
subsystem for 4.21. That avoids any cross subsystem dependencies.

Rob
