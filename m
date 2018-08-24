From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Subject: Re: [PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Fri, 24 Aug 2018 15:28:33 +0200
Message-ID: <86bd94d5-0ce8-c67f-07a5-ca9ebf399cdd@gmail.com>
References: <20180824113248.GH29735@dhcp22.suse.cz>
 <b088e382-e90e-df63-a079-19b2ae2b985d@gmail.com>
 <20180824115226.GK29735@dhcp22.suse.cz>
 <a27ad1a3-34bd-6b7d-fd09-7737ec3c888d@gmail.com>
 <20180824120339.GL29735@dhcp22.suse.cz>
 <eb546bcb-9c5f-7d5d-43a7-bfde489f0e7f@amd.com>
 <20180824123341.GN29735@dhcp22.suse.cz>
 <b11df415-baf8-0a41-3c16-60dfe8d32bd3@amd.com>
 <20180824130132.GP29735@dhcp22.suse.cz>
 <23d071d2-82e4-9b78-1000-be44db5f6523@gmail.com>
 <20180824132442.GQ29735@dhcp22.suse.cz>
Reply-To: christian.koenig@amd.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180824132442.GQ29735@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, christian.koenig@amd.com
Cc: kvm@vger.kernel.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, Dimitri Sivanich <sivanich@sgi.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
List-Id: linux-rdma@vger.kernel.org

Am 24.08.2018 um 15:24 schrieb Michal Hocko:
> On Fri 24-08-18 15:10:08, Christian König wrote:
>> Am 24.08.2018 um 15:01 schrieb Michal Hocko:
>>> On Fri 24-08-18 14:52:26, Christian König wrote:
>>>> Am 24.08.2018 um 14:33 schrieb Michal Hocko:
>>> [...]
>>>>> Thiking about it some more, I can imagine that a notifier callback which
>>>>> performs an allocation might trigger a memory reclaim and that in turn
>>>>> might trigger a notifier to be invoked and recurse. But notifier
>>>>> shouldn't really allocate memory. They are called from deep MM code
>>>>> paths and this would be extremely deadlock prone. Maybe Jerome can come
>>>>> up some more realistic scenario. If not then I would propose to simplify
>>>>> the locking here. We have lockdep to catch self deadlocks and it is
>>>>> always better to handle a specific issue rather than having a code
>>>>> without a clear indication how it can recurse.
>>>> Well I agree that we should probably fix that, but I have some concerns to
>>>> remove the existing workaround.
>>>>
>>>> See we added that to get rid of a real problem in a customer environment and
>>>> I don't want to that to show up again.
>>> It would really help to know more about that case and fix it properly
>>> rather than workaround it like this. Anyway, let me think how to handle
>>> the non-blocking notifier invocation then. I was not able to come up
>>> with anything remotely sane yet.
>> With avoiding allocating memory in the write lock path I don't see an issue
>> any more with that.
>>
>> All what the write lock path does now is adding items to a linked lists,
>> arrays etc....
> Can we change it to non-sleepable lock then?

No, the write side doesn't sleep any more, but the read side does.

See amdgpu_mn_invalidate_node() and that is where you actually need to 
handle the non-blocking flag correctly.

Christian.
