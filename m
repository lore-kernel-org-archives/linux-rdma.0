From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA miniconf: Persistent device naming
Date: Mon, 31 Jul 2017 09:48:32 -0400
Message-ID: <7bfd2f68-1a20-3fdd-50d9-e181030ed870@intel.com>
References: <20170731113633.GU13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731113633.GU13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/31/2017 7:36 AM, Leon Romanovsky wrote:
> Hi All,
> 
> I would like to propose the discussion about ability to add
> persistent device naming to RDMA subsystem.
> 
> Right now, the devices receive their names by simple addition of new free
> index to the name (mlx5_0, mlx5_1 ...). Such naming scheme depends on the
> PCI probing and in case of device reset can rename device.
> 
> Such situation doesn't help to provide constant udev rules, reliable
> ibverbs hotplug and advanced "set command" of RDMAtool which at some
> point of time will require reinit of ib_device.
> 
> In this discussion, I want to present netdev implementation of such
> feature, talk about implications on libibverbs and suggest possible
> device name convention.
> 
> Thanks
> 

Sounds like a good topic to me.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
