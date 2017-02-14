From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] IB/srp bug fixes
Date: Tue, 14 Feb 2017 13:47:47 -0500 (EST)
Message-ID: <1364431877.31401761.1487098067033.JavaMail.zimbra@redhat.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com> <20170210235611.3243-9-bart.vanassche@sandisk.com> <20170212171928.GF14015@mtr-leonro.local> <1041506550.30101266.1486922573298.JavaMail.zimbra@redhat.com> <1051975432.30101289.1486922792858.JavaMail.zimbra@redhat.com> <1465409120.30916025.1487041332560.JavaMail.zimbra@redhat.com> <1487092678.2466.6.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487092678.2466.6.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Sent: Tuesday, February 14, 2017 12:18:11 PM
> Subject: Re:   [PATCH 0/8] IB/srp bug fixes
> 
> On Mon, 2017-02-13 at 22:02 -0500, Laurence Oberman wrote:
> > The following 7 of 8 patches were applied to Linus's latest tree.
> > 
> > However this required first reverting
> > 
> > commit ad8e66b4a80182174f73487ed25fd2140cf43361
> > Author: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Date:   Wed Dec 28 12:48:28 2016 +0200
> > 
> > See my other email regarding why the above needed to be reverted.
> > 
> > All tests passed in my mlx5 EDR-100 test bed for the ib-srp/mlx5 tests.
> > 
> > 4.10.0-rc8.bart+
> > 
> > The revert of the above meant I did not apply and test patch 6 of the
> > series
> > IB/srp: Use the IB_DEVICE_SG_GAPS_REG HCA feature if supported
> > 
> >   IB/srp: Avoid that duplicate responses trigger a kernel bug
> >   IB/srp: Fix race conditions related to task management
> >   IB/srp: Document locking conventions
> >   IB/srp: Make a diagnostic message more informative
> >   IB/srp: Improve an error path
> >   *** Not applied and not tested IB/srp: Use the IB_DEVICE_SG_GAPS_REG HCA
> >   feature if supported
> >   IB/core: Add support for draining IB_POLL_DIRECT completion queues
> >   IB/srp: Drain the send queue before destroying a QP
> > 
> > For the series except patch 6
> > 
> > Tested-by:     Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Hello Laurence,
> 
> Thank you for the testing. However, reverting commit ad8e66b4a801 without
> making any further changes is not acceptable because it would reintroduce
> the SG-list mapping problem addressed by that patch. Can you test the
> srp-initiator-for-next branch from my github repository against mlx5 (commit
> 8dca762deab6)? It passes my tests against mlx4. The patches on that branch
> are:
> 
> Bart Van Assche (8):
>       IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
>       IB/srp: Avoid that duplicate responses trigger a kernel bug
>       IB/srp: Fix race conditions related to task management
>       IB/srp: Document locking conventions
>       IB/srp: Make a diagnostic message more informative
>       IB/srp: Improve an error path
>       IB/core: Add support for draining IB_POLL_DIRECT completion queues
>       IB/srp: Drain the send queue before destroying a QP
> 
> Thanks,
> 
> Bart.--
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Bart

4.10.0-rc8.bart_latest+

Built from branch srp-initiator-for-next after pull of your repository.

The large I/O testing is what I focused on but all tests are passing.
small/large I/O, direct and buffered I/O, file-system and direct to mpath devices.

This is a snap of 4 simultaneous 4MB I/O read tasks and 1 buffered write task (that will sporadically exceed 4MB)/

### RECORD    7 >>> ibclient <<< (1487097890.001) (Tue Feb 14 13:44:50 2017) ###
# DISK STATISTICS (/sec)
#                   <---------reads---------------><---------writes--------------><--------averages--------> Pct
#Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size  Wait  RWSize  QLen  Wait SvcTim Util
13:44:50 dm-11       192512    141   47 4096    20       0      0    0    0     0    4096     1    20     21   99
13:44:50 dm-17       184320    135   45 4096    20       0      0    0    0     0    4096     1    20     22   99
13:44:50 dm-21       163840    120   40 4096    21  1236928   1984  153 8084   319    7257    91   257      5   99
13:44:50 dm-24       786432    576  192 4096     5       0      0    0    0     0    4096     1     5      5   99
13:44:50 dm-30       790528    579  193 4096     5       0      0    0    0     0    4096     1     5      5   99

It looks good Bart

For branch srp-initiator-for-next, all tests are passing.
Tested-by:     Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
