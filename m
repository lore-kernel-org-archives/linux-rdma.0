From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [for-next 1/5] RDMA/bnxt_re: Enable RoCE on virtual functions
Date: Tue, 9 Jan 2018 19:37:31 +0530
Message-ID: <CANjDDBgG0zHqBRky=UzekBnNKrJyjgc06m4UivRTn5xu1gqE0w@mail.gmail.com>
References: <1515152434-13105-1-git-send-email-devesh.sharma@broadcom.com>
 <1515152434-13105-2-git-send-email-devesh.sharma@broadcom.com> <1515449549.3403.112.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515449549.3403.112.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 9, 2018 at 3:42 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2018-01-05 at 06:40 -0500, Devesh Sharma wrote:
>> From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>
>> Currently, fifty percent of the total available resources
>> are reserved for PF and remaining are equally divided among
>> active VFs.
>>
>> +/*
>> + * Percentage of resources of each type reserved for PF.
>> + * Remaining resources are divided equally among VFs.
>> + * [0, 100]
>> + */
>> +#define BNXT_RE_PCT_RSVD_FOR_PF         50
>
> This is a separate comment from the patch review itself.  But, are you
> sure this is a good idea?  And especially are you sure that it should be
> a compile time constant and not a runtime parameter?
>
Keeping a compile time constant is indeed not a good idea and I completely
understand that if we have had a knob there it would had been much much
better and flexible.
For this submission we wanted to avoid the use of module-parameter or configfs
interface. Thus, as a workaround this is hard-coded compile time
constant is used.
Eventually, more flexible scheme would be supplied to change this.

> I ask because it seems to me that usage of this stuff falls into one of
> two categories:
>
> 1) All bare metal usage
> 2) SRIOV usage (in which case the bare metal OS does relatively little,
> the SRIOV using clients do most of the work)
>
> I guess I'm finding it hard to imagine a scenario where, when you do
> have SRIOV VFs, that you don't want the majority of all resources being
> used there.
>
> I might suggest that you simply don't split resources at all.  Maybe do
> something like filesystems do.  Let anyone at all take a resource until
> you hit 95% utilization then only root can write to the filesystem.  In
> this case it would be let both PFs and VFs use resources at will up
> until you hit the 95% utilization threshold and then restrict resource
> use to the PF.  That would make much more sense to me.

This is indeed an excellent suggestion to optimize the resource
utilization between
PFs and VFs, however, I have couple of facts to put forward

- If I have understood it correctly then this would require an
independent entity which
  would keep track of what percentage of resources has been utilized
at any given
  point in time by all the functions (PF and its VFs). Currently, we
do not have such
  implementation in firmware and PF driver cannot track or resource
utilization across
  functions.

- In the current implementation hard-coding 50% does not hard-limit PFs with 50%
  it can still over-subscribe upto max limit even though max VFs are active.

- With the equal distribution of remaining resources among VFs we are
trying to avail
  minimum guaranteed resources to max possible VFs on a given PF. We
want to avoid
  the case where number of usable VFs depend on the current usage of
resources consumed
  by already active VFs.


>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
