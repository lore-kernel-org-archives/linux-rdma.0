From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 1/2] IB/iser: set block queue_virt_boundary
Date: Sun, 11 Oct 2015 14:22:37 -0700
Message-ID: <561AD31D.6070701@sandisk.com>
References: <1444577707-15778-1-git-send-email-sagig@mellanox.com>
 <1444577707-15778-2-git-send-email-sagig@mellanox.com>
 <CAJ3xEMhhFSRcMrDm--PD-ekr6hJZZXGk_3JE2iEmmHN0fi=b-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhhFSRcMrDm--PD-ekr6hJZZXGk_3JE2iEmmHN0fi=b-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/11/15 12:04, Or Gerlitz wrote:
> If the 4X assertion made here is correct, why not keeping the current
> BB logic to come into play for such devices? I know that without the
> BB code our driver looks much nicer and elegant, but life is sometimes
> more complex... thoughts?

Hello Or,

Whether or not this 4x assertion is correct, logic like the bounce 
buffer mechanism that is removed by this patch series belongs in the 
block layer core and not in a SCSI LLD.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
