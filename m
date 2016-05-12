From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/core: Enhance ib_map_mr_sg()
Date: Thu, 12 May 2016 12:38:13 -0400 (EDT)
Message-ID: <2086883286.35494019.1463071093121.JavaMail.zimbra@redhat.com>
References: <573278D9.4050908@sandisk.com> <57327981.4080404@sandisk.com> <20160511075359.GE25215@leon.nu> <57334E35.3010403@sandisk.com> <688520061.35288974.1462980673444.JavaMail.zimbra@redhat.com> <573352B3.4030908@sandisk.com> <1821483712.35493025.1463070514224.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1821483712.35493025.1463070514224.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg"
> <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Or Gerlitz" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Sent: Thursday, May 12, 2016 12:28:34 PM
> Subject: Re: [PATCH 4/6] IB/core: Enhance ib_map_mr_sg()
> 
> 
> 
> ----- Original Message -----
> > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Christoph
> > Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg"
> > <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Or Gerlitz"
> > <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Sent: Wednesday, May 11, 2016 11:41:39 AM
> > Subject: Re: [PATCH 4/6] IB/core: Enhance ib_map_mr_sg()
> > 
> > On 05/11/2016 08:31 AM, Laurence Oberman wrote:
> > > I chased that for a while too.:)
> > > Landed up pulling the latest next, applying all of Christoph's 11 RDMA
> > > patches, then the first 11 of Barts and the latest 6.
> > > I had to hand fix some stuff.
> > > Kernel is building now for testing :)
> > 
> > Hello Laurence,
> > 
> > Please wait with starting your tests until I have made a kernel tree
> > with this patch series available.
> > 
> > Thanks,
> > 
> > Bart.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> For Barts latest set of patches see subject, using Barts's tree the mapping
> failures are gone and its run for over 24 hours stable.
> This is with multiple parallel reads of 4MB issued direct and multiple
> parallel writes to the same mpath devices issued buffered.
> The only variation from what I am used to seeing (when its not failing :) on
> prior ib_srp) is that the I/O sizes reach 4MB often but are also often
> smaller.
> Some of this could be issues with my LIO target and next week will have an
> enterprise array directly connected I will be testing with.
> 
> Its a huge improvement and seems good to me as I know these failures very
> well.
> 
> Tested-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Example with direct reads and buffered writes
> 
> mpath view
> 
> ### RECORD  556 >>> jumpclient <<< (1463070126.001) (Thu May 12 12:22:06
> 2016) ###
> # DISK STATISTICS (/sec)
> #
> <---------reads---------><---------writes---------><--------averages-------->
> Pct
> #Time     Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size  RWSize
> QLen  Wait SvcTim Util
> 12:22:06 dm-6        212992    128  247  862  130200     64  126 1033     920
> 7    20      2   99
> 12:22:06 dm-7        213180     52  885  241  118784     29  406  293     257
> 25    20      0   99
> 12:22:06 dm-8        217088     53  424  512  122880     60  270  455     489
> 14    21      1   99
> 12:22:06 dm-9        211968     52  465  456  119760     30  409  293     379
> 19    22      1   99
> 12:22:06 dm-10       212992     52  364  585  121340     60  146  831     655
> 10    20      1   99
> 12:22:06 dm-11       221184    162   54 4096  135168     33  297  455    1015
> 9    26      2   99  *** Reads reach 4MB here, often smaller though
> 12:22:06 dm-12       229376    168  280  819  126976     93   62 2048    1041
> 6    17      2   99
> 12:22:06 dm-13       229376    168  112 2048  131072     64  128 1024    1501
> 5    23      4   99
> 12:22:06 dm-14       225280    110  385  585  122880     29  185  664     610
> 11    20      1   99
> 12:22:06 dm-15       203912     50  549  371  118792     29  379  313     347
> 20    21      1   99
> 
> individual path view
> 
> ### RECORD  556 >>> jumpclient <<< (1463070126.001) (Thu May 12 12:22:06
> 2016) ###
> # DISK STATISTICS (/sec)
> #
> <---------reads---------><---------writes---------><--------averages-------->
> Pct
> #Time     Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size  RWSize
> QLen  Wait SvcTim Util
> 12:26:37 sdc         128092      0  348  368   44468      0  482   92     207
> 18    21      1   95
> 12:26:37 sdd         103476      0  461  224   62956      0  266  237     228
> 14    20      1   97
> 12:26:37 sde         118100      0  145  814   65488      0  127  516     674
> 5    19      3   97
> 12:26:37 sdf         121660      0  651  187   53960      0  277  195     189
> 17    18      1   97
> 12:26:37 sdg          87276      0  305  286   76020      0  191  398     329
> 10    20      1   97
> 12:26:37 sdh          98688      0  166  595   67400      0  554  122     230
> 17    23      1   95
> 12:26:37 sdi         197112      0  945  209   16208      0   81  200     207
> 16    15      0   99
> 12:26:37 sdj           1776      0   16  111  143360      0   35 4096    2845
> 1    24     18   95
> 12:26:37 sdk              0      0    0    0  139264      0  374  372     372
> 10    26      2   96
> 12:26:37 sdl          77600      0  572  136   76624      0  268  286     183
> 17    19      1   93
> 12:26:37 sdm          80804      0  264  306   74316      0  533  139     194
> 19    24      1   98
> 12:26:37 sdn         101324      0  439  231   64020      0  385  166     200
> 18    22      1   98
> 12:26:37 sdo         107180      0  130  824   73776      0  145  509     658
> 5    21      3   97
> 12:26:37 sdp          80788      0  389  208   69376      0  339  205     206
> 17    22      1   99
> 12:26:37 sdq         116704      0  390  299   55052      0  129  427     330
> 10    20      1   99
> 12:26:37 sdr         113280      0  249  455   53816      0  401  134     257
> 16    24      1   99
> 12:26:37 sds          13192      0   93  142  110768      0  291  381     322
> 10    26      2   95
> 12:26:37 sdt         165184      0 1197  138       0      0    0    0     137
> 23    18      0   99
> 12:26:37 sdu         241664      0   59 4096       0      0    0    0    4096
> 1    16     16   97
> 

Bart,
I meant to mention that that was with ib_srp untuned.
My next set of tests will be with indirect_sg_entries=512 and cmd_sg_entries=64 for a start.
Then I will max them out and see how we do.

Thanks!!!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
