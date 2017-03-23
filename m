From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: libmlx5 doesn't build on s390x
Date: Thu, 23 Mar 2017 08:51:21 -0400
Message-ID: <afe64964-4f10-0a00-0891-b97bf2c60b50@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Not sure if it's intentional, but in my adventure of the past day or two 
to get rdma-core v13 building across all the arches I need to build it 
for, I discovered that the mlx5 bits silently don't build on s390x. No 
build failure, they just aren't attempted, so far as I can see. The only 
sign of failure was when rpm %files globs failed to locate mlx5 bits.

I noted that mlx4 has some s390x-specific trickery in 
providers/mlx4/mmio.h, and wondered if something similar was required 
for mlx5, or if "does not work on s390x and isn't expected to" is the 
norm. Currently, my builds are excluding mlx5 support on s390x due to 
the current state.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
