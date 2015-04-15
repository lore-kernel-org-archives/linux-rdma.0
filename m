From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: iser patches for kernel 4.1 [v3]
Date: Wed, 15 Apr 2015 08:21:59 +0300
Message-ID: <552DF577.7000502@mellanox.com>
References: <1429024108-7221-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429024108-7221-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/14/2015 6:08 PM, Sagi Grimberg wrote:
> Hi Roland,
>
> This set contains bug fixes as well as code refactoring patches
>
> - Patches 1-3:	   Bug fixes (stable material)
> - Patches 4-6:     Bounce buffer related code cleanups
> - Patches 7-12,16: Refactoring
> - Patches 13-15:   Minor optimizations
> - Patch 17:        Version bump
> - Patch 18:        Bounce buffer rewrite to handle situations where
>                     large transfers are unaligned causing iser to
> 		   use high order allocations
>
> Changes from v2:
> - Fix regression in DIX mode (introduced in patch 15) by incorrectly
>    setting the protection information scatter-entry.

Sagi, OTOH Roland made a note that he applied V2, hence you were 
supposed to send incremental fix on top of it (for-next time), OTHO, he 
didn't make his applying of the code public, so sending the whole series 
makes sense too. Just to be on the safe side of things, since the merge 
window is open, please send also an incremental fix.

Or.

>
> Changes from v1:
> - Addressed review comments (patch 18) from Alex Lyakas on bounce buffer
>    re-write code (kmap/kunmap mismatch, possible use-after-free,
>    and double free).

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
