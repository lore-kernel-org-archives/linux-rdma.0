From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/5] Reduce RDMA RW API SGE limit
Date: Wed, 20 Jul 2016 10:43:53 -0400 (EDT)
Message-ID: <93123318.5861700.1469025833903.JavaMail.zimbra@redhat.com>
References: <8fb358c3-3504-02ca-fcb8-1624f28be1b0@sandisk.com> <1465736110.5730453.1468948485702.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465736110.5730453.1468948485702.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Parav Pandit" <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nicholas A. Bellinger"
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Tuesday, July 19, 2016 1:14:45 PM
> Subject: Re: [PATCH v3 0/5] Reduce RDMA RW API SGE limit
> 
> 
> 
> ----- Original Message -----
> > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > To: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> > "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
> > "Parav Pandit" <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Laurence Oberman"
> > <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger"
> > <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Tuesday, July 19, 2016 12:20:45 PM
> > Subject: [PATCH v3 0/5] Reduce RDMA RW API SGE limit
> > 
> > Hello Doug,
> > 
> > The five patches in this series modify the RDMA RW API slightly. This is
> > needed to avoid that the SRP and iSER target drivers submit RDMA
> > requests with an SGE list that exceeds the queue pair limits. The
> > ib_srpt changes in this series have been tested but the ib_isert changes
> > not yet.
> > 
> > The changes compared to v2 of this patch series are:
> > * For RDMA READs, limit SGE back to dev->attrs.max_sge_rd for iWARP.
> > 
> > Changes compared to v1:
> > * max_send_sge is now stored in struct ib_qp. This greatly simplifies
> >    this patch series.
> > * An unneeded initialization that I had added to rdma_rw_init_one_mr()
> >    has been left out again.
> > * Corrected "Fixes" tag in the patch description where needed.
> > 
> > The individual patches in this series are:
> > 
> > 0001-IB-core-Make-rdma_rw_ctx_init-initialize-all-used-fi.patch
> > 0002-IB-core-RDMA-RW-API-Do-not-exceed-QP-SGE-send-limit.patch
> > 0003-IB-srpt-Limit-the-number-of-SG-elements-per-work-req.patch
> > 0004-IB-srpt-Simplify-srpt_queue_response.patch
> > 0005-IB-isert-Remove-an-unused-member-variable.patch
> > 
> > Thanks,
> > 
> > Bart.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> Will pull and test these ASAP.
> 
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Replying to my own email:

Hello Bart

Testing SRP for these 5 patches here and I think the issues I am seeing may be changes in the latest upstream next kernel and not your code causing this.
'
I applied these to 4.7.0-rc7 and I am seeing some behavior I have not figured out yet.
I can find and map all LUNS via SRP but there are some differences in multipath.
I am still working on figuring some things out because I will likely have to apply these to an earlier base kernel to make sure.

I am not sure yet if something in the  4.7.0-rc7 base changed ALUA behavior, likely that is the case.
I have to go back and check.

On an older kernel with recent patches from you and Leon everything looks fine and is working fine.

4.7.0-rc1.bartleon+ 

360001ff0b035d000000000098d79000a dm-11 DDN     ,SFA14K          
size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=90 status=active
| `- 1:0:0:9  sdt  65:48  active ready running
`-+- policy='round-robin 0' prio=50 status=enabled
  `- 2:0:0:9  sdv  65:80  active ready running
360001ff0b035d000000000078d770008 dm-9 DDN     ,SFA14K          
size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=90 status=active
| `- 2:0:0:7  sds  65:32  active ready running
`-+- policy='round-robin 0' prio=50 status=enabled
  `- 1:0:0:7  sdp  8:240  active ready running


Looks fine here:

# time mkfs -t xfs -f  /dev/mapper/360001ff0b035d000000000078d770008 
meta-data=/dev/mapper/360001ff0b035d000000000078d770008 isize=256    agcount=33, agsize=243265536 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=7784628224, imaxpct=5
         =                       sunit=4096   swidth=4096 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Finishes quickly, as usual.

real	0m1.764s
user	0m0.006s
sys	0m0.168s


[root@jumpclient ~]# sg_rtpg -d /dev/sds
Report target port groups:
  target port group id : 0x0 , Pref=0
    target port group asymmetric access state : 0x01 (active/non optimized)
    T_SUP : 0, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x00 (no status available)
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x01
      0x02
  target port group id : 0x1 , Pref=0
    target port group asymmetric access state : 0x01 (active/non optimized)
    T_SUP : 0, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x00 (no status available)
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x03
      0x04
  target port group id : 0x2 , Pref=1
    target port group asymmetric access state : 0x00 (active/optimized)
    T_SUP : 0, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x00 (no status available)
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x05
      0x06
  target port group id : 0x3 , Pref=1
    target port group asymmetric access state : 0x01 (active/non optimized)
    T_SUP : 0, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x00 (no status available)
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x07
      0x08


On this new kernel,4.7.0-rc7.bart5+

I see this behaviour:
ALUA is failing to map properly against the SFA14K,and we are coming up active/active and not active optimized/active non-optimized.

Creating an xfs on the LUN take a long time

[root@jumptest1 ~]# time mkfs -t xfs -f  /dev/mapper/360001ff0b035d000000000078d770008 
meta-data=/dev/mapper/360001ff0b035d000000000078d770008 isize=512    agcount=33, agsize=243265536 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0
data     =                       bsize=4096   blocks=7784628224, imaxpct=5
         =                       sunit=4096   swidth=4096 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

real	10m34.395s
user	0m0.010s
sys	0m0.222s


[  321.500021] sd 2:0:0:29: alua: port group 01 state N non-preferred supports tolUsNA

360001ff0b035d000000000098d79000a dm-14 DDN     ,SFA14K          
size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=10 status=active
  |- 1:0:0:9  sdl  8:176  active ready running
  `- 2:0:0:9  sdba 67:64  active ready running
360001ff0b035d000000000078d770008 dm-12 DDN     ,SFA14K          
size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=10 status=active
  |- 1:0:0:7  sdj  8:144  active ready running
  `- 2:0:0:7  sday 67:32  active ready running

Checking with sg_rtpg looks right however ???

Report target port groups:
  target port group id : 0x0 , Pref=0
    target port group asymmetric access state : 0x01 (active/non optimized)
    T_SUP : 0, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x00 (no status available)
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x01
      0x02
  target port group id : 0x1 , Pref=0
    target port group asymmetric access state : 0x01 (active/non optimized)
    T_SUP : 0, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x00 (no status available)
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x03
      0x04
  target port group id : 0x2 , Pref=1
    target port group asymmetric access state : 0x00 (active/optimized)
    T_SUP : 0, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x00 (no status available)
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x05
      0x06
  target port group id : 0x3 , Pref=1
    target port group asymmetric access state : 0x01 (active/non optimized)
    T_SUP : 0, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x00 (no status available)
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x07
      0x08

Back when I have more.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
