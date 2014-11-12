From: Evgenii Smirnov <evgenii.smirnov-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: ibv_reg_mr fails to register memory
Date: Wed, 12 Nov 2014 11:44:38 +0100
Message-ID: <CAEv+Kc2g+Jk2YQH4=D9vekqT6CrgkBCqVm8-mcz_Jsk-HFQ=2Q@mail.gmail.com>
References: <1415700743.7672.1.camel@rafi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415700743.7672.1.camel@rafi>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rtalur-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <rtalur-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Likely, it's caused by limits in /etc/security/limits.conf. See p.30
in Mellanox OFED for Linux User Manual Rev 1.5.3-4.0.42.

Best regards,
Eugene

On Tue, Nov 11, 2014 at 11:12 AM, Mohammed Rafi K C
<muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi All,
>
> I was trying to implement an application that support rdma using
> librdmacm. When the process is trying to register the buffer using
> ibv_reg_mr, it failes after registering  some number buffer.
>
> We are using Mellanox Technologies MT27500 Family [ConnectX-3] cards.
>
> Reconfigured options are :
>
> 1) cat /sys/module/mlx4_core/parameters/log_num_mtt
>     24
> 2) cat /sys/module/mlx4_core/parameters/log_mtts_per_seg
>     7
>
> Can anyone point out reason behind ibv_reg_mr fails ?
>
> Thanks & Regards
> Rafi KC
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
