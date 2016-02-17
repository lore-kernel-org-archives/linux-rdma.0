From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 15/21] IB/srpt: Log private data associated with REJ
Date: Wed, 17 Feb 2016 15:24:00 -0800
Message-ID: <56C50110.7060003@sandisk.com>
References: <56BCDAAD.7030906@sandisk.com> <56BCDC1C.107@sandisk.com>
 <56C49854.6010204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C49854.6010204-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/17/2016 07:57 AM, Doug Ledford wrote:
> On 02/11/2016 02:08 PM, Bart Van Assche wrote:
>> To make it possible to determine why an initiator sent a REJ,
>> log the private data associated with the received REJ packet.
>
> This particular function is all sorts of broken...I fixed it up as I
> took it in.  But, issues were:
>
> 1) We always allocate priv even when private_data_len is 0
> 2) Since we always allocate priv, the test for priv in the pr_info args
> isn't really helpful, but the way the test is set up, if priv exists,
> then we actually pass NULL, if it doesn't, we pass the static string.
> 3) In the event we have priv and private data, then there is a nit about
> formatting because priv will end with a space right before the null
> terminator, which makes the period in the pr_info format hang out in
> open space.
>
> My changes:
>
> 1) Only alloc priv if private_data_len is not 0
> 2) Change priv to be space prepended instead of space postpended
> 3) Change pr_info format to work with space prepended string
> 4) Fix test in pr_info args

Hello Doug,

Thanks for stepping in and addressing this. But as far as I can see 
these changes have not yet been pushed out to the k.o/for-4.6 branch on 
git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git ? I will 
have another look once your tree is publicly available.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
