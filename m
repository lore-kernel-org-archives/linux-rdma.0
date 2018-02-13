From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 14/15] IB/uverbs: Fix unbalanced unlock on error
 path for rdma_explicit_destroy
Date: Tue, 13 Feb 2018 12:11:47 -0500
Message-ID: <7574ac6e-c427-90a8-0fbe-6ac3a0f78b30@intel.com>
References: <20180213101841.20101-1-leon@kernel.org>
 <20180213101841.20101-15-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-15-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/13/2018 5:18 AM, Leon Romanovsky wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> If remove_commit fails then the lock is left locked while the uobj still
> exists. Eventually the kernel will deadlock.
> 
> lockdep detects this and says:
> 
>   test/4221 is leaving the kernel with locks still held!
>   1 lock held by test/4221:
>    #0:  (&ucontext->cleanup_rwsem){.+.+}, at: [<000000001e5c7523>] rdma_explicit_destroy+0x37/0x120 [ib_uverbs]
> 
> Fixes: 4da70da23e9b ("IB/core: Explicitly destroy an object while keeping uobject")
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
