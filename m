From: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH v2 00/18] Increase maximum number of Infiniband HCAs
	per system
Date: Mon, 8 Feb 2010 14:30:14 -0700
Message-ID: <20100208213014.GA3503@grease>
References: <20100202185235.28217.64521.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
Sender: linux-kernel-owner@vger.kernel.org
To: rdreier@cisco.com
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Any thoughts on this patch series?

Thanks,
/ac

* Alex Chiang <achiang@hp.com>:
> This is v2 of a patch series that increases the maximum number of
> IB HCAs supported per system.
> 
> The original mail thread is here:
> 	http://lkml.org/lkml/2010/1/29/346
> 
> One note, I decided to "copy/paste" since factoring out the overflow
> code in the three drivers seemed like overkill. If so desired, I could
> factor those three separate functions into something provided by the
> core, but that seemed like more trouble than it was worth at the time.
> 
> As before, I still don't have access to a giant system, so what I did
> to test was to stick 4 cards into a small system, and then modify the
> limits with debug patches similar to this:
> 
> diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
> index 7bf0a82..8581e64 100644
> --- a/drivers/infiniband/core/ucm.c
> +++ b/drivers/infiniband/core/ucm.c
> @@ -102,7 +102,7 @@ struct ib_ucm_event {
>  enum {
>         IB_UCM_MAJOR = 231,
>         IB_UCM_BASE_MINOR = 224,
> -       IB_UCM_MAX_DEVICES = 32
> +       IB_UCM_MAX_DEVICES = 2
>  };
> 
> 
> I tested all 3 drivers this way (uverbs, umad, ucm). I verified that
> we're not leaking device numbers on multiple modprobe/rmmod cycles,
> that there aren't any funny interactions when various combinations of
> the drivers are loaded.
> 
> I did not test the rest of the OFED stack. I did write some trivial
> programs to open the devices in /dev and close them again.
> 
> Here's an example of some of the testing:
> 
> 	dl585g2:~ # modprobe ib_uverbs
> 	dl585g2:~ # modprobe ib_umad
> 	dl585g2:~ # modprobe ib_ucm
> 	dl585g2:~ # ls -l /dev/uverb*
> 	crw-rw---- 1 root root 231, 192 Feb  2 05:55 /dev/uverbs0
> 	crw-rw---- 1 root root 231, 193 Feb  2 05:55 /dev/uverbs1
> 	crw-rw---- 1 root root 249,   0 Feb  2 05:55 /dev/uverbs2
> 	crw-rw---- 1 root root 249,   1 Feb  2 05:55 /dev/uverbs3
> 	dl585g2:~ # ls -l /dev/umad*
> 	crw-rw---- 1 root root 231, 0 Feb  2 05:55 /dev/umad0
> 	crw-rw---- 1 root root 231, 1 Feb  2 05:55 /dev/umad1
> 	crw-rw---- 1 root root 231, 2 Feb  2 05:55 /dev/umad2
> 	crw-rw---- 1 root root 231, 3 Feb  2 05:55 /dev/umad3
> 	crw-rw---- 1 root root 248, 0 Feb  2 05:55 /dev/umad4
> 	crw-rw---- 1 root root 248, 1 Feb  2 05:55 /dev/umad5
> 	crw-rw---- 1 root root 248, 2 Feb  2 05:55 /dev/umad6
> 	crw-rw---- 1 root root 248, 3 Feb  2 05:55 /dev/umad7
> 	dl585g2:~ # ls -l /dev/issm*
> 	crw-rw---- 1 root root 231, 4 Feb  2 05:55 /dev/issm0
> 	crw-rw---- 1 root root 231, 5 Feb  2 05:55 /dev/issm1
> 	crw-rw---- 1 root root 231, 6 Feb  2 05:55 /dev/issm2
> 	crw-rw---- 1 root root 231, 7 Feb  2 05:55 /dev/issm3
> 	crw-rw---- 1 root root 248, 4 Feb  2 05:55 /dev/issm4
> 	crw-rw---- 1 root root 248, 5 Feb  2 05:55 /dev/issm5
> 	crw-rw---- 1 root root 248, 6 Feb  2 05:55 /dev/issm6
> 	crw-rw---- 1 root root 248, 7 Feb  2 05:55 /dev/issm7
> 	dl585g2:~ # ls -l /dev/ucm*
> 	crw-rw---- 1 root root 231, 224 Feb  2 05:55 /dev/ucm0
> 	crw-rw---- 1 root root 231, 225 Feb  2 05:55 /dev/ucm1
> 	crw-rw---- 1 root root 247,   0 Feb  2 05:55 /dev/ucm2
> 	crw-rw---- 1 root root 247,   1 Feb  2 05:55 /dev/ucm3
> 
> Note that the major and minor numbers are behaving rather sanely.
> 
> 	dl585g2:~ # rmmod ib_ucm
> 	dl585g2:~ # rmmod ib_uverbs
> 	dl585g2:~ # rmmod ib_umad
> 
> Reset.
> 
> 	dl585g2:~ # modprobe ib_ucm
> 	dl585g2:~ # ls -l /dev/ucm*
> 	crw-rw---- 1 root root 231, 224 Feb  2 05:57 /dev/ucm0
> 	crw-rw---- 1 root root 231, 225 Feb  2 05:57 /dev/ucm1
> 	crw-rw---- 1 root root 248,   0 Feb  2 05:57 /dev/ucm2
> 	crw-rw---- 1 root root 248,   1 Feb  2 05:57 /dev/ucm3
> 
> See that /dev/ucm* devices now have a different major number 
> compared to last time(248 vs 247), since we loaded that driver first.
> 
> But wait, why is it 248 and not 249? Is there a leak somewhere?
> 
> 	dl585g2:~ # ls -l /dev/uverb*
> 	crw-rw---- 1 root root 231, 192 Feb  2 05:57 /dev/uverbs0
> 	crw-rw---- 1 root root 231, 193 Feb  2 05:57 /dev/uverbs1
> 	crw-rw---- 1 root root 249,   0 Feb  2 05:57 /dev/uverbs2
> 	crw-rw---- 1 root root 249,   1 Feb  2 05:57 /dev/uverbs3
> 	dl585g2:~ # rmmod ib_uverbs
> 	ERROR: Module ib_uverbs is in use by ib_ucm
> 
> Ah, ib_ucm is dependent on ib_uverbs, so when we modprobed ib_ucm,
> in reality ib_uverbs got loaded first. See how it has a higher
> major number.
> 
> 	dl585g2:~ # rmmod ib_ucm
> 	dl585g2:~ # rmmod ib_uverbs
> 	dl585g2:~ # modprobe ib_umad
> 	dl585g2:~ # ls -l /dev/umad*
> 	crw-rw---- 1 root root 231, 0 Feb  2 05:58 /dev/umad0
> 	crw-rw---- 1 root root 231, 1 Feb  2 05:58 /dev/umad1
> 	crw-rw---- 1 root root 231, 2 Feb  2 05:58 /dev/umad2
> 	crw-rw---- 1 root root 231, 3 Feb  2 05:58 /dev/umad3
> 	crw-rw---- 1 root root 249, 0 Feb  2 05:58 /dev/umad4
> 	crw-rw---- 1 root root 249, 1 Feb  2 05:58 /dev/umad5
> 	crw-rw---- 1 root root 249, 2 Feb  2 05:58 /dev/umad6
> 	crw-rw---- 1 root root 249, 3 Feb  2 05:58 /dev/umad7
> 	dl585g2:~ # ls -l /dev/issm*
> 	crw-rw---- 1 root root 231, 4 Feb  2 05:58 /dev/issm0
> 	crw-rw---- 1 root root 231, 5 Feb  2 05:58 /dev/issm1
> 	crw-rw---- 1 root root 231, 6 Feb  2 05:58 /dev/issm2
> 	crw-rw---- 1 root root 231, 7 Feb  2 05:58 /dev/issm3
> 	crw-rw---- 1 root root 249, 4 Feb  2 05:58 /dev/issm4
> 	crw-rw---- 1 root root 249, 5 Feb  2 05:58 /dev/issm5
> 	crw-rw---- 1 root root 249, 6 Feb  2 05:58 /dev/issm6
> 	crw-rw---- 1 root root 249, 7 Feb  2 05:58 /dev/issm7
> 
> Finally, after one more reset, we see ib_umad loaded first and
> obtaining the major number of 249.
> 
> v1 -> v2:
> 	- update umad and ucm drivers too
> 
> ---
> 
> Alex Chiang (18):
>       IB/uverbs: convert *cdev to cdev in struct ib_uverbs_device
>       IB/uverbs: remove dev_table
>       IB/uverbs: use stack variable 'devnum' in ib_uverbs_add_one
>       IB/uverbs: use stack variable 'base' in ib_uverbs_add_one
>       IB/uverbs: increase maximum devices supported
>       IB/uverbs: pack struct ib_uverbs_event_file tighter
>       IB/uverbs: whitespace cleanup
>       IB/umad: convert cdev pointers to embedded structs in struct ib_umad_port
>       IB/umad: remove port_table[]
>       IB/umad: use stack variable 'devnum' in ib_umad_init_port
>       IB/umad: use stack variable 'base' in ib_umad_init_port
>       IB/umad: increase maximum devices supported
>       IB/umad: clean whitespace
>       IB/ucm: use stack variable 'devnum' in ib_ucm_add_one
>       IB/ucm: use stack variable 'base' in ib_ucm_add_one
>       IB/ucm: increase maximum devices supported
>       IB/ucm: clean whitespace errors
>       IB/core: pack struct ib_device a little tighter
> 
> 
>  drivers/infiniband/core/ucm.c         |   63 ++++++++++--
>  drivers/infiniband/core/user_mad.c    |  173 +++++++++++++++++----------------
>  drivers/infiniband/core/uverbs.h      |   11 +-
>  drivers/infiniband/core/uverbs_main.c |  175 +++++++++++++++++++--------------
>  include/rdma/ib_verbs.h               |    4 -
>  5 files changed, 255 insertions(+), 171 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
