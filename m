From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/core: Support for CMA multicast join flags
Date: Mon, 4 Jul 2016 15:40:10 +0300
Message-ID: <CAJ3xEMgErk9Gu8g98dxkdjRP6aiq6hdkAOPj-a2zKLSTwaGZ0w@mail.gmail.com>
References: <1467550074-24061-1-git-send-email-leon@kernel.org>
 <1467550074-24061-3-git-send-email-leon@kernel.org> <CAJ3xEMjqkn09zFXZ5Fj3wvtM3GSa=vzgTuuVoAFENToa4Zh4uw@mail.gmail.com>
 <20160704045111.GA5289@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160704045111.GA5289-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 4, 2016 at 7:51 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Sun, Jul 03, 2016 at 04:46:23PM +0300, Or Gerlitz wrote:
>> On Sun, Jul 3, 2016 at 3:47 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >
>>
>> >  drivers/infiniband/core/cma.c    | 98 +++++++++++++++++++++++++++++++++++++---
>> >  drivers/infiniband/core/ucma.c   | 18 ++++++--
>> >  include/rdma/ib_sa.h             |  5 ++
>> >  include/rdma/rdma_cm.h           |  4 +-
>> >  include/uapi/rdma/rdma_user_cm.h |  9 +++-
>> >  5 files changed, 122 insertions(+), 12 deletions(-)
>>
>>
>> For the ease/robustness of review for UAPI changes, we have a long
>> time common practice
>> to break things like this one to IB core kernel only patch, and one
>> that deals the user-space

> You are right, this practice exists and we are following it as much as it makes sense.
> This specific case doesn't need to be separated, because it introduces one logical
> change and separate patches will be useless as standalone patches.

Leon,

The point is that you need to get people to be used to that practice,
and it seems we're not doing that. Otherwise I wouldn't have to chat
for 20m with 2-3 people that wonder why I made these comments. I think
we should require it from the developers, period and not argue on
that. B/c in bunch of other places, it is totally required, for
example, here you could just carve this small piece to be part of your
UAPI patch, what's wrong with that?

--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -244,12 +244,19 @@ struct rdma_ucm_join_ip_mcast {
  __u32 id;
 };

 struct rdma_ucm_join_mcast {
  __u64 response; /* rdma_ucma_create_id_resp */
  __u64 uid;
  __u32 id;
  __u16 addr_size;
- __u16 reserved;
+ __u16 join_flags;
  struct sockaddr_storage addr;
 };

basically it would be good to have the ucma part there as well, but if
you and Co can't come up with patch planning that allows that is
bisects, lets it be just the header file. This way we come with strict
message to the developers that we want them to break patches to
non-UAPI and yes-UAPI + user-space facing and have them to stop argue
and complain.

> All properties which we are looking in the patch (correct logic, bisectable,
> buildable and easy reviewable) exist in this patch.

read above. This is (1) needed for robust bisection (2) team education

>> facing things (e.g here ucma.c and rdma_user_cm.h), please do that.

> We will be happy to hear other feedback as well.

feel free to hear and hear but please address the arguments brought here

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
