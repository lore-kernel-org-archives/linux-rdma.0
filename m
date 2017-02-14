From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: v4.10-rc SRP + mlx5 regression
Date: Tue, 14 Feb 2017 11:21:02 -0500 (EST)
Message-ID: <1762516180.31350298.1487089262844.JavaMail.zimbra@redhat.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com> <1301607843.30852658.1487021644535.JavaMail.zimbra@redhat.com> <898197116.30855343.1487022400065.JavaMail.zimbra@redhat.com> <1487022735.2719.7.camel@sandisk.com> <568916592.30910570.1487038794766.JavaMail.zimbra@redhat.com> <20170214063953.GF6989@mtr-leonro.local> <bfca98d3-3f74-c370-7455-71e2ebd583e9@mellanox.com> <656778124.31118982.1487079062235.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <656778124.31118982.1487079062235.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org,
> israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Sent: Tuesday, February 14, 2017 8:31:02 AM
> Subject: Re: v4.10-rc SRP + mlx5 regression
> 
> 
> 
> ----- Original Message -----
> > From: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > To: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Laurence Oberman"
> > <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org,
> > israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> > dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > Sent: Tuesday, February 14, 2017 5:00:04 AM
> > Subject: Re: v4.10-rc SRP + mlx5 regression
> > 
> > Hi Laurence,
> > can you specify the test that repro these failures ?
> > have you tried running with CX5 HCA or only CX4 ?
> > I think this commit is right and we have issues in other places.
> > 
> > 
> > On 2/14/2017 8:39 AM, Leon Romanovsky wrote:
> > > On Mon, Feb 13, 2017 at 09:19:54PM -0500, Laurence Oberman wrote:
> > >>
> > >>
> > >> ----- Original Message -----
> > >>> From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > >>> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > >>> Cc: hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > >>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > >>> Sent: Monday, February 13, 2017 4:52:28 PM
> > >>> Subject: Re: v4.10-rc SRP + mlx5 regression
> > >>>
> > >>> On Mon, 2017-02-13 at 16:46 -0500, Laurence Oberman wrote:
> > >>>> I will have to run through this again and see where the bisect went
> > >>>> wrong.
> > >>>
> > >>> Hello Laurence,
> > >>>
> > >>> If you would be considering to repeat the bisect, did you know that a
> > >>> bisect
> > >>> can be sped up by specifying the names of the files and/or directories
> > >>> that
> > >>> are suspected? An example:
> > >>>
> > >>> git bisect start */infiniband */net
> > >>>
> > >>> Bart.--
> > >>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > >>> in
> > >>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >>>
> > >>
> > >> Hello Bart,
> > >>
> > >> Much better news this time :), worked late on this but got it figured
> > >> out.
> > >>
> > >> OK, so we got to this one, which makes a lot more sense and is right in
> > >> the area where we are having issues.
> > >> I must have answered wrong to one of the steps the first time I did the
> > >> bisect.
> > >>
> > >> Reverted this in the master tree of rc8 and rebuilt the kernel
> > >> Now all tests pass on Linus's tree - 4.10.0_rc8+
> > >>
> > >> The interesting point here is that this commit is in rc5 but rc5 was not
> > >> failing so we have an interoperability issue with this commit
> > >>
> > >>
> > >> [loberman@ibclient linux]$ git bisect good
> > >> Bisecting: 0 revisions left to test after this (roughly 1 step)
> > >> [ad8e66b4a80182174f73487ed25fd2140cf43361] IB/srp: fix mr allocation
> > >> when
> > >> the device supports sg gaps
> > >>
> > >> [loberman@ibclient linux]$ git show
> > >> ad8e66b4a80182174f73487ed25fd2140cf43361
> > >> commit ad8e66b4a80182174f73487ed25fd2140cf43361
> > >> Author: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >> Date:   Wed Dec 28 12:48:28 2016 +0200
> > >>
> > >>     IB/srp: fix mr allocation when the device supports sg gaps
> > >>
> > >>     If the device support arbitrary sg list mapping (device cap
> > >>     IB_DEVICE_SG_GAPS_REG set) we allocate the memory regions with
> > >>     IB_MR_TYPE_SG_GAPS.
> > >>
> > >>     Fixes: 509c5f33f4f6 ("IB/srp: Prevent mapping failures")
> > >>     Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.7+
> > >>     Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >>     Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >>     Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >>     Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >>     Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > >>     Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > >>     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > >>
> > >> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
> > >> b/drivers/infiniband/ulp/srp/ib_srp.c
> > >> index 8ddc071..0f67cf9 100644
> > >> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> > >> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> > >> @@ -371,6 +371,7 @@ static struct srp_fr_pool *srp_create_fr_pool(struct
> > >> ib_device *device,
> > >>         struct srp_fr_desc *d;
> > >>         struct ib_mr *mr;
> > >>         int i, ret = -EINVAL;
> > >> +       enum ib_mr_type mr_type;
> > >>
> > >>         if (pool_size <= 0)
> > >>                 goto err;
> > >> @@ -384,9 +385,13 @@ static struct srp_fr_pool
> > >> *srp_create_fr_pool(struct
> > >> ib_device *device,
> > >>         spin_lock_init(&pool->lock);
> > >>         INIT_LIST_HEAD(&pool->free_list);
> > >>
> > >> +       if (device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
> > >> +               mr_type = IB_MR_TYPE_SG_GAPS;
> > >> +       else
> > >> +               mr_type = IB_MR_TYPE_MEM_REG;
> > >> +
> > >>         for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
> > >> -               mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
> > >> -                                max_page_list_len);
> > >> +               mr = ib_alloc_mr(pd, mr_type, max_page_list_len);
> > >
> > > First, ib_alloc_mr receives u32 as a third parameter, but int was
> > > supplied. Second (I can be wrong here), shouldn't max_page_list_len be
> > > replaced with max_fast_reg_page_list_len?
> > >
> > > Thanks
> > 
> > there is a statement that:
> > 
> > 	if (srp_dev->use_fast_reg) {
> >                  srp_dev->max_pages_per_mr =
> >                          min_t(u32, srp_dev->max_pages_per_mr,
> >                                attr->max_fast_reg_page_list_len);
> >          }
> > 
> > so we take the max_fast_reg_page_list_len in this case.
> > 
> > >
> > >>                 if (IS_ERR(mr)) {
> > >>                         ret = PTR_ERR(mr);
> > >>                         if (ret == -ENOMEM)
> > >> (END)
> > >>
> > >>
> > >> So here is the revert patch, but you need to decide how you want to deal
> > >> with this.
> > >>
> > >>     Revert "IB/srp: fix mr allocation when the device supports sg gaps"
> > >>     Laurence Oberman
> > >>     Traced after bisection to a cause for this failure
> > >>
> > >> Tested-by:     Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > >> Signed-off-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > >>
> > >> commit 90d169d312a173d5350c1bb36d6daab04c592127
> > >> Author: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > >> Date:   Mon Feb 13 20:33:32 2017 -0500
> > >>
> > >>     Revert "IB/srp: fix mr allocation when the device supports sg gaps"
> > >>     Laurence Oberman
> > >>     Traced after bisection to a cause for this failure
> > >>
> > >>     [  130.437603] mlx5_0:dump_cqe:262:(pid 3812): dump error cqe
> > >>     [  130.437682] scsi host1: ib_srp: failed RECV status WR flushed (5)
> > >>     for CQE ffff8817f0edbfb0
> > >>     [  130.510899] 00000000 00000000 00000000 00000000
> > >>     [  130.536455] 00000000 00000000 00000000 00000000
> > >>     [  130.561878] 00000000 00000000 00000000 00000000
> > >>     [  130.585904] 00000000 0f007806 2500002a db0ec4d0
> > >>     [  145.842925] fast_io_fail_tmo expired for SRP port-1:1 / host1.
> > >>     [  146.530439] scsi host1: ib_srp: reconnect succeeded
> > >>     [  146.566629] mlx5_0:dump_cqe:262:(pid 3293): dump error cqe
> > >>     [  146.597635] 00000000 00000000 00000000 00000000
> > >>     [  146.623545] 00000000 00000000 00000000 00000000
> > >>     [  146.649599] 00000000 00000000 00000000 00000000
> > >>     [  146.673938] 00000000 0f007806 25000032 000c46d0
> > >>     [  146.697969] scsi host1: ib_srp: failed FAST REG status memory
> > >>     management operation error (6) for CQE ffff88
> > >>     [  162.225247] fast_io_fail_tmo expired for SRP port-1:1 / host1.
> > >>     [  162.256337] scsi host1: ib_srp: reconnect succeeded
> > >>     [  162.293396] scsi host1: ib_srp: failed RECV status WR flushed (5)
> > >>     for CQE ffff8817f0412ef0`
> > >>
> > >>     This reverts commit ad8e66b4a80182174f73487ed25fd2140cf43361.
> > >>
> > >> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
> > >> b/drivers/infiniband/ulp/srp/ib_srp.c
> > >> index 79bf484..01338c8 100644
> > >> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> > >> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> > >> @@ -371,7 +371,6 @@ static struct srp_fr_pool *srp_create_fr_pool(struct
> > >> ib_device *device,
> > >>         struct srp_fr_desc *d;
> > >>         struct ib_mr *mr;
> > >>         int i, ret = -EINVAL;
> > >> -       enum ib_mr_type mr_type;
> > >>
> > >>         if (pool_size <= 0)
> > >>                 goto err;
> > >> @@ -385,13 +384,9 @@ static struct srp_fr_pool
> > >> *srp_create_fr_pool(struct
> > >> ib_device *device,
> > >>         spin_lock_init(&pool->lock);
> > >>         INIT_LIST_HEAD(&pool->free_list);
> > >>
> > >> -       if (device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
> > >> -               mr_type = IB_MR_TYPE_SG_GAPS;
> > >> -       else
> > >> -               mr_type = IB_MR_TYPE_MEM_REG;
> > >> -
> > >>         for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
> > >> -               mr = ib_alloc_mr(pd, mr_type, max_page_list_len);
> > >> +               mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
> > >> +                                max_page_list_len);
> > >>                 if (IS_ERR(mr)) {
> > >>                         ret = PTR_ERR(mr);
> > >>                         if (ret == -ENOMEM)
> > >>
> > >>
> > >>
> > >> Now moving on to what got me here in the first place.
> > >> Bart, let me know if the 7 of the 8 patches in your most recent series
> > >> are
> > >> all still valid after this revert
> > >> Otherwise let me know which ones you want me to apply.
> > >>
> > >> patch 6 - I am thinking i sno longer valid.
> > >> "
> > >> If a HCA supports the SG_GAPS_REG feature then a single memory
> > >> region of type IB_MR_TYPE_SG_GAPS is sufficient. This patch
> > >> reduces the number of memory regions that is allocated per SRP
> > >> session.
> > >> "
> > >>
> > >> Thanks
> > >> Laurence
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> Hello Max,
> 
> I only have CX4 and CX3 in my lab, this test bed only has CX4.
> 
> CA 'mlx5_0'
> 	CA type: MT4115
> 	Number of ports: 1
> 	Firmware version: 12.14.2036
> 	Hardware version: 0
> 	Node GUID: 0x7cfe900300726ed2
> 	System image GUID: 0x7cfe900300726ed2
> 	Port 1:
> 		State: Active
> 		Physical state: LinkUp
> 		Rate: 100
> 		Base lid: 3
> 		LMC: 0
> 		SM lid: 3
> 		Capability mask: 0x2651e84a
> 		Port GUID: 0x7cfe900300726ed2
> 		Link layer: InfiniBand
> 
> The test is simple, it's the same one I start with every time because it
> always
> brings out issues with mapping for large I/O sizes and mem registration if
> such issues exist.
> 
> I have a server running LIO with memory backed LUNS.
> These are served via a dual port mlx5 (CX4) over ib_srpt
> 
> The client mounts these LUNS via ib_srp (mlx5) and device-mapper-multipath
> and I run a simple dd on the XFS file system.
> 
> #!/bin/bash
> while true
> do
> 	dd if=/dev/zero of=/data-$1/bigfile bs=4096k count=900
> 	sync;
> 	rm -rf /data-$1/bigfile
> done
> 
> Once this passes I run a suite of other tests read/write, direct and
> buffered.
> 
> Thanks
> Laurence
> 
> 

Max, Leon, Israel, Bart and Doug

We should consider reverting that commit for now until we figure out what specifically brings this out unless a quick fix is
forthcoming.
I have been running since last night with that commit reverted and 7 of Bart's latest patches and its been rock solid stable.
Its also shown no issues performance wise.

Tests included read/writes, large/small I/O sizes, buffered and unbuffered, XFS file-system and direct I/O.

Thanks
Laurence

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
