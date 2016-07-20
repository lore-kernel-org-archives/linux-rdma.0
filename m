From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 0/5] Reduce RDMA RW API SGE limit
Date: Wed, 20 Jul 2016 08:07:34 -0700
Message-ID: <8b8d2e22-4fb9-466f-5321-0745748bd793@sandisk.com>
References: <8fb358c3-3504-02ca-fcb8-1624f28be1b0@sandisk.com>
 <1465736110.5730453.1468948485702.JavaMail.zimbra@redhat.com>
 <93123318.5861700.1469025833903.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <93123318.5861700.1469025833903.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/20/2016 07:43 AM, Laurence Oberman wrote:
 > [ ... ]
> I am not sure yet if something in the  4.7.0-rc7 base changed ALUA behavior, likely that is the case.
> I have to go back and check.
>
> On an older kernel with recent patches from you and Leon everything looks fine and is working fine.
>
> 4.7.0-rc1.bartleon+
>
> 360001ff0b035d000000000098d79000a dm-11 DDN     ,SFA14K
> size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
> |-+- policy='round-robin 0' prio=90 status=active
> | `- 1:0:0:9  sdt  65:48  active ready running
> `-+- policy='round-robin 0' prio=50 status=enabled
>   `- 2:0:0:9  sdv  65:80  active ready running
> 360001ff0b035d000000000078d770008 dm-9 DDN     ,SFA14K
> size=29T features='1 queue_if_no_path' hwhandler='0' wp=rw
> |-+- policy='round-robin 0' prio=90 status=active
> | `- 2:0:0:7  sds  65:32  active ready running
> `-+- policy='round-robin 0' prio=50 status=enabled
>   `- 1:0:0:7  sdp  8:240  active ready running

Hello Laurence,

Can you check your /etc/multipath.conf? In the multipath -ll output 
"hwhandler" should be something like hwhandler='1 alua' instead of '0' 
when communicating with an array that supports ALUA.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
