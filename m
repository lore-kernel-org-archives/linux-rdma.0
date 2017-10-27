From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without plugged
 in SFP module
Date: Fri, 27 Oct 2017 16:18:46 -0400
Message-ID: <20aece10-1188-6672-bd44-e78c50396445@dev.mellanox.co.il>
References: <20171027123011.10454-1-tbogendoerfer@suse.de>
 <VI1PR0502MB3008AE9EEBF086840CC06077D15A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008AE9EEBF086840CC06077D15A0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ghazale Hosseinabadi <ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/27/2017 2:32 PM, Parav Pandit wrote:
> However I believe that ibstat tool should be enhanced to report unknown port speed instead of expecting drivers to supply some random number like this.

ibstat gets the rate from libibumad via /sys/class/infiniband/<IB device>/ports/<port number>/rate file which is supposed to be populated by the driver. Is there no rate file in this error case ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
