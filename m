From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt
Date: Tue, 20 Dec 2016 16:09:37 -0500 (EST)
Message-ID: <653622322.8201942.1482268177727.JavaMail.zimbra@redhat.com>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com> <25d066c2-59d7-2be7-dd56-e29e99b43620@sandisk.com> <20161209182429.GF16622@lst.de> <52e8398f-a146-721c-3b92-0892b4abbff8@intel.com> <1482166487.25336.10.camel@sandisk.com> <1918919536.8196250.1482262406057.JavaMail.zimbra@redhat.com> <2052479881.8196880.1482263028727.JavaMail.zimbra@redhat.com> <1668746735.8200653.1482266682585.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1668746735.8200653.1482266682585.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Tuesday, December 20, 2016 3:44:42 PM
> Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt
> 
> 
> 
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Tuesday, December 20, 2016 2:43:48 PM
> > Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Sent: Tuesday, December 20, 2016 2:33:26 PM
> > > Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt
> > > 
> > > Hello Bart
> > > 
> > > I pulled the latest linux-next and built kernels for both server and
> > > client
> > > to rerun all my EDR tests for srp.
> > > 
> > > For some reason the I/O size is being capped again to 1MB in my testing.
> > > Using my same testbed.
> > > Remember we spent a lot of time making sure we could do 4MB I/O :)
> > > 
> > > Its working fine in the RHEL 7.3 kernel so before I start going back
> > > testing
> > > upstream kernels decided to ask.
> > > 
> > > Have you tested large I/O with latest linux-next
> > > 
> > > Server Configuration
> > > ---------------------
> > > Linux fedstorage.bos.redhat.com 4.9.0+
> > > 
> > > [root@fedstorage modprobe.d]# cat ib_srp.conf
> > > options ib_srp cmd_sg_entries=64 indirect_sg_entries=2048
> > > 
> > > [root@fedstorage modprobe.d]# cat ib_srpt.conf
> > > options ib_srpt srp_max_req_size=8296
> > > 
> > > Also Using
> > > 
> > > # Set the srp_sq_size
> > > for i in
> > > /sys/kernel/config/target/srpt/0xfe800000000000007cfe900300726e4e
> > > /sys/kernel/config/target/srpt/0xfe800000000000007cfe900300726e4f
> > > do
> > > 	echo 16384 > $i/tpgt_1/attrib/srp_sq_size
> > > done
> > > 
> > > Client Configuration
> > > --------------------
> > > Linux ibclient 4.9.0+
> > > 
> > > [root@ibclient modprobe.d]# cat ib_srp.conf
> > > options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048
> > > 
> > > dd if=/dev/sdw bs=4096k of=/dev/null iflag=direct
> > > 
> > > ### RECORD    4 >>> ibclient <<< (1482261733.001) (Tue Dec 20 14:22:13
> > > 2016)
> > > ###
> > > # DISK STATISTICS (/sec)
> > > #
> > > <---------reads---------------><---------writes--------------><--------averages-------->
> > > Pct
> > > #Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs
> > > Size
> > > Wait  RWSize  QLen  Wait SvcTim Util
> > > 14:22:13 sdw         1373184      0 1341 1024     2       0      0    0
> > > 0
> > > 0    1024     3     2      0   97
> > > 
> > > 
> > > If I reboot into my 7.3 kernel its back to what I expect
> > > 
> > >  dd if=/dev/sdw bs=4096k of=/dev/null iflag=direct
> > > 
> > > 
> > > ### RECORD    3 >>> ibclient <<< (1482262254.001) (Tue Dec 20 14:30:54
> > > 2016)
> > > ###
> > > # DISK STATISTICS (/sec)
> > > #
> > > <---------reads---------------><---------writes--------------><--------averages-------->
> > > Pct
> > > #Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs
> > > Size
> > > Wait  RWSize  QLen  Wait SvcTim Util
> > > 14:30:54 sdw         172032    129   42 4096     3       0      0    0
> > > 0
> > > 0    4096     1     3      3   130
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > Hi Bart,
> > 
> > Just FYI
> > 
> > That dd snap was just as I had stopped the dd.
> > 
> > Here is a stable dd snap with the RHEL kernel, I just noticed the merging,
> > need to reboot back into upstream to compare again.
> > No merging seen in upstream.
> > 
> > Thanks
> > Laurence
> > 
> > ### RECORD    6 >>> ibclient <<< (1482262723.001) (Tue Dec 20 14:38:43
> > 2016)
> > ###
> > # DISK STATISTICS (/sec)
> > #
> > <---------reads---------------><---------writes--------------><--------averages-------->
> > Pct
> > #Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size
> > Wait  RWSize  QLen  Wait SvcTim Util
> > 14:38:43 sdw         1200128    879  293 4096     3       0      0    0
> > 0
> > 0    4096     1     3      3   95
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> Replying to my own message to keep the thread going
> 
> 
> This is Linux ibclient 4.8.0-rc4
> 
> Behaves like I expected, and I see the 4MB I/O sizes. as I had already tested
> this.
> 
> dd if=/dev/sdw bs=4096k of=/dev/null iflag=direct
> 
> 
> ### RECORD    6 >>> ibclient <<< (1482266543.001) (Tue Dec 20 15:42:23 2016)
> ###
> # DISK STATISTICS (/sec)
> #
> <---------reads---------------><---------writes--------------><--------averages-------->
> Pct
> #Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size
> Wait  RWSize  QLen  Wait SvcTim Util
> 15:42:23 sdw         278528    201   68 4096     2       0      0    0    0
> 0    4096     1     2      2   206
> 
> Rebooting back into 4.9 and will bisect leading to it once I confirm
> 
> 

[root@ibclient ~]# uname -a
Linux ibclient 4.9.0+ #1 SMP Tue Dec 20 10:06:26 EST 2016 x86_64 x86_64 x86_64 GNU/Linux

Yep, back into 4.9 and we are at 1MB I/O

Confirmed regression or behavior change in 4.9

while true; do dd if=/dev/sdw bs=4096k of=/dev/null iflag=direct 1>/dev/null 2>&1 ; done &

# DISK STATISTICS (/sec)
#                   <---------reads---------------><---------writes--------------><--------averages--------> Pct
#Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size  Wait  RWSize  QLen  Wait SvcTim Util
16:06:33 sdw         1405952      0 1373 1024     2       0      0    0    0     0    1024     3     2      0   98
16:06:34 sdw         1424384      0 1391 1024     2       0      0    0    0     0    1024     3     2      0   97
16:06:35 sdw         1462272      0 1428 1024     2       0      0    0    0     0    1024     3     2      0   97
16:06:36 sdw         1417216      0 1384 1024     2       0      0    0    0     0    1024     3     2      0   97
16:06:37 sdw         1380352      0 1348 1024     2       0      0    0    0     0    1024     3     2      0   98
16:06:38 sdw         1404928      0 1372 1024     2       0      0    0    0     0    1024     3     2      0   98
16:06:39 sdw         1458176      0 1424 1024     2       0      0    0    0     0    1024     3     2      0   97

I will try chase it down and be back with an update

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
