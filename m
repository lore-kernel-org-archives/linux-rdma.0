From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: mlx4 - query regarding PF VF functionality division
Date: Mon, 23 Jun 2014 15:00:04 +0300
Message-ID: <CAJZOPZ+FUneDDKMh0O2aZLYeDTcH8cHA7ati5wzi7Ycgc5wFXQ@mail.gmail.com>
References: <CANwwZzWsjQwZB5Cc4Hyv2HQOLhAx6ycjf32UQG55zVX=Kmbi6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CANwwZzWsjQwZB5Cc4Hyv2HQOLhAx6ycjf32UQG55zVX=Kmbi6Q@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bob Biloxi <iambobbiloxi@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 23, 2014 at 12:33 PM, Bob Biloxi <iambobbiloxi@gmail.com> wrote:
[...]
> Is there any way we can clearly separate the files that are used by PF
> vs the files that are used by VF in the (drivers/net/ethernet/mlx4
> sub-directory)?
[...]

Not really, but let's take EIM approach, what's your goal/mission?

Or.
