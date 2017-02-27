From: Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ibv_rc_pingpong, rping, and other tools hang with Linux 4.10.0
 and rdma-core 13
Date: Mon, 27 Feb 2017 12:02:07 -0500
Message-ID: <CAE=AiOMqGzMC6sD-cXB_sGRH_L15annm_4WottmY17oCSNZveA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, GAFBlizzard <gtschemer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Youngjae Lee <dhrkaeh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason and Yonatan,

On Mon, Feb 27, 2017 at 11:29 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Feb 26, 2017 at 06:09:34PM +0200, Yonatan Cohen wrote:
>
>> I bisected the rdma-core library and figured out that the following commit
>> introduced this regression:
>> 6b26a9e24739 Use C11 atomics instead of wmb/rmb macros for CPU-only atomics
>>
>> I haven't debugged this yet and would appreciate Jason's input.
>
> Oops, I think I typo'd it here:

> Ie deleted pad_3[31] by mistake!



I just confirmed that reverting the C11 atomics commit (6b26a9e24739)
fixes ibv_rc_pingpong on my two at91 ARM boards.  For some reason the
first few packets seem to send slowly, but once it gets going the rest
send quickly.

Youngjae, I suspect this may correct the issue you reported in
http://www.spinics.net/lists/linux-rdma/msg46451.html.



IMPORTANT:  I had previously found the pad_3[31] issue and corrected
it.  That resulted in wr_id showing up in the kernel with the correct
value, but ibv_rc_pingpong would still sometimes (30% or so?) fail
with "Couldn't post send" "parse WC failed 1" on one side.  Weirdly,
it seems to fail more often just after a reboot, and only occasionally
once I run several tests.

Jason, was it intentional that rmb() was removed with no replacement
in rxe_post_one_recv()?   See
https://github.com/linux-rdma/rdma-core/commit/6b26a9e24739576ac3f4ae308485389a5b285497?diff=split#diff-f6b2d2321c2b3273e3453d055a62fa98
for details.

Unfortunately, even after reverting the C11 atomics commit, I still
seem to observe "Couldn't post send" failures which kill the ping
occasionally.  Is this a known issue?


Thanks,
-G
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
