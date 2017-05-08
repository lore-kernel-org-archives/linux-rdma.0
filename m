From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rdma-core: define link speed and link width enums
Date: Mon, 8 May 2017 22:30:29 +0530
Message-ID: <CANjDDBjDwuL8dn4ACkeGw-bBge6_fhFN5DqSAK6h0SPBGeds+Q@mail.gmail.com>
References: <1494251057-1060-1-git-send-email-devesh.sharma@broadcom.com>
 <20170508135404.GD10073@mtr-leonro.local> <e66a9fca-c6b3-ef6e-98b9-08d39bcc72d9@intel.com>
 <CANjDDBgeoiayNScofG=4CFUNbbqmizbvgtpWSHXcPqhatRSQoA@mail.gmail.com> <20170508161212.GA18125@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170508161212.GA18125-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 8, 2017 at 9:42 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, May 08, 2017 at 08:17:06PM +0530, Devesh Sharma wrote:
>> On Mon, May 8, 2017 at 7:35 PM, Dennis Dalessandro
>> <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > On 05/08/2017 09:54 AM, Leon Romanovsky wrote:
>> >>
>> >> On Mon, May 08, 2017 at 09:44:17AM -0400, Devesh Sharma wrote:
>> >>>
>> >>> Currently application either need to define its own enum
>> >>> values for link-speed and link-width or use hard coded
>> >>> values. This patch inharits the enums from kernel space
>> >>> ib_verbs.h and puts into verbs.h for ease of programming.
>> >>>
>> >>> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> >>>  libibverbs/examples/devinfo.c | 22 ++++++++++++----------
>> >>>  libibverbs/verbs.h            | 18 ++++++++++++++++++
>> >>>  2 files changed, 30 insertions(+), 10 deletions(-)
>> >>
>> >>
>> >> I think the better approach will be move these defines from
>> >> include/rdma/ib_verbs.h to include/uapi/rdma/ib_user_verbs.h
>> >> and reuse ib_user_verbs.h file directly in libibverbs.
>> >
>> >
>> > I agree on this. Please put this stuff in the uapi header file and include
>> > that in user space.
>>
>> Done, will post a V1 with 2 patches...
>
> Relying on the kernel header from a uapi header means that we now
> require the distro to have a sufficient version of that kernel header.
Which means we need to have a mechanism to track the versions.
is relying on the ABI version is good enough or you see any blockers there..
>
> This might be OK, but you have to check to see what distros are
> including (cbuild --run-shell can help with this)
And if a given distro is not including then fall-back to current
scheme, is it okay
to have defining/un-defining compile time macros to enable/disable certain code
sections?
>
> Further, I seem to recall last time I lookd at this that using the
> kernel header was hard because there were lots of name conflicts
> that had to be resolved first. It would be great to see that done of
> course..
Thanks for the heads-up, I am still trying to understand the complete
problem, reviewing what we have
currently I will get back if there are any questions.
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
