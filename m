From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 05/20] RDMA/hns: Add command queue support for
 hip08 RoCE driver
Date: Wed, 27 Sep 2017 08:41:45 -0400
Message-ID: <1506516105.82712.0.camel@redhat.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
         <1504084998-64397-6-git-send-email-xavier.huwei@huawei.com>
         <1506359213.120853.75.camel@redhat.com>
         <20170925171821.GQ25094@mtr-leonro.local>
         <1506361015.120853.81.camel@redhat.com> <59CA5261.80209@huawei.com>
         <81dd332d-e060-d7e3-bec9-1791511c5470@redhat.com>
         <9172f8c5-3dd6-a573-8e28-1b3ae4b1726b@tom.com>
         <1b8bda3b-c514-7e46-08bf-3ea50ea68096@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1b8bda3b-c514-7e46-08bf-3ea50ea68096-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-WVlzvzqoTvw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-09-27 at 08:21 -0400, Doug Ledford wrote:
> > And if you argee, after this patchset has been accepted we will
> send a
> > following up patch :
> >     In hns_roce_cmq_send function, replace
> >         usleep_range(1000, 2000);
> >     with the following statement:
> >          udelay(1);
> >     And if so, we can avoid using usleep_range function in
> spin_lock_bh
> > spin region,
> >     because it probally cause calltrace.
> 
> Ok, I'm fine with that.  I'll pull these in.

OK, these are in my tree, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
