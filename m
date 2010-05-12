From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/ucma: Copy iWARP route information.
Date: Wed, 12 May 2010 14:33:15 -0500
Message-ID: <4BEB027B.5060500@opengridcomputing.com>
References: <20100510154656.22415.47740.stgit@build.ogc.int> <1C56604F650B44A8B00B3CA55D00B95D@amr.corp.intel.com> <B28805226A0F4AD7B53BD430925D3D20@amr.corp.intel.com> <4BE9C04E.4040907@opengridcomputing.com> <23BD55BBBEC444B18E7B48D98CC1EBA5@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <23BD55BBBEC444B18E7B48D98CC1EBA5-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Sean Hefty wrote:
>> I'll have to ponder this.   In the past, we've been using the gid.raw
>> areas to hold these mac addresses...
>>     
>
> There's not too many options with the existing ABI, but the newer query
> interfaces will give us more flexibility, like variable length addresses, which
> may make this cleaner.  Maybe we can return the L2 address through an AF_UNSPEC
> sockaddr?
>
>   
What does AF_UNSPEC imply about the format of the sockaddr?




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
