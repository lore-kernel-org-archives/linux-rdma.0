From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 for-next 7/7] IB/core: Change completion channel to use
 the reworked objects schema
Date: Sun, 9 Apr 2017 18:13:29 +0300
Message-ID: <CAAKD3BA570=vSBmSPtY9GH3edErVB6+TyVxpBiOAa=XthkmeGg@mail.gmail.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-8-git-send-email-matanb@mellanox.com> <20170329145344.GB2586@obsidianresearch.com>
 <CAAKD3BCaq2xndM_xtU7OY=wX2Mvw0y2+sqWBg-BSQPKYpfyEWg@mail.gmail.com>
 <20170329222935.GB30605@obsidianresearch.com> <CAAKD3BBwiKPLaOvKbmKL0skr8gv3=9==_60L6HiU4SmqGrJOOw@mail.gmail.com>
 <20170330161226.GB19074@obsidianresearch.com> <CAAKD3BANZG4966aFz4mDa-xPhVbqrNiuAs_=ZvBcft1SzU5eEA@mail.gmail.com>
 <20170405161030.GE11251@obsidianresearch.com> <CAAKD3BC-QU1C_npobthpyZxHQ-QEkWSVPXVtvGdEFu6jwtgwww@mail.gmail.com>
 <20170406164220.GB7657@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170406164220.GB7657-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 6, 2017 at 7:42 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Apr 06, 2017 at 05:10:51PM +0300, Matan Barak wrote:
>> Effectively this kref is used to capture the dependencies between
>> various objects.
>
> No, that is what the usecnt is for, the kref is just to make sure we
> can still *access* the usecnt without derefing freed memory.
>

There are three usecnt(s) actually. One is intended to determine how
many readers
(or if there's a writer) currently accessing this uobject. Zero here
means no one
accessing this uobject and we could lock it for either read/write.
This is uverbs only.

Another one is to protect the lifetime of the uobject.

The last usecnt is intended to capture dependencies, meaning when use_cnt > 1
we can't free that object as there are dependent objects. Nowadays,
this use_cnt is
in the verbs layer and semi-protects (when things are doing serially)
kernel layer as well.

>> This won't solve the "inc_uobject_kref; destroy_uobject" schema, as
>> in this case we really want to destroy the object, but we want to
>> keep the uobject alive in order to get information about the
>> object's state at destruction.
>
> Right, this is why I said you need a destory_uobject varient that
> retains the kref with the caller.
>

So currently we have three states in uverbs (when an object is destroyed):
(a) uobject is alive, object is alive
(b) uobject is alive, object isn't
(c) both are destroyed

You need to somehow capture the second state. This is used in order to
write the updated last
information when an object is destroyed (so no new events could be
generated on this object).

>> If we use kref on the uobject only, we lose the kref count in ULPs.
>> Moreover, we'll need to somehow
>
> No, we can't really do that obviously..
>
> I'd rather see the usecnt hoisted entirely into the uverbs layer where
> it can work sanely with proper locking and reserve a second
> for-debugging-only WARN_ON scheme in the verbs layer that checks
> cleanup ordering for the kapi.
 >
> The kapi returning error codes on destroy is insane, I cleaned up PD
> at one point, but they all need fixing...
>

The current solution in the verbs layer is really half baked. It works
well as long
as you don't try to use an object while destroying it. If you do such
a non-sense action,
you should do that proper locking and checking yourself.

So, if we move that to a uobject, we need three reference counts:
(a) read_write_count
(b) dependencies_count (or object_refcount)
(c) uobject_refcount

Anyway, this is really unrelated to the ABI work. In any solution we
choose right now, we could
move that reference count from objects to uobjects later on. The
purpose here isn't doing a cleanup.
The locking change was done as the new ABI relies on that new behavior
to be dead-lock free, but the
refcount change change could be delayed without risking anything.

> Jason

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
