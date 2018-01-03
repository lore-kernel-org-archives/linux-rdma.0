From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: WARNING in rds_cmsg_rdma_args
Date: Wed, 3 Jan 2018 10:43:11 -0800
Message-ID: <54adea8b-d173-20b2-43cb-fc75d51d74c3@oracle.com>
References: <001a1144d1c8a6b0cd0561db6999@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <001a1144d1c8a6b0cd0561db6999-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: syzbot <syzbot+ef175b5825285531eabf-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Mohamed Ghannam <simo.ghannam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/3/2018 12:58 AM, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on 
> ad036b63ee57df9ab802a4eb20cbbbec66aa4520
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See 

> 
> for information about syzkaller reproducers
> 
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+ef175b5825285531eabf-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> It will help syzbot understand when the bug is fixed. See footer for 
> details.
> If you forward the report, please keep this part and the footer.
> 
> audit: type=1400 audit(1514947982.760:7): avc:  denied  { map } for  
> pid=3468 comm="syzkaller284818" path="/root/syzkaller284818499" 
> dev="sda1" ino=16481 
> scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023 
> tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> WARNING: CPU: 1 PID: 3468 at net/rds/rdma.c:617 
> rds_cmsg_rdma_args+0xe96/0x1360 net/rds/rdma.c:617
> Kernel panic - not syncing: panic_on_warn set ...
> 
+Mohamed Ghannam, who was discussing similar issue and was going
to post fix for it. Checking args->nr_local against 0 upfront would
address this issue as well.

Regards,
Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
