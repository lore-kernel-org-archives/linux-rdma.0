From: Mohammed Rafi K C <muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ibv_reg_mr fails to register memory
Date: Wed, 12 Nov 2014 20:14:10 +0530
Message-ID: <1415803450.8686.19.camel@rafi>
References: <1415700743.7672.1.camel@rafi>
	 <CAEv+Kc2g+Jk2YQH4=D9vekqT6CrgkBCqVm8-mcz_Jsk-HFQ=2Q@mail.gmail.com>
	 <CAMtRa4DW2_Aj13enG2RNoLhCro5VPb+3Ak8im4b0GWAW3TTyEw@mail.gmail.com>
Reply-To: muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMtRa4DW2_Aj13enG2RNoLhCro5VPb+3Ak8im4b0GWAW3TTyEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgenii Smirnov <evgenii.smirnov-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, kushagra misra <er.kushagra.misra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "rtalur-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <rtalur-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2014-11-12 at 18:50 +0530, kushagra misra wrote:
> yes plz check your  ulimits value under /etc/security/limits.conf
> that may be causing the issue.
> 
> 
> 
> On Wed, Nov 12, 2014 at 4:14 PM, Evgenii Smirnov
> <evgenii.smirnov-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
>         Hi,
>         
>         Likely, it's caused by limits in /etc/security/limits.conf.
>         See p.30
>         in Mellanox OFED for Linux User Manual Rev 1.5.3-4.0.42.
>         
>         Best regards,
>         Eugene
>         

 Eugene/kushagra

Thank you very much for your reply. AS you guys suggested , I
checked /etc/security/limits.conf file and the value was set to
unlimited for both soft memlock and hard memlock. 

* soft memlock unlimited
* hard memlock unlimited

So I hope that will allow us to pin unlimited memory with kernel.
I did some experiment to know how much memory is able to register
successfully , and the result was approximately 128MB (127.40625 MB).
Further allocation is failed by returning NULL from ibv_reg_mr, by
setting errno=11 (Resource temporarily unavailable). 

Thanks & Regrads
Rafi KC


>         On Tue, Nov 11, 2014 at 11:12 AM, Mohammed Rafi K C
>         <muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>         > Hi All,
>         >
>         > I was trying to implement an application that support rdma
>         using
>         > librdmacm. When the process is trying to register the buffer
>         using
>         > ibv_reg_mr, it failes after registering  some number buffer.
>         >
>         > We are using Mellanox Technologies MT27500 Family
>         [ConnectX-3] cards.
>         >
>         > Reconfigured options are :
>         >
>         > 1) cat /sys/module/mlx4_core/parameters/log_num_mtt
>         >     24
>         > 2) cat /sys/module/mlx4_core/parameters/log_mtts_per_seg
>         >     7
>         >
>         > Can anyone point out reason behind ibv_reg_mr fails ?
>         >
>         > Thanks & Regards
>         > Rafi KC
>         >
>         > --
>         > To unsubscribe from this list: send the line "unsubscribe
>         linux-rdma" in
>         > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>         > More majordomo info at
>         http://vger.kernel.org/majordomo-info.html
>         --
>         To unsubscribe from this list: send the line "unsubscribe
>         linux-rdma" in
>         the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>         More majordomo info at
>         http://vger.kernel.org/majordomo-info.html
>         
> 
> 
> 
> -- 
> Real leaders are ordinary people with extraordinary determination.!!!!
> 
> Thanks & Regard's
> Kushagra Misra
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
