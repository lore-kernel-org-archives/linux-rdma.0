From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt
Date: Wed, 21 Dec 2016 01:34:01 -0500 (EST)
Message-ID: <1928955380.8220327.1482302041315.JavaMail.zimbra@redhat.com>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com> <20161209182429.GF16622@lst.de> <52e8398f-a146-721c-3b92-0892b4abbff8@intel.com> <1482166487.25336.10.camel@sandisk.com> <1918919536.8196250.1482262406057.JavaMail.zimbra@redhat.com> <2052479881.8196880.1482263028727.JavaMail.zimbra@redhat.com> <1668746735.8200653.1482266682585.JavaMail.zimbra@redhat.com> <120559766.8215321.1482291094018.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <120559766.8215321.1482291094018.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Tuesday, December 20, 2016 10:31:34 PM
> Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt
> 
> 
> 
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Tuesday, December 20, 2016 3:44:42 PM
> > Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Sent: Tuesday, December 20, 2016 2:43:48 PM
> > > Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt
> > > 
> > > 
> > > 
> > > ----- Original Message -----
> > > > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > To: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > Sent: Tuesday, December 20, 2016 2:33:26 PM
> > > > Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt
> > > > 
> > > > Hello Bart
> > > > 
> > > > I pulled the latest linux-next and built kernels for both server and
> > > > client
> > > > to rerun all my EDR tests for srp.
> > > > 
> > > > For some reason the I/O size is being capped again to 1MB in my
> > > > testing.
> > > > Using my same testbed.
> > > > Remember we spent a lot of time making sure we could do 4MB I/O :)
> > > > 
> > > > Its working fine in the RHEL 7.3 kernel so before I start going back
> > > > testing
> > > > upstream kernels decided to ask.
> > > > 
> > > > Have you tested large I/O with latest linux-next
> > > > 
> > > > Server Configuration
> > > > ---------------------
> > > > Linux fedstorage.bos.redhat.com 4.9.0+
> > > > 
> > > > [root@fedstorage modprobe.d]# cat ib_srp.conf
> > > > options ib_srp cmd_sg_entries=64 indirect_sg_entries=2048
> > > > 
> > > > [root@fedstorage modprobe.d]# cat ib_srpt.conf
> > > > options ib_srpt srp_max_req_size=8296
> > > > 
> > > > Also Using
> > > > 
> > > > # Set the srp_sq_size
> > > > for i in
> > > > /sys/kernel/config/target/srpt/0xfe800000000000007cfe900300726e4e
> > > > /sys/kernel/config/target/srpt/0xfe800000000000007cfe900300726e4f
> > > > do
> > > > 	echo 16384 > $i/tpgt_1/attrib/srp_sq_size
> > > > done
> > > > 
> > > > Client Configuration
> > > > --------------------
> > > > Linux ibclient 4.9.0+
> > > > 
> > > > [root@ibclient modprobe.d]# cat ib_srp.conf
> > > > options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048
> > > > 
> > > > dd if=/dev/sdw bs=4096k of=/dev/null iflag=direct
> > > > 
> > > > ### RECORD    4 >>> ibclient <<< (1482261733.001) (Tue Dec 20 14:22:13
> > > > 2016)
> > > > ###
> > > > # DISK STATISTICS (/sec)
> > > > #
> > > > <---------reads---------------><---------writes--------------><--------averages-------->
> > > > Pct
> > > > #Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs
> > > > Size
> > > > Wait  RWSize  QLen  Wait SvcTim Util
> > > > 14:22:13 sdw         1373184      0 1341 1024     2       0      0    0
> > > > 0
> > > > 0    1024     3     2      0   97
> > > > 
> > > > 
> > > > If I reboot into my 7.3 kernel its back to what I expect
> > > > 
> > > >  dd if=/dev/sdw bs=4096k of=/dev/null iflag=direct
> > > > 
> > > > 
> > > > ### RECORD    3 >>> ibclient <<< (1482262254.001) (Tue Dec 20 14:30:54
> > > > 2016)
> > > > ###
> > > > # DISK STATISTICS (/sec)
> > > > #
> > > > <---------reads---------------><---------writes--------------><--------averages-------->
> > > > Pct
> > > > #Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs
> > > > Size
> > > > Wait  RWSize  QLen  Wait SvcTim Util
> > > > 14:30:54 sdw         172032    129   42 4096     3       0      0    0
> > > > 0
> > > > 0    4096     1     3      3   130
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > > > in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > 
> > > Hi Bart,
> > > 
> > > Just FYI
> > > 
> > > That dd snap was just as I had stopped the dd.
> > > 
> > > Here is a stable dd snap with the RHEL kernel, I just noticed the
> > > merging,
> > > need to reboot back into upstream to compare again.
> > > No merging seen in upstream.
> > > 
> > > Thanks
> > > Laurence
> > > 
> > > ### RECORD    6 >>> ibclient <<< (1482262723.001) (Tue Dec 20 14:38:43
> > > 2016)
> > > ###
> > > # DISK STATISTICS (/sec)
> > > #
> > > <---------reads---------------><---------writes--------------><--------averages-------->
> > > Pct
> > > #Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs
> > > Size
> > > Wait  RWSize  QLen  Wait SvcTim Util
> > > 14:38:43 sdw         1200128    879  293 4096     3       0      0    0
> > > 0
> > > 0    4096     1     3      3   95
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > Replying to my own message to keep the thread going
> > 
> > 
> > This is Linux ibclient 4.8.0-rc4
> > 
> > Behaves like I expected, and I see the 4MB I/O sizes. as I had already
> > tested
> > this.
> > 
> > dd if=/dev/sdw bs=4096k of=/dev/null iflag=direct
> > 
> > 
> > ### RECORD    6 >>> ibclient <<< (1482266543.001) (Tue Dec 20 15:42:23
> > 2016)
> > ###
> > # DISK STATISTICS (/sec)
> > #
> > <---------reads---------------><---------writes--------------><--------averages-------->
> > Pct
> > #Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size
> > Wait  RWSize  QLen  Wait SvcTim Util
> > 15:42:23 sdw         278528    201   68 4096     2       0      0    0    0
> > 0    4096     1     2      2   206
> > 
> > Rebooting back into 4.9 and will bisect leading to it once I confirm
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> So this is where I got to here:
> 
> These all worked and I get the 4MB I/O size with direct I/O
> 
> v4.8-rc4
> v4.8-rc5
> v4.8-rc6
> v4.8-rc7
> v4.8-rc8
> v4.9
> v4.9-rc1
> v4.9-rc2
> v4.9-rc3
> v4.9-rc4
> v4.9-rc5
> v4.9-rc6
> v4.9-rc7
> v4.9-rc8
> 
> Then git checkout master and build final test kernel
> 4.9.0+
> 
> This one fails
> 
> # DISK STATISTICS (/sec)
> #
> <---------reads---------------><---------writes--------------><--------averages-------->
> Pct
> #Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size
> Wait  RWSize  QLen  Wait SvcTim Util
> 22:12:48 sdw         1413120      0 1380 1024     2       0      0    0    0
> 0    1024     3     2      0   99
> 22:12:49 sdw         1409024      0 1376 1024     2       0      0    0    0
> 0    1024     3     2      0   98
> 22:12:50 sdw         1445888      0 1412 1024     2       0      0    0    0
> 0    1024     3     2      0   98
> 22:12:51 sdw         1429504      0 1396 1024     2       0      0    0    0
> 0    1024     3     2      0   98
> 22:12:52 sdw         1426432      0 1393 1024     2       0      0    0    0
> 0    1024     3     2      0   98
> 22:12:53 sdw         1408000      0 1375 1024     2       0      0    0    0
> 0    1024     3     2      0   98
>                                 ***      ****
>                                 ****
> 
> The last commit for 4.9-rc8 was 3e5de27
> 
> Between this and the master checkout HEAD there are 2313 lines of commits
> This was the giant merge.
> 
> Something broke here.
> I guess I will have to bisect the hard way, unless somebody realizes which of
> the commits broke it.
> 
> Commits for SRP, none of these look like candidates to break the I/O size and
> merge
> 
> 9032ad7 Merge branches 'misc', 'qedr', 'reject-helpers', 'rxe' and 'srp' into
> merge-test
> 4fa354c IB/srp: Make writing the add_target sysfs attr interruptible
> 290081b IB/srp: Make mapping failures easier to debug
> 3787d99 IB/srp: Make login failures easier to debug
> 042dd76 IB/srp: Introduce a local variable in srp_add_one()
> 1a1faf7 IB/srp: Fix CONFIG_DYNAMIC_DEBUG=n build
> 0d38c24 IB/srpt: Report login failures only once
> 
> dm related, however I am testing against an sd, not dm device here
> 
> ef548c5 dm flakey: introduce "error_writes" feature
> e99dda8f dm cache policy smq: use hash_32() instead of hash_32_generic()
> 027c431 dm crypt: reject key strings containing whitespace chars
> b446396 dm space map: always set ev if sm_ll_mutate() succeeds
> 0c79ce0 dm space map metadata: skip useless memcpy in
> metadata_ll_init_index()
> 314c25c dm space map metadata: fix 'struct sm_metadata' leak on failed create
> 58fc4fe Documentation: dm raid: define data_offset status field
> 11e2968 dm raid: fix discard support regression
> affa9d2 dm raid: don't allow "write behind" with raid4/5/6
> 54cd640 dm mpath: use hw_handler_params if attached hw_handler is same as
> requested
> c538f6e dm crypt: add ability to use keys from the kernel key retention
> service
> 0637018 dm array: remove a dead assignment in populate_ablock_with_values()
> 6080758 dm ioctl: use offsetof() instead of open-coding it
> b23df0d dm rq: simplify use_blk_mq initialization
> 41c73a4 dm bufio: drop the lock when doing GFP_NOIO allocation
> d12067f dm bufio: don't take the lock in dm_bufio_shrink_count
> 9ea61ca dm bufio: avoid sleeping while holding the dm_bufio lock
> 5b8c01f dm table: simplify dm_table_determine_type()
> 301fc3f dm table: an 'all_blk_mq' table must be loaded for a blk-mq DM device
> 6936c12 dm table: fix 'all_blk_mq' inconsistency when an empty table is
> loaded
> 
> I have time next week so will try narrow it down via bisect by commit
> 
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Started with bisect at > 6000 revisions and 13 cycles between v4.9-rc8 and master.
bisect good for v4.9-rc8, bisect bad for master HEAD

Down to around 700 now, but its late, going to bed now so will finish tomorrow  

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
