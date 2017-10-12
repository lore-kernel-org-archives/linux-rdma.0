From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v2 00/13] Request for Comments on SoftiWarp
Date: Thu, 12 Oct 2017 11:35:34 -0700
Message-ID: <eb3599fe-dd34-e807-28c0-8229367f0f24@wdc.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <dd0e915d-2ab7-9912-b000-bcca1acee256@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dd0e915d-2ab7-9912-b000-bcca1acee256-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/12/17 11:05, Dennis Dalessandro wrote:
> If we were using the staging tree still, I'd say it's in good enough 
> shape to send there and let it get hacked on, but we aren't going down 
> that road in this subsystem again I don't think. So the bar is a little 
> higher I for getting in to mainline.

The most important aspect that needs to be addressed is probably the 
user space interface for the siw driver. We don't want users to have to 
deal with multiple incompatible versions of a user space interface so we 
must get the user space interface right before this driver goes upstream.

 > You also have a large number of debugging prints. While it's nice for
 > development and can be turned off, I think alot of those are
 > unnecessary. The RDMA subsystem on the whole needs a better strategy
 > for dealing with debugging and logging, we just aren't there yet.

Unless someone has a better proposal I think the dprint() macro 
definition should be removed and all dprint() invocations that we want 
to keep should be changed into pr_debug() calls. The dynamic debug 
mechanism is more powerful than what the dprint() macro implements.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
