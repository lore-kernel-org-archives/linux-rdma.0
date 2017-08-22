From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] IB/mlx5: use kvmalloc_array for mlx5_ib_wq
Date: Tue, 22 Aug 2017 16:48:54 -0400
Message-ID: <1503434934.78641.15.camel@redhat.com>
References: <20170816133123.20497-1-dongyang.li@anu.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170816133123.20497-1-dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-16 at 23:31 +1000, Li Dongyang wrote:
> We observed multiple times on our Lustre OSS servers that when
> the system memory is fragmented, kmalloc() in create_kernel_qp()
> could fail order 4/5 allocations while we still have many free pages.
> 
> Switch to kvmalloc_array() to allow the operation to contine.
> 
> Signed-off-by: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
