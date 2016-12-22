From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] redhat/spec: various fixes and cleanups
Date: Thu, 22 Dec 2016 13:03:16 -0500
Message-ID: <707ea2f1-af9e-c351-1560-02726a1a38ab@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
 <fe84ce7a-dd7f-1b63-ac84-5a0ed5f3bcea@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fe84ce7a-dd7f-1b63-ac84-5a0ed5f3bcea-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2016-12-22 11:53 AM, Doug Ledford wrote:
> On 12/21/2016 5:08 PM, Jarod Wilson wrote:
>> This is a set of patches to fix up a few things in the Red Hat (Fedora)
>> rdma-core spec file that came up as part of the Fedora new package review
>> process, where we're working on getting rdma-core into Fedora in place of
>> the old split packages.
>>
>> Fedora package review bug:
>>   https://bugzilla.redhat.com/show_bug.cgi?id=1404043
>>
>> Jarod Wilson (6):
>>   redhat/spec: call it srp_daemon in desc, not srptools
>>   redhat/spec: improve base package description
>>   redhat/spec: use fully versioned Requires on base package
>>   redhat/spec: fix up %post scriptlets
>>   redhat/spec: clean up rsocket packaging
>>   redhat/spec: make sure docdir is owned
>>
>>  redhat/rdma-core.spec | 65 +++++++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 47 insertions(+), 18 deletions(-)
>>
>
> Thanks, series applied and -rc3 generated, so future fixes will need to
> be incremental.

Okay, I just sent an incremental patch with a number of other spec 
fixups resulting from discussion here and in the review bug.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
