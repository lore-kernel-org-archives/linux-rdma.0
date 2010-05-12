From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/ucma: Copy iWARP route information.
Date: Wed, 12 May 2010 17:03:03 -0500
Message-ID: <4BEB2597.1080009@opengridcomputing.com>
References: <20100510154656.22415.47740.stgit@build.ogc.int> <1C56604F650B44A8B00B3CA55D00B95D@amr.corp.intel.com> <B28805226A0F4AD7B53BD430925D3D20@amr.corp.intel.com> <4BE9C04E.4040907@opengridcomputing.com> <23BD55BBBEC444B18E7B48D98CC1EBA5@amr.corp.intel.com> <4BEB027B.5060500@opengridcomputing.com> <5A102C804D4348A5BCE504F433888BED@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5A102C804D4348A5BCE504F433888BED-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> What does AF_UNSPEC imply about the format of the sockaddr?
>>     
>
> That it depends on the usage..?  I came up with this based on using ioctl to
> manipulate the ARP cache:
>
> SIOCSARP - Add a new entry to the ARP cache or modify an existing entry ...
> arp_ha is a generic socket address structure with sa_family set to AF_UNSPEC and
> sa_data containing the hardware address (e.g. the 6-byte Ethernet address).
>
> The librdmacm should have enough context to interpret the meaning of the
> query_gid response.
>
> - Sean
>   

sounds ok to me.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
