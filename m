From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/uverbs: Make the code in ib_uverbs_cmd_verbs()
 less confusing
Date: Wed, 18 Oct 2017 10:42:41 -0400
Message-ID: <1508337761.46071.69.camel@redhat.com>
References: <20171016154745.10033-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016154745.10033-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-10-16 at 08:47 -0700, Bart Van Assche wrote:
> This patch reduces the number of #ifdefs and also avoids that
> smatch reports the following:
> 
> drivers/infiniband/core/uverbs_ioctl.c:276: ib_uverbs_cmd_verbs()
> warn: if statement not indented
> drivers/infiniband/core/uverbs_ioctl.c:280: ib_uverbs_cmd_verbs()
> warn: possible memory leak of 'ctx'
> drivers/infiniband/core/uverbs_ioctl.c:315: ib_uverbs_cmd_verbs()
> warn: if statement not indented
> 
> References: commit fac9658cabb9 ("IB/core: Add new ioctl interface")
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Acked-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
