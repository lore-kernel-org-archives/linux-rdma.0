From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Large ib_srp configuration cannot allocate FRM pool space and fails
 map SCSI host
Date: Thu, 29 Jun 2017 13:10:53 -0400
Message-ID: <4ccb9679-db6e-25e7-39ba-eab9186d35a5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello

This issue is apparent on RHEL and upstream 4.12-rc5 (that is what was 
tested)

Customer has a large configuration so I cannot reproduce this so asking 
if anybody else is aware of this.

We fail in FMR and we then keep incrementing the SCSI host#'s

Jun 20 14:01:42 xxxxxx kernel: fmr_pool: fmr_create failed for FMR 3809
Jun 20 14:01:42 xxxxxx kernel: fmr_pool: fmr_create failed for FMR 2005
Jun 20 14:01:42 xxxxxx kernel: scsi host7: ib_srp: FMR pool allocation 
failed (-12)
Jun 20 14:01:42 xxxxxx kernel: scsi host8: ib_srp: FMR pool allocation 
failed (-12)

This repeats over and over.

* 7 pairs of enclosures / each with two controllers
* Each with an expansion tray
* Each side on the controller is going to its own IB switch
* Each node is connected to both switches each running its own subnet 
manager

Prior versions of RHEL i.e. 7.2 that don't have the newer code that also 
exists upstream are working.
Both RHEL7.3 and upstream are affected.

The configuration in place is:

for srp.conf
a max_sect=65535,max_cmd_per_lun=254,queue_size=254

for ib_srp
options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048 prefer_fr=N

Failing here

In
struct ib_fmr_pool *ib_create_fmr_pool(struct ib_pd             *pd,
                                        struct ib_fmr_pool_param *params)
{
..
..

                         if (IS_ERR(fmr->fmr)) {
                                 pr_warn(PFX "fmr_create failed for FMR 
%d\n",
                                         i);
                                 kfree(fmr);
                                 goto out_fail;
                         }

Many Thanks
Laurence

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
