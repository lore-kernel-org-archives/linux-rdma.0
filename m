From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Wed, 10 Jan 2018 16:17:21 -0500
Message-ID: <1515619041.10153.8.camel@redhat.com>
References: <1515529869.3919.4.camel@redhat.com>
         <1515531079.2721.26.camel@wdc.com> <1515531652.26021.1.camel@redhat.com>
         <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
         <20180110182648.GI4518@ziepe.ca> <1515609623.2745.20.camel@wdc.com>
         <1515610750.10153.1.camel@redhat.com> <20180110191510.GK4518@ziepe.ca>
         <1515612639.10153.3.camel@redhat.com> <20180110205243.GP4776@mellanox.com>
         <1515618674.10153.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515618674.10153.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-01-10 at 16:11 -0500, Laurence Oberman wrote:
> On Wed, 2018-01-10 at 13:52 -0700, Jason Gunthorpe wrote:
> > On Wed, Jan 10, 2018 at 02:30:39PM -0500, Laurence Oberman wrote:
> > 
> > > Just to be clear, I have posted two types of stack traces, one
> > > where I
> > > panic the other here above where I am not panicking.
> > 
> > Guessing it is just luck which you hit.. Random corrupted memory
> > and
> > all..
> > 
> > > This is not any special type of test. I booted the kernel, mapped
> > > the SRP devices from the target server and proceeded to shutdown
> > > the
> > > client with shutdown -r now.  This is part of my holistic test I
> > > always do against new patches in Bart's tree.  I start with
> > > reboots,
> > > them rmmod's etc. before I go on to perform I/O against the LUNS
> > > from the target.
> > 
> > Well, your shtudown is triggering the mlx driver shutdown code,
> > then it looks like the SRP stuff gets cleaned up? That certainly is
> > getting a bit exciting code wise
> > 
> > I see there have been some changes in the mlx5 shutdown handling
> > recently..
> > 
> > As an experiment comment out the '.shutdown = shutdown' in
> > drivers/net/ethernet/mellanox/mlx5/core/main.c?
> > 
> > And it would be interesting to know if your past success kernels
> > were
> > printing the mlx5 shutdown message too? Perhaps something core
> > kernel
> > changed to enable this path for your test?
> > 
> > Jason
> 
> Its a solid issue each time, the shutdown.
> 
> Here is rc6, I am building rc1 now and will then go to 4.14 to peel
> this onion
> 
> 4.15.0-rc6
> 
> [  150.600416] ---[ end trace fc9e16dc996e3246 ]---
> [  150.626405] mlx5_1:mlx5_ib_event:2992:(pid 14203): warning: event
> on
> port 0
> [  150.666308] scsi host1: ib_srp: failed RECV status WR flushed (5)
> for CQE 00000000ecb7c551
> [  150.712873] mlx5_core 0000:08:00.1:
> mlx5_enter_error_state:128:(pid
> 14203): end
> [  150.753463] mlx5_core 0000:08:00.0: Shutdown was called
> [  150.793126] mlx5_core 0000:08:00.0:
> mlx5_enter_error_state:121:(pid
> 14203): start
> [  150.835047] mlx5_0:mlx5_ib_event:2992:(pid 14203): warning: event
> on
> port 0
> [  150.874155] scsi host2: ib_srp: failed RECV status WR flushed (5)
> for CQE 00000000f7f26a7b
> [  150.919317] mlx5_core 0000:08:00.0:
> mlx5_enter_error_state:128:(pid
> 14203): end
> [  151.449010] reboot: Restarting system
> [  151.467644] reboot: machine restart
> 
> 
> Almost looks like changes made may require new Firmware maybe for my
> CX4 card because its coming from here and I dont like to see
> pci_err**
> called.
> 
> static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
>                                               pci_channel_state_t
> state)
> {
>         struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
>         struct mlx5_priv *priv = &dev->priv;
> 
>         dev_info(&pdev->dev, "%s was called\n", __func__);
> 
>         mlx5_enter_error_state(dev, false);
>         mlx5_unload_one(dev, priv, false);
>         /* In case of kernel call drain the health wq */
>         if (state) {
>                 mlx5_drain_health_wq(dev);
>                 mlx5_pci_disable_device(dev);
>         }
> 
>         return state == pci_channel_io_perm_failure ?
>                 PCI_ERS_RESULT_DISCONNECT :
> PCI_ERS_RESULT_NEED_RESET;
> }
> 

I will do this next, its possible its been there for a while and missed
as with no panics the messages would not have been a focus.

However keep in mind that other change sin the RDMA tree are more
sordid to see this shutdown then leas to list corruptions and panics.

Starting to make sense now based on what you said about the new
shutdown code.

Just going to try rc1 and then will do below as a test.

"As an experiment comment out the '.shutdown = shutdown' in
> > drivers/net/ethernet/mellanox/mlx5/core/main.c?
"

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
