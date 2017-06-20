From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Tue, 20 Jun 2017 08:43:39 -0600
Message-ID: <CAANLjFr6cJN5kxJ_UvnzdRU8sOThbj0wW0WJFJSi9Bivsux0RA@mail.gmail.com>
References: <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me>
 <20170515143632.GH3616@mtr-leonro.local> <20170515145952.GA7871@infradead.org>
 <20170515170506.GK3616@mtr-leonro.local> <779753075.36035391.1495025796237.JavaMail.zimbra@kalray.eu>
 <20170518133439.GD3616@mtr-leonro.local> <CAANLjFrCLpX3nb3q7LpFPpLJKciU+1Hvmt_hxyTovQJM2-zQmg@mail.gmail.com>
 <6073e553-e8c2-6d14-ba5d-c2bd5aff15eb@grimberg.me> <20170620074639.GP17846@mtr-leonro.local>
 <1c706958-992e-b104-6bae-4a6616c0a9f9@grimberg.me> <20170620083309.GQ17846@mtr-leonro.local>
 <bd0b986f-9bed-3dfa-7454-0661559a527b@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bd0b986f-9bed-3dfa-7454-0661559a527b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 20, 2017 at 3:33 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>
>>>> Here the parsed output, it says that it was access to mkey which is
>>>> free.
>
>
> Missed that :)
>
>>>> ======== cqe_with_error ========
>>>> wqe_id                           : 0x0
>>>> srqn_usr_index                   : 0x0
>>>> byte_cnt                         : 0x0
>>>> hw_error_syndrome                : 0x93
>>>> hw_syndrome_type                 : 0x0
>>>> vendor_error_syndrome            : 0x52
>>>
>>>
>>> Can you share the check that correlates to the vendor+hw syndrome?
>>
>>
>> mkey.free == 1
>
>
> Hmm, the way I understand it is that the HW is trying to access
> (locally via send) a MR which was already invalidated.
>
> Thinking of this further, this can happen in a case where the target
> already completed the transaction, sent SEND_WITH_INVALIDATE but the
> original send ack was lost somewhere causing the device to retransmit
> from the MR (which was already invalidated). This is highly unlikely
> though.
>
> Shouldn't this be protected somehow by the device?
> Can someone explain why the above cannot happen? Jason? Liran? Anyone?
>
> Say host register MR (a) and send (1) from that MR to a target,
> send (1) ack got lost, and the target issues SEND_WITH_INVALIDATE
> on MR (a) and the host HCA process it, then host HCA timeout on send (1)
> so it retries, but ehh, its already invalidated.
>
> Or, we can also have a race where we destroy all our MRs when I/O
> is still running (but from the code we should be safe here).
>
> Robert, when you rebooted the target, I assume iscsi ping
> timeout expired and the connection teardown started correct?

I do remember that the ping timed out and the connection was torn down
according to the messages.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
