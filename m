From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: [Scst-devel] Can't see exported disks
Date: Thu, 17 Oct 2013 09:40:11 +0400
Message-ID: <CACaajQuPPwd39y+sGG46+yPYNPqT1TY5emjC_-156VPueLsnWQ@mail.gmail.com>
References: <C514BDBF78B34BDE8337C0F009522A9C@aylium.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C514BDBF78B34BDE8337C0F009522A9C-w/L3Ro8pDhisTnJN9+BGXg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Egor Medvedev <methodx-w/L3Ro8pDhisTnJN9+BGXg@public.gmane.org>
Cc: scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm working too on this issue. As we see with on initiator side lvm
info not updated at all. It does not sees any changes on exported disk
that contains lvm.
Does it possible that lvm cache info or scst cache it?
I'm try to remove /etc/lvm/.cache dir but this not change anything.

2013/10/16 Egor Medvedev <methodx-w/L3Ro8pDhisTnJN9+BGXg@public.gmane.org>:
> Hello everyone.
>
>
> I have a strange problem with scst v3 and lvm.
>
>
> Lets say, I have 2 nodes.
>
>
> node-1, that have some lv's. I export them to other nodes with srp.
>
> node-2 work machine, connects to node-1
>
>
> After upgrading to scst 3 on node-1, I can't see new LV's.
>
>
> Here is an example:
>
>
> ====
>
> root@node-1:~# lvs | grep 63161
>
>   1_63161_1      node-1 -wi-a---   5.00g
>
>   1_63161_2      node-1 -wi-a---   5.00g
>
>   2_63161_1      node-1 -wi-a---   5.00g
>
>   2_63161_3      node-1 -wi-a---   5.00g
>
>   3_63161_1      node-1 -wi-a---   5.00g
>
> ====
>
> 3_63161_1 was created after upgrade
>
>
> output on node-2:
>
> ====
>
> root@node-2:~ # lvs | grep 63161
>
>   1_63161_1      node-1 -wi---   5.00G
>
>   1_63161_2      node-1 -wi---   5.00G
>
>   2_63161_1      node-1 -wi---   5.00G
>
>   2_63161_3      node-1 -wi---   5.00G
>
>
> ====
>
> Can't find any useful information with dmesg.
>
>
> Any ideas?
>
>
> --
> Best Regards,
> Egor
>
>
> ------------------------------------------------------------------------------
> October Webinars: Code for Performance
> Free Intel webinars can help you accelerate application performance.
> Explore tips for MPI, OpenMP, advanced profiling, and more. Get the most
> from
> the latest Intel processors and coprocessors. See abstracts and register >
> http://pubads.g.doubleclick.net/gampad/clk?id=60135031&iu=/4140/ostg.clktrk
> _______________________________________________
> Scst-devel mailing list
> https://lists.sourceforge.net/lists/listinfo/scst-devel
>



-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
