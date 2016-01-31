From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv5 0/3] rdmacg: IB/core: rdma controller support
Date: Sun, 31 Jan 2016 15:25:29 +0530
Message-ID: <CAG53R5V24HNTnL6bLACYx0Owxzh5Jyk2Ks=jBryEP5h=euZSBQ@mail.gmail.com>
References: <1454214912-10965-1-git-send-email-pandit.parav@gmail.com>
	<20160131094605.GR32380@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160131094605.GR32380-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 31, 2016 at 3:16 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Sun, Jan 31, 2016 at 10:05:09AM +0530, Parav Pandit wrote:
>> Changes from v4:
>>  * Fixed compilation errors for lockdep_assert_held reported by kbuild
>>    test robot
>>  * Fixed compilation warning reported by coccinelle for extra semicolon.
>>  * Fixed compilation error for inclusion of linux/parser.h which cannot
>>    be included in any header file, as that triggers multiple inclusion
>>    error. Instead parser.h is included in C files which intent to use it.
>>  * Removed unused header file inclusion in cgroup_rdma.c
>>
>> Changes from v3:
>>  * (To address comments from Tejun)
>>    1. Renamed cg_resource to rdmacg_resource
>>    2. Merged dealloc_cg_rpool and _dealloc_cg_rpool to single function
>>    3. Renamed _find_cg_rpool to find_cg_rpool_locked()
>>    5. Removed RDMACG_MAX_RESOURCE_INDEX limitation
>>    6. Fixed few alignments.
>>    7. Improved description for RDMA cgroup configuration menu
>>    8. Renamed cg_list_lock to rpool_list_lock to reflect the lock
>>       is for rpools.
>>    9. Renamed _get_cg_rpool to find_cg_rpool.
>>    10. Made creator as int variable, instead of atomic as its not
>>       required to be atomic.
>>  * Fixed freeing right rpool during query_limit error path
>>  * Added copywrite for cgroup.c
>>  * Removed including parser.h from cgroup.c as its included by cgroup_rdma.h
>>  * Reduced try_charge functions to single function and removed duplicate
>>    comments.
>
> Please don't send out patchsets in rapid succession while design
> discussion is still in progress.  It's tiring for everyone involved.
>
Sorry about that. Sent out v4 mainly for kbuild complains.
Sent out v3 to actually address your comments. While reviewing found
one or two more issues, so fixed them as well.
Lets base discussion on v5 or v3, whichever you prefer.

> Thanks.
>
> --
> tejun
