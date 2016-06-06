From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 2/2] IB/core: Align casting method of
 ib_device_cap_flags enumerations to ULL
Date: Mon, 6 Jun 2016 10:40:11 -0700
Message-ID: <20160606174011.GB24836@kroah.com>
References: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
 <1465230880-25953-3-git-send-email-maxg@mellanox.com>
 <20160606170413.GB28622@infradead.org>
 <CALq1K=JWPk6nPjTV0z1HwfmtnO77Nkyaqx-JTB=8JwH0UtorDA@mail.gmail.com>
 <20160606172246.GB21118@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160606172246.GB21118@infradead.org>
Sender: stable-owner@vger.kernel.org
To: hch <hch@infradead.org>
Cc: Leon Romanovsky <leon@leon.nu>, Sagi Grimberg <sagi@grimberg.me>, stable@vger.kernel.org, linux-rdma@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>, matanb@mellanox.com, robert@leblancnet.us
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 06, 2016 at 10:22:46AM -0700, hch wrote:
> > Later on, we will wrap all these shifts in BIT() macros as Greg suggested.
> 
> Big NAK to any use of that macro.

That's odd, given that most of the kernel has already converted to use
it.  You can try to keep it out of this subsystem, but you will get
patches to convert it from random people and it will wear you down over
time...

sorry,

greg k-h
