From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/core: Enhance ib_map_mr_sg()
Date: Wed, 11 May 2016 11:56:02 -0400 (EDT)
Message-ID: <1585010253.35292147.1462982162948.JavaMail.zimbra@redhat.com>
References: <573278D9.4050908@sandisk.com> <57327981.4080404@sandisk.com> <20160511075359.GE25215@leon.nu> <57334E35.3010403@sandisk.com> <688520061.35288974.1462980673444.JavaMail.zimbra@redhat.com> <573352B3.4030908@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <573352B3.4030908-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg"
> <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Or Gerlitz" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Sent: Wednesday, May 11, 2016 11:41:39 AM
> Subject: Re: [PATCH 4/6] IB/core: Enhance ib_map_mr_sg()
> 
> On 05/11/2016 08:31 AM, Laurence Oberman wrote:
> > I chased that for a while too.:)
> > Landed up pulling the latest next, applying all of Christoph's 11 RDMA
> > patches, then the first 11 of Barts and the latest 6.
> > I had to hand fix some stuff.
> > Kernel is building now for testing :)
> 
> Hello Laurence,
> 
> Please wait with starting your tests until I have made a kernel tree
> with this patch series available.
> 
> Thanks,
> 
> Bart.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Bart

I had started already, and its looking awesomely stable so far.
Awesome work from all of you guys.

### RECORD   84 >>> jumpclient <<< (1462981973.001) (Wed May 11 11:52:53 2016) ###
# DISK STATISTICS (/sec)
#                   <---------reads---------><---------writes---------><--------averages--------> Pct
#Time     Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size  RWSize  QLen  Wait SvcTim Util
11:52:53 sdc              0      0    0    0  163840      0   40 4096    4096     1    10     10   42
11:52:53 dm-6             0      0    0    0  327680    320   80 4096    4096     1    11     11   90
11:52:53 sdd              0      0    0    0  176128      0   43 4096    4096     1    10     10   44
11:52:53 dm-7             0      0    0    0  348160    336   85 4096    4096     1    11     10   92
11:52:53 sde              0      0    0    0  159744      0   39 4096    4096     1    11     11   43
11:52:53 dm-8             0      0    0    0  319488    312   78 4096    4096     1    11     11   89
11:52:53 sdf              4      0    1    4  167936      0   41 4096    3998     1    10     10   44
11:52:53 sdg              4      0    1    4  163840      0   40 4096    3996     1    10     10   44
11:52:53 dm-9             0      0    0    0  335872    328   82 4096    4096     1    11     11   91
11:52:53 dm-10            0      0    0    0  331776    324   81 4096    4096     1    11     11   91
11:52:53 sdh              4      0    1    4  159744      0   39 4096    3993     1    11     11   45
11:52:53 dm-11            0      0    0    0  319488    308   78 4096    4096     1    11     11   91
11:52:53 sdi              0      0    0    0  167936      0   41 4096    4096     1    10     10   43
11:52:53 dm-12            0      0    0    0  335872    328   82 4096    4096     1    11     11   93
11:52:53 sdj              0      0    0    0  172032      0   42 4096    4096     1    10     10   44
11:52:53 dm-13            0      0    0    0  344064    332   84 4096    4096     1    10     10   91
11:52:53 sdk              0      0    0    0  176128      0   43 4096    4096     1    11     11   47
11:52:53 dm-14            0      0    0    0  352256    344   86 4096    4096     1    10     10   91
11:52:53 sdl              0      0    0    0  163840      0   40 4096    4096     1    10     11   43
11:52:53 dm-15            0      0    0    0  331776    324   81 4096    4096     1    11     11   91
11:52:53 sdm              0      0    0    0  163840      0   40 4096    4096     1    11     11   45
11:52:53 sdn              0      0    0    0  172032      0   42 4096    4096     1    10     10   45
11:52:53 sdo              0      0    0    0  159744      0   39 4096    4096     1    11     11   44
11:52:53 sdp              4      0    1    4  167936      0   41 4096    3998     1    10     10   45
11:52:53 sdq              0      0    0    0  167936      0   41 4096    4096     1    11     11   45
11:52:53 sdr              4      0    1    4  159744      0   39 4096    3993     1    11     10   43
11:52:53 sds              0      0    0    0  167936      0   41 4096    4096     1    11     11   46
11:52:53 sdt              0      0    0    0  172032      0   42 4096    4096     1    10     10   44
11:52:53 sdu              0      0    0    0  176128      0   43 4096    4096     1     9      9   42
11:52:53 sdv              0      0    0    0  167936      0   41 4096    4096     1    11     11   45

Whoop, 3.2GBytes/sec and no errors :)

#         <----CPU[HYPER]-----><----------Disks-----------><----------Network---------->
#Time     cpu sys inter  ctxsw KBRead  Reads KBWrit Writes   KBIn  PktIn  KBOut  PktOut 
11:55:21    7   7  2652   7721     12      3  3223K    974      0      3      0       3 
11:55:22    7   7  2714   7984      4      1  3336K    834      0      1      0       1 
11:55:23    6   6  2545   7698      0      0  3216K    804      0      1      0       1 
11:55:24    7   7  2576   7455      0      0  3012K    758      0      3      0       1 
11:55:25    6   6  2717   8096     24      6  3314K    900      0      1      0       1 
11:55:26    7   7  2651   7807      0      0  3118K    955      1      9      2      11 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
