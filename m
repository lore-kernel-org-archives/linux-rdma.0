From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [FIXES for-next 0/4] mlx4_core SRIOV and Flow-Steering
 adjustments and fixes
Date: Sat, 8 Dec 2012 21:12:46 +0200
Message-ID: <CAJZOPZ+CW5+YYOc3n7gYK2PfzOre1OOi8yAemHw2PznVSmv1og@mail.gmail.com>
References: <1354813920-27358-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354813920-27358-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 6, 2012 at 7:11 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> The patch set fixes few issues we've identified and fixed in the
>> mlx4_core driver around SRIOV and device managed flow steering.

>> This includes adding QPN enforcement in the resource tracker for
>> flow-steering rules set by VFs, and a fix to wrong error flow in
>> the very same area in patches #1/#2. Patch #3 addresses a wrong
>> flow-steering capability detection by VFs and adds a check that
>> the requested number of VFs can actually be served under flow-steering
>> mode. Finally, with flow steering being global device operational mode,
>> which is needed only in certain environments, patch #4 comes and allows
>> to actually choose whether or not to use it.

>> As we're on rc8 now which is pretty late in the 3.7 release cycle, it
>> makes more sense to push these patches into 3.8 and later pick the relevant
>> pieces into -stable.  Specifically patch #3 can't go into -stable as is since it
>> has context dependancies with the "mlx4: 64-byte CQE/EQE support" patch
>> targted for 3.8 queued at your tree.

Dave > These changes only touch the drivers/net/ driver, why are you trying
Dave > to submit them via the RDMA tree instead of the networking tree?

Hi Dave,

I've explained it in the last paragraph, patch #3 has context
dependancies with the
"mlx4: 64-byte CQE/EQE support" patch which is queued for 3.8 in
Roland's for-next branch see
http://git.kernel.org/?p=linux/kernel/git/roland/infiniband.git;a=commit;h=08ff32352d6ff7083533dc1c25618d42f92ec28e

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
