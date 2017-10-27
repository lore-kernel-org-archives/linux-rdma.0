From: Ghazale Hosseinabadi <ghazale.hosseinabadi@oracle.com>
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without plugged
 in SFP module
Date: Fri, 27 Oct 2017 13:35:13 -0700 (PDT)
Message-ID: <53352b34-d3eb-4698-a416-ca9465a4387e@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: hal@dev.mellanox.co.il
Cc: linux-rdma@vger.kernel.org, tbogendoerfer@suse.de, matanb@mellanox.com, leonro@mellanox.com, parav@mellanox.com, linux-kernel@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

Hi,

----- Original Message -----
From: hal@dev.mellanox.co.il
To: parav@mellanox.com, tbogendoerfer@suse.de, matanb@mellanox.com, leonro@mellanox.com, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ghazale.hosseinabadi@oracle.com
Sent: Friday, October 27, 2017 1:18:50 PM GMT -08:00 US/Canada Pacific
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without plugged in SFP module

On 10/27/2017 2:32 PM, Parav Pandit wrote:
> However I believe that ibstat tool should be enhanced to report unknown port speed instead of expecting drivers to supply some random number like this.

ibstat gets the rate from libibumad via /sys/class/infiniband/<IB device>/ports/<port number>/rate file which is supposed to be populated by the driver. Is there no rate file in this error case ?

There is a rate file, but it is empty.

Thanks,
Ghazale

-- Hal
