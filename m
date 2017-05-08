From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rdma-core: define link speed and link width enums
Date: Mon, 8 May 2017 20:17:06 +0530
Message-ID: <CANjDDBgeoiayNScofG=4CFUNbbqmizbvgtpWSHXcPqhatRSQoA@mail.gmail.com>
References: <1494251057-1060-1-git-send-email-devesh.sharma@broadcom.com>
 <20170508135404.GD10073@mtr-leonro.local> <e66a9fca-c6b3-ef6e-98b9-08d39bcc72d9@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e66a9fca-c6b3-ef6e-98b9-08d39bcc72d9-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 8, 2017 at 7:35 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On 05/08/2017 09:54 AM, Leon Romanovsky wrote:
>>
>> On Mon, May 08, 2017 at 09:44:17AM -0400, Devesh Sharma wrote:
>>>
>>> Currently application either need to define its own enum
>>> values for link-speed and link-width or use hard coded
>>> values. This patch inharits the enums from kernel space
>>> ib_verbs.h and puts into verbs.h for ease of programming.
>>>
>>> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>> ---
>>>  libibverbs/examples/devinfo.c | 22 ++++++++++++----------
>>>  libibverbs/verbs.h            | 18 ++++++++++++++++++
>>>  2 files changed, 30 insertions(+), 10 deletions(-)
>>
>>
>> I think the better approach will be move these defines from
>> include/rdma/ib_verbs.h to include/uapi/rdma/ib_user_verbs.h
>> and reuse ib_user_verbs.h file directly in libibverbs.
>
>
> I agree on this. Please put this stuff in the uapi header file and include
> that in user space.

Done, will post a V1 with 2 patches...

>
> -Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
