From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Tue, 14 Jun 2016 14:41:18 -0400 (EDT)
Message-ID: <1167916510.42202925.1465929678588.JavaMail.zimbra@redhat.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com> <1964187258.42093298.1465869387551.JavaMail.zimbra@redhat.com> <11e680c4-84b3-1cd6-133c-36f71bd853d0@sandisk.com> <20160614120833.GO5408@leon.nu> <fe7c9713-2864-7b6c-53ec-f5d1364d65d8@sandisk.com> <20160614131552.GP5408@leon.nu> <1531921470.42169965.1465912634165.JavaMail.zimbra@redhat.com> <1296246237.42197305.1465926035162.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296246237.42197305.1465926035162.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Tuesday, June 14, 2016 1:40:35 PM
> Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in swiotlb_alloc_coherent()
> 
> 
> 
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> > Cc: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Yishai Hadas"
> > <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Tuesday, June 14, 2016 9:57:14 AM
> > Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
> > swiotlb_alloc_coherent()
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > Cc: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Yishai Hadas"
> > > <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Sent: Tuesday, June 14, 2016 9:15:52 AM
> > > Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
> > > swiotlb_alloc_coherent()
> > > 
> > > On Tue, Jun 14, 2016 at 02:25:15PM +0200, Bart Van Assche wrote:
> > > > On 06/14/2016 02:08 PM, Leon Romanovsky wrote:
> > > > >On Tue, Jun 14, 2016 at 11:24:28AM +0200, Bart Van Assche wrote:
> > > > >>On 06/14/2016 03:56 AM, Laurence Oberman wrote:
> > > > >>>Tracing [ ... ]
> > > > >>
> > > > >>Can you try to set the kernel command line parameter swiotlb to a
> > > > >>value
> > > > >>that
> > > > >>is a multiple of its default (64MB), reboot and see whether that
> > > > >>helps?
> > > > >>See
> > > > >>also Documentation/kernel-parameters.txt in the kernel tree.
> > > > >
> > > > >Do you think that 64MB is not enough for this scenario?
> > > > 
> > > > Hello Leon,
> > > > 
> > > > Does this mean that you think that the "swiotlb buffer is full"
> > > > messages
> > > > reported by Laurence could be caused by something else than hitting the
> > > > swiotlb limit?
> > > 
> > > I don't have enough knowledge in that area to answer if message "swiotlb
> > > buffer is full" is correctly explain current situation and I will be
> > > glad to get input from you about it.
> > > 
> > > Thanks.
> > > 
> > > > 
> > > > Bart.
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > > > in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > Hello Bart and Leon
> > 
> > Set to swiotlb=4, I no longer have the swiotlb issue.
> > Its no longer taking the error path so I confirm that increasing the
> > swiotlb
> > slab count solves this issue.
> > 
> > BOOT_IMAGE=/vmlinuz-4.7.0-rc1.bart.swiotlb+ root=/dev/mapper/rhel-root ro
> > crashkernel=auto rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap
> > console=ttyS1,115200n8 scsi_mod.use_blk_mq=1 swiotlb=4
> > 
> > I am in the process of preparing a Doc patch for IB/srp and IB/srpt where I
> > have captured all the tuning work I have done with Bart.
> > I will add this to the Doc patch priot to sending it.
> > 
> > Many Thanks
> > Laurence
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> Seems I may have spoken too soon here. :(
> 
> I increased the ib_srp params to max values and I see it again
> options ib_srp cmd_sg_entries=256 indirect_sg_entries=2048
> 
> [ 1344.111449] sd 2:0:0:27: rejecting I/O to offline device
> [ 1345.815918] scsi host2: reconnect attempt 3 failed (-12)
> [ 1363.744587] mlx5_core 0000:08:00.1: swiotlb buffer is full (sz: 266240
> bytes)
> [ 1363.781476] RHDEBUG: wrap=56 index=56
> [ 1363.802643] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
> [ 1365.361446] scsi host2: reconnect attempt 4 failed (-12)
> [ 1375.468042] mlx5_core 0000:08:00.1: swiotlb buffer is full (sz: 266240
> bytes)
> [ 1375.506694] RHDEBUG: wrap=56 index=56
> [ 1375.526821] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
> [ 1375.820655] mlx5_core 0000:08:00.1: swiotlb buffer is full (sz: 266240
> bytes)
> [ 1375.857679] RHDEBUG: wrap=56 index=56
> [ 1375.877973] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
> [ 1384.729797] scsi host2: reconnect attempt 5 failed (-24)
> [ 1406.100966] scsi host2: ib_srp: Got failed path rec status -110
> [ 1406.133565] scsi host2: ib_srp: Path record query failed
> [ 1406.163410] scsi host2: reconnect attempt 6 failed (-110)
> [ 1424.229937] scsi host2:   REJ reason 0x8
> [ 1424.251503] scsi host2: reconnect attempt 7 failed (-104)
> [ 1443.257233] scsi host2:   REJ reason 0x8
> [ 1443.280298] scsi host2: reconnect attempt 8 failed (-104)
> [ 1466.691538] scsi host2:   REJ reason 0x8
> [ 1466.712377] scsi host2: reconnect attempt 9 failed (-104)
> 
> I will increase the swiotlb to 8 from 4 and see what happens, but maybe I
> just got lucky prior.
> Will update the thread when its consistent either way.
> 
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

This may be a data point here
After each change I have rebooted the host as its required.
I am at swiotlb=16 and after the first reboot with maxed out tuning I had no alerts.
On the second controller restart without a system reboot I got them again.

Again, I never see these other than when I am in  the reconnect loop, and they seem to be non-intrusive as each time I recover fully.

When I first changed to 4 and had not increased the ib_srp paramaters I had two restarts with no messages so that was what led me to report that this seems to have worked.
I can see now that this was not the case and already mentioned, the claim that the change fixed this was wrong.
Apologies for that.

I am continuing to research and debug now.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
