From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
 overflows the klms[] array
Date: Wed, 26 Apr 2017 07:46:33 -0400 (EDT)
Message-ID: <1801288254.2280763.1493207193850.JavaMail.zimbra@redhat.com>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com> <20170425175849.GS14088@mtr-leonro.local> <438230391.2090966.1493152655709.JavaMail.zimbra@redhat.com> <1493177952.3503.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493177952.3503.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
> Sent: Tuesday, April 25, 2017 11:39:12 PM
> Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> 
> On Tue, 2017-04-25 at 16:37 -0400, Laurence Oberman wrote:
> > Hello Bart, Leon, Max and Israel.
> > 
> > I cloned off Barts tree.
> > 
> > git clone https://github.com/bvanassche/linux
> > cd linux
> > git checkout block-scsi-for-next
> > 
> > I checked all patches were in for this test.
> > 
> > a83e404 IB/srp: Reenable IB_MR_TYPE_SG_GAPS
> > dfa5a2b mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> > f759c80 mlx5: Fix mlx5_ib_map_mr_sg mr lengt
> > 
> > Built and tested the kernel.
> > 
> > However this issue is not resolved :(
> > 
> > [ 2707.931909] scsi host1: ib_srp: failed RECV status WR flushed (5) for
> > CQE ffff8817edca86b0
> > [ 2708.089806] mlx5_0:dump_cqe:262:(pid 20129): dump error cqe
> > [ 2708.121342] 00000000 00000000 00000000 00000000
> > [ 2708.147104] 00000000 00000000 00000000 00000000
> > [ 2708.172633] 00000000 00000000 00000000 00000000
> > [ 2708.198702] 00000000 0f007806 2500002a 14a527d0
> > [ 2732.434127] scsi host1: ib_srp: reconnect succeeded
> > [ 2733.048023] scsi host1: ib_srp: failed RECV status WR flushed (5) for
> > CQE ffff8817ed0a9c30
> 
> Hello Laurence,
> 
> Thank you for having run this test. But are you aware that if a flush error
> is reported at the initiator side that does not necessarily mean that there
> is a bug at the initiator side? If e.g. the target system would initiate a
> disconnect that would also trigger this kind of flush errors. What kind of
> SRP target system was used in this test? Were the clocks of initiator and
> target system synchronized? Are the logs of the target system available? If
> so, can you have a look whether anything interesting can be found in the
> target log around the time the initiator reported the flush error?
> 
> Thanks,
> 
> Bart.

Hi Bart

Its the same target that is stable for all other tests.
This is the same issue I originally reported when we then reverted the SG+GAPS.
Remember when I reverted that we were stable again.

This happens on the initiator first

[root@localhost ~]# [  512.375904] mlx5_0:dump_cqe:262:(pid 4653): dump error cqe
[  512.376648] scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817c596f770
[  512.454276] 00000000 00000000 00000000 00000000
[  512.478734] 00000000 00000000 00000000 00000000
[  512.504170] 00000000 00000000 00000000 00000000
[  512.529457] 00000000 0f007806 2500002a 0548e2d0
[  532.128455] scsi host2: ib_srp: reconnect succeeded
[  532.232126] scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf2bb3bf0
[  532.780107] mlx5_0:dump_cqe:262:(pid 511): dump error cqe
[  532.811863] 00000000 00000000 00000000 00000000
[  532.837984] 00000000 00000000 00000000 00000000
[  532.863955] 00000000 00000000 00000000 00000000
[  532.889885] 00000000 0f007806 25000032 00683bd0

Only afterwards do I see the target complain

[root@fedstorage ~]# [  537.105985] ib_srpt Received CM TimeWait exit for ch 0x4e6e72000390fe7c7cfe900300726ed2-48.
[  537.152767] ib_srpt Received CM TimeWait exit for ch 0x4e6e72000390fe7c7cfe900300726ed2-47.
[  537.200585] ib_srpt Received CM TimeWait exit for ch 0x4e6e72000390fe7c7cfe900300726ed2-46.
[  537.247864] ib_srpt Received CM TimeWait exit for ch 0x4e6e72000390fe7c7cfe900300726ed2-45.
[  537.296822] ib_srpt Received CM TimeWait exit for ch 0x4e6e72000390fe7c7cfe900300726ed2-44.
[  537.345001] ib_srpt Received CM TimeWait exit for ch 0x4e6e72000390fe7c7cfe900300726ed2-43.
[  537.394146] ib_srpt Received CM TimeWait exit for ch 0x4e6e72000390fe7c7cfe900300726ed2-42.
[  537.442148] ib_srpt Received CM TimeWait exit for ch 0x4e6e72000390fe7c7cfe900300726ed2-41.
[  537.490011] ib_srpt sending response for ioctx 0xffff8800951ed800 failed with status 5
[  539.774018] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x4e6e72000390fe7c:0x7cfe900300726ed2, t_port_id 0x7cfe900300726e4e:0x7cfe900300726e4e and it_iu_len 4148 on port 1 (guid=0xfe80000000000000:0x7cfe900300726e4e)
[  539.887987] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x4e6e72000390fe7c:0x7cfe900300726ed2, t_port_id 0x7cfe900300726e4e:0x7cfe900300726e4e and it_iu_len 4148 on port 1 (guid=0xfe80000000000000:0x7cfe900300726e4e)
[  540.001241] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x4e6e72000390fe7c:0x7cfe900300726ed2, t_port_id 0x7cfe900300726e4e:0x7cfe900300726e4e and it_iu_len 4148 on port 1 (guid=0xfe80000000000000:0x7cfe900300726e4e)
[  540.111455] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x4e6e72000390fe7c:0x7cfe900300726ed2, t_port_id 0x7cfe900300726e4e:0x7cfe900300726e4e and it_iu_len 4148 on port 1 (guid=0xfe80000000000000:0x7cfe900300726e4e)
[  540.224780] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x4e6e72000390fe7c:0x7cfe900300726ed2, t_port_id 0x7cfe900300726e4e:0x7cfe900300726e4e and it_iu_len 4148 on port 1 (guid=0xfe80000000000000:0x7cfe900300726e4e)
[  540.340522] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x4e6e72000390fe7c:0x7cfe900300726ed2, t_port_id 0x7cfe900300726e4e:0x7cfe900300726e4e and it_iu_len 4148 on port 1 (guid=0xfe80000000000000:0x7cfe900300726e4e)
[  540.453736] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x4e6e72000390fe7c:0x7cfe900300726ed2, t_port_id 0x7cfe900300726e4e:0x7cfe900300726e4e and it_iu_len 4148 on port 1 (guid=0xfe80000000000000:0x7cfe900300726e4e)
[  540.567043] ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x4e6e72000390fe7c:0x7cfe900300726ed2, t_port_id 0x7cfe900300726e4e:0x7cfe900300726e4e and it_iu_len 4148 on port 1 (guid=0xfe80000000000000:0x7cfe900300726e4e)

Thanks
Laurence

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
