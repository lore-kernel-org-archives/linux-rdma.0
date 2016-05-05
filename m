From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Thu, 5 May 2016 18:01:06 -0400 (EDT)
Message-ID: <1133135399.34245490.1462485666601.JavaMail.zimbra@redhat.com>
References: <571A936F.7040409@sandisk.com> <572A8975.9060606@sandisk.com> <20160505140616.GA15000@lst.de> <2102017158.34060891.1462478304470.JavaMail.zimbra@redhat.com> <572BA98F.4090109@sandisk.com> <572BAA6F.1060607@sandisk.com> <804753248.34153510.1462481756460.JavaMail.zimbra@redhat.com> <572BBDC0.5070205@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <572BBDC0.5070205-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Thursday, May 5, 2016 5:40:16 PM
> Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
> 
> On 05/05/2016 01:56 PM, Laurence Oberman wrote:
> > Set at 1025, rebuilt ib_srp module, rebooted client and:
> >
> > Still get:
> >
> > [root@srptest ~]# dmesg | grep Reducing
> > [  227.076550] scsi host4: ib_srp: Reducing max_sectors from 8192 to 4080
> > [  235.316995] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4080
> > [  245.726223] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4080
> > [  253.197573] scsi host6: ib_srp: Reducing max_sectors from 8192 to 4080
> >
> > And then of course we are constrained
> 
> Sorry. I forgot that the maximum FR page list length for mlx4 is 511. I
> will come up with another solution.
> 
> Bart.
> 
> 

Hi Bart

Yep, something has changed upstream here to bring this out.
This time back to testing on mlx5.
I installed RHEL6 + Mofed stack to validate what I was told about RHEL6 + Mofed being stable.

kmod-mlnx-ofa_kernel-3.1-OFED.3.1.1.0.3.1.g9032737.rhel6u7.x86_64
libibverbs-devel-1.1.8mlnx1-OFED.3.1.1.0.0.x86_64
libibcm-1.0.5mlnx2-OFED.3.0.11.gd7d485d.x86_64
librdmacm-1.0.21mlnx-OFED.3.0.1.5.2.x86_64
mlnx-ofa_kernel-3.1-OFED.3.1.1.0.3.1.g9032737.rhel6u7.x86_64
libmlx4-1.0.6mlnx1-OFED.3.1.1.0.0.x86_64
mlnx-ofa_kernel-devel-3.1-OFED.3.1.1.0.3.1.g9032737.rhel6u7.x86_64
mlnx-ofa_kernel-modules-3.1-2.6.32_573.12.1.el6.x86_64_OFED.3.1.1.0.3.1.g9032737.x86_64
libibcm-devel-1.0.5mlnx2-OFED.3.0.11.gd7d485d.x86_64
libmlx5-devel-1.0.2mlnx1-OFED.3.1.1.0.3.x86_64
librdmacm-devel-1.0.21mlnx-OFED.3.0.1.5.2.x86_64
dapl-devel-2.1.5mlnx-OFED.3.0.0.3.3.x86_64
ibacm-1.0.9mlnx1-OFED.3.0.10.ga105e8b.x86_64
libibverbs-utils-1.1.8mlnx1-OFED.3.1.1.0.0.x86_64
libibverbs-1.1.8mlnx1-OFED.3.1.1.0.0.x86_64
kmod-knem-mlnx-1.1.2.90mlnx-OFED.3.1.0.0.7.1.g4b084fc.rhel6u7.x86_64
libmlx4-devel-1.0.6mlnx1-OFED.3.1.1.0.0.x86_64
dapl-2.1.5mlnx-OFED.3.0.0.3.3.x86_64
dapl-utils-2.1.5mlnx-OFED.3.0.0.3.3.x86_64
ofed-scripts-3.1-OFED.3.1.1.0.3.x86_64
librdmacm-utils-1.0.21mlnx-OFED.3.0.1.5.2.x86_64
libmlx5-1.0.2mlnx1-OFED.3.1.1.0.3.x86_64

[root@dhcp40-159 ~]# uname -a
Linux xxxxxxxx 2.6.32-573.12.1.el6.x86_64 #1 SMP Mon Nov 23 12:55:32 EST 2015 x86_64 x86_64 x86_64 GNU/Linux

# cat /etc/redhat-release 
Red Hat Enterprise Linux Server release 6.7 (Santiago)

I can set the max_sector_kb to 4096

Setting max_sectors_kb to 8192 x 512
4096
4096
..
..
4096
4096

When doing buffered I/O I see it periodically get to 4096 and what is most important is that we have no mapping errors so far.
So the messaging I am getting about RHEL6.7 + Mofed stack and stability seems to be valid.

### RECORD  336 >>> dhcp40-159 <<< (1462485288.001) (Thu May  5 21:54:48 2016) ###
# DISK STATISTICS (/sec)
#                   <---------reads---------><---------writes---------><--------averages--------> Pct
#Time     Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size  RWSize  QLen  Wait SvcTim Util
22:00:35 sdk              0      0    0    0  167936      0   41 4096    4096    12   314     24   986
22:00:35 sdg              0      0    0    0   69660      0   18 3870    3870     5   374     25   457
22:00:35 sdl              0      0    0    0  364544      0   92 3962    3962    48   358     10   997
22:00:35 sdc              0      0    0    0  184320      0   47 3922    3921    16   298     21   995

We need to figure out what is different upstream here to get us into trouble I guess with 4MB buffered I/O.
Of course kernel etc. is totally different to what we have on RHEL 6.7.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
