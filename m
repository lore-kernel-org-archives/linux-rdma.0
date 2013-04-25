From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFS over RDMA benchmark
Date: Thu, 25 Apr 2013 16:14:15 -0400
Message-ID: <51798E97.1000200@talpey.com>
References: <0EE9A1CDC8D6434DB00095CD7DB873462CF96C65@MTLDAG01.mtl.com> <CABgxfbF7c9ktSoMSPV21JU76V5J4iwbJQ257S91Y3z36WJbJVA@mail.gmail.com> <62745258-4F3B-4C05-BFFD-03EA604576E4@ornl.gov> <CABgxfbGxhnKj2n0Z-w87rZ6fwCssO31G009gwej957gv1p8PQQ@mail.gmail.com> <0EE9A1CDC8D6434DB00095CD7DB873462CF9715B@MTLDAG01.mtl.com> <20130423210607.GJ3676@fieldses.org> <0EE9A1CDC8D6434DB00095CD7DB873462CF988C9@MTLDAG01.mtl.com> <20130424150540.GB20275@fieldses.org> <20130424152631.GC20275@fieldses.org> <CABgxfbHShU7aEttJ35vdAjXduPFFj8+E4=5LZqOgh4e=5bax5Q@mail.gmail.com> <CABgxfbHpNgQyEjd2OVNMgJoLpt_VyLiOL5hMCLwotMd5kincwg@mail.gmail.com> <517823E0.4000402@talpey.com> <CABgxfbHePAyq6AH9TFKZKUmwEHOupuYUnfc1W99HAuDkYddUqQ@mail.gmail.com> <51797D8D.1080302@psu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51797D8D.1080302-8DAjSxpRXgY@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Phil Pishioneri <pgp-8DAjSxpRXgY@public.gmane.org>
Cc: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/25/2013 3:01 PM, Phil Pishioneri wrote:
> On 4/25/13 1:18 PM, Wendy Cheng wrote:
>> On Wed, Apr 24, 2013 at 11:26 AM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>>> 1)
>>>
>>> The client slot count is not hard-coded, it can easily be changed by
>>> writing a value to /proc and initiating a new mount. But I doubt that
>>> increasing the slot table will improve performance much, unless this is
>>> a small-random-read, and spindle-limited workload.
>> It was a shot in the dark :)  .. as our test bed has not been setup
>> yet .However, since I'll be working on (very) slow clients, increasing
>> this buffer is still interesting (to me). I don't see where it is
>> controlled by a /proc value (?) - but that is not a concern at this
>> moment as /proc entry is easy to add. More questions on the server
>> though (see below) ...
>
> Might there be confusion between the RDMA slot table and the TCP/UDP
> ones (which have proc entries under /proc/sys/sunrpc)?
>

No, the xprtrdma.ko creates similar slot table controls when it loads.
See the names below, prefixed with "rdma":

> tmt@Home:~$ ls /proc/sys/sunrpc
> max_resvport  nfsd_debug  nlm_debug  tcp_fin_timeout             tcp_slot_table_entries  udp_slot_table_entries
> min_resvport  nfs_debug   rpc_debug  tcp_max_slot_table_entries  transports
> tmt@Home:~$ sudo insmod xprtrdma
> tmt@Home:~$ ls /proc/sys/sunrpc
> max_resvport  nlm_debug                  rdma_memreg_strategy     tcp_fin_timeout             udp_slot_table_entries
> min_resvport  rdma_inline_write_padding  rdma_pad_optimize        tcp_max_slot_table_entries
> nfsd_debug    rdma_max_inline_read       rdma_slot_table_entries  tcp_slot_table_entries
> nfs_debug     rdma_max_inline_write      rpc_debug                transports
> tmt@Home:~$


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
