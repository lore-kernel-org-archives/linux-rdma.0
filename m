From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/4] libocrdma update series
Date: Fri, 26 Feb 2016 20:37:47 +0530
Message-ID: <CANjDDBhkCu4iP-iOUEeY7CnbZ7_AUJSSd1iYx55AcTHRq5f0cA@mail.gmail.com>
References: <1456386647-22315-1-git-send-email-devesh.sharma@broadcom.com> <56D06992.5030104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D06992.5030104-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks Doug,

I will pull this series to libocrdma git and release new version.

-Regards
Devesh

On Fri, Feb 26, 2016 at 8:34 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 02/25/2016 02:50 AM, Devesh Sharma wrote:
>> This series includes couple of bug fixes and support for RoCE-v2
>> for user space applicaitons.
>>
>> Patch 0001 adds support for RoCE-v2 to userland applications
>>
>> Patch 0002 and 0003 are bug fixes to avoid build warnings
>>
>> Patch 0004 updates the version string
>>
>> Devesh Sharma (4):
>>   RDMA/libocrdma: Add user space support for RoCE-v2
>>   RDMA/libocrdma: Fix compile time warnings
>>   RDMA/libocrdma: Remove async-event hook from context ops
>>   RDMA/libocrdma: Update libocrdma version string
>>
>>  configure.in       |  4 +--
>>  src/ocrdma_abi.h   |  2 +-
>>  src/ocrdma_main.c  |  1 -
>>  src/ocrdma_main.h  |  5 +++-
>>  src/ocrdma_verbs.c | 76 +++++++++++-------------------------------------------
>>  5 files changed, 22 insertions(+), 66 deletions(-)
>>
>
> Series looks reasonable to me.
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
