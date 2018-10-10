From: Silesh C V <svellattu@mvista.com>
Subject: Re: [PATCH v3 1/2] Driver core: add bus_find_device_by_fwnode
Date: Wed, 10 Oct 2018 08:25:40 +0530
Message-ID: <CALabi0FxU6GQVhKUWFzGF8qLS2YrQNh6Nok+RMS3Q_7B4NRH-Q@mail.gmail.com>
References: <1539080245-25818-1-git-send-email-svellattu@mvista.com>
 <20181009172726.GA2182@xps15> <CAJZ5v0gckkg0jyTc7=JYPpUruQQXL_FhEjm03-0mrFcxH60cHA@mail.gmail.com>
 <CANLsYkxcUvBBFRFD9Vco559Y5LFw=X0H3Lyzm=nFat6z5yH44g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CANLsYkxcUvBBFRFD9Vco559Y5LFw=X0H3Lyzm=nFat6z5yH44g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-spi@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>, Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Yisen Zhuang <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Mark Brown <broonie@kernel.org>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-rdma@vger.kernel.org

Hello Mathieu,

Thank you for the review.

On Tue, Oct 9, 2018 at 11:18 PM Mathieu Poirier
<mathieu.poirier@linaro.org> wrote:
>
>
> In this case I don't see a reason not to abide to the guideline.
> Wrapping the function declaration to 80 characters would be easy
> without effecting code readability.
>

I had seen this warning but thought it looked better as is. But now,
as I have to resend the patches after rebasing on linux-next, I will
fix this too in v4.

Thanks,
Silesh
