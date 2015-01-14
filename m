From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 14/20] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device cap
 flag
Date: Wed, 14 Jan 2015 08:26:16 +0200
Message-ID: <54B60C08.9090205@mellanox.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
 <1421082672-22588-15-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421082672-22588-15-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/12/2015 7:11 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> Add a device capability flag to flag OPA MAD support on devices.

You should put few words here telling what is OPA/OPA MADs and why 
supporting them fits the IB core.

See for example the IB core patch [1] that added signature verbs API is 
states in  a manner which is both
generic across vendors and across different Mellanox  HCAs. Also see [2] 
the IB core patch that added support
for BMME API  as another example.


[1] 1b01d33 IB/core: Introduce signature verbs API
[2] 00f7ec3 RDMA/core: Add memory management extensions support
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
