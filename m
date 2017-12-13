From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] srp_daemon: handle SM lid change
Date: Wed, 13 Dec 2017 06:32:30 -0500
Message-ID: <0ca80873-0eb0-9c64-f813-dee94b82eea6@intel.com>
References: <dba1097c-8ab9-7086-a976-46e6d3c4a165@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dba1097c-8ab9-7086-a976-46e6d3c4a165-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/12/2017 9:08 AM, Nicolas Morey-Chaisemartin wrote:
> When srp_daemon was running and the master SM host changes,
>   srp_daemon output these errors at every scan:
> srp_daemon[25394]: No response to inform info registration
> srp_daemon[25394]: Fail to register to traps, maybe there is no opensm
>   running on fabric or IB port is down
> 
> This was introduced by commit 4952e5f Fix a memory leak.
> A side effect of this patch was that create_ah was only called when the
>   port lid changes. Which meant register_to_traps used an older, obsolete,
>   version of sm_lid and failed to connect to it.
> 
> This patch fixes this behaviour by checking for both local lid changes and
>   SM lid changes, and calling create_ah on any of these events.
> 
> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
> Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v14, v15, v16

You are probably going to want to add a proper fixes tag here rather 
than just mentioning in the commit messages.

Fixes: <12-char-of-SHA> ("Patch subject")

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
