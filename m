From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 03/16] ib/mad: Add check for jumbo MADs support on
 a device
Date: Thu, 27 Nov 2014 13:47:16 +0200
Message-ID: <54770F44.2090909@mellanox.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
 <1415908465-24392-4-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415908465-24392-4-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/13/2014 9:54 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

> Add a device capability flag for OPA devices to signal their support of "jumbo"
> MADs.
>
> Check for IB_DEVICE_JUMBO_MAD_SUPPORT in the device capabilities and if
> supported mark the special QPs created.

Ira,

Few comments here, the device capability is OK, specifically if it helps 
for the mad
layer logic to be simpler and/or more robust.

You should add device attribute telling what is the size of MADs 
supported by the
device, I think the IBTA mandated 256Band in the OPA case, the driver 
will fill there 2k.

You can't just state that (jumbo == 2k) and go to complete design/changes
which use this hard-coded assumption. You need to see how to re-spin 
this series
w.o this assumption.

I find it very annoying that upper level drivers replicate in different 
ways elements
from the IB device attributes returned by ib_query_device. I met that in 
multiple
drivers and upcoming designs for which I do code review. Are you up to 
come up
with a patch that caches the device attributes on the device structure? 
if not,
I can do that.. and have your code to see it.

Also, I would go and unify (squash) this patch and the preceding one.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
