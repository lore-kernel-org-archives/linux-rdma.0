From: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: cqe dump errors on target while running nvme-of large block
 read IO
Date: Fri, 14 Apr 2017 16:38:34 +0000
Message-ID: <DE927C68B458BE418D582EC97927A9285505F0C9@ORSMSX113.amr.corp.intel.com>
References: <DE927C68B458BE418D582EC97927A9285505C9EA@ORSMSX113.amr.corp.intel.com>
 <47f19583-1882-09d4-ce1c-534b8e59068b@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47f19583-1882-09d4-ce1c-534b8e59068b-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org'" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Sen, Sujoy" <sujoy.sen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> hi Joe,
> can you run and repro it with null_blk backing store instead the nvme ?
> you can emulate the delay of the nvme device using module param
> completion_nsec.
> is it reproducable in case B2B connectivity ?

Hey Max,

I ran overnight using null_blk devices but was unable to reproduce in that configuration.  I set completion_nsec to 50000.  Although my measured completion latencies in FIO were more like 17-18usec so not sure why they did not come in closer to 50usec.  Anyway, failure did not reproduce using null_blk instead of real NVMe SSDs.

By B2B connectivity do you mean direct target-to-initiator connection with no switch?  I don't think that is possible in this configuration since target uses a 100Gb QSFP NIC and initiator uses a 25Gb SFP28 NIC.  I could perhaps swap the target side NIC for a matching 25Gb device and run direct connected that way if we think we need that data point, we would need to first establish if the failure even happens in that configuration, based on other testing we've done on an all-25Gb configuration I suspect it may not.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
