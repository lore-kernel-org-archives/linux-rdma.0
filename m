From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: libmlx5 doesn't build on s390x
Date: Thu, 23 Mar 2017 18:06:19 +0200
Message-ID: <36a02b19-5b50-10f6-f3da-13d4a67f50c2@dev.mellanox.co.il>
References: <afe64964-4f10-0a00-0891-b97bf2c60b50@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <afe64964-4f10-0a00-0891-b97bf2c60b50-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/23/2017 2:51 PM, Jarod Wilson wrote:
> Not sure if it's intentional, but in my adventure of the past day or two
> to get rdma-core v13 building across all the arches I need to build it
> for, I discovered that the mlx5 bits silently don't build on s390x. No
> build failure, they just aren't attempted, so far as I can see. The only
> sign of failure was when rpm %files globs failed to locate mlx5 bits.

How about mlx4, was it built successfully ? we expect the same behavior 
from build point of view as both and others providers depend on 
HAVE_COHERENT_DMA from CMakeLists.txt

Any option that you saw below message in the log ?
"Architecture NOT able to do coherent DMA (check libibverbs/arch.h) some 
providers disabled!")"

> I noted that mlx4 has some s390x-specific trickery in
> providers/mlx4/mmio.h, and wondered if something similar was required
> for mlx5, or if "does not work on s390x and isn't expected to" is the
> norm. Currently, my builds are excluding mlx5 support on s390x due to
> the current state.

The patch of mlx4 for s390x in mlx4/mmio.h came from IBM people few 
years ago, I believe that similar one is needed for mlx5 otherwise it 
won't be able to write to PCI memory, so excluding mlx5 for s390 makes 
sense. However, mlx4 should be in, is it really the case when you build 
the s390 package ?

Adding Alexey who sent the patch for mlx4 to get his input as well.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
