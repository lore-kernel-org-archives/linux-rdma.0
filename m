From: "Chandramouli, Dasaratharaman"
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/7] Add support for OPA classport info
Date: Fri, 28 Apr 2017 16:35:48 -0700
Message-ID: <07556307-eea5-5571-66d7-90be9abebba0@intel.com>
References: <1490053090-32840-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1493403017.3041.166.camel@redhat.com>
 <9a061845-2a2f-3c19-08b3-00a9ddab8292@intel.com>
 <b6f3caf1-7558-1291-b361-ac58932d10ae@intel.com>
 <1493417741.3041.171.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493417741.3041.171.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/28/2017 3:15 PM, Doug Ledford wrote:
> On Fri, 2017-04-28 at 12:23 -0700, Chandramouli, Dasaratharaman wrote:
>>
>> On 4/28/2017 11:47 AM, Chandramouli, Dasaratharaman wrote:
>>>
>>>
>>>
>>> On 4/28/2017 11:10 AM, Doug Ledford wrote:
>>>>
>>>> On Mon, 2017-03-20 at 19:38 -0400, Dasaratharaman Chandramouli
>>>> wrote:
>>>>>
>>>>> This series moves the classport info query initiation and
>>>>> update
>>>>> from callers such as ipoib to the ib_sa module itself. The
>>>>> classport
>>>>> info cache is updated whenever ib_sa receives an appropriate
>>>>> state
>>>>> change event.
>>>>>
>>>>> Since classport info is only used to check if sendonly full
>>>>> member
>>>>> support
>>>>> is enabled by the SM, we expose a function
>>>>> ib_sa_sendonly_fullmem_support
>>>>> that can be called to check if the support is enabled.
>>>>>
>>>>> Additionally, we introduce support for opa classport info.
>>>>> These are
>>>>> defined specifically for OPA devices and expose additional
>>>>> features
>>>>> in the
>>>>> capability mask bits along with longer LID sizes in some of the
>>>>> other
>>>>> fields.
>>>>>
>>>>> Patch 1 to 3 fix checkpatch issues (1 issue type per patch) on
>>>>> two
>>>>> functions that patch 4 then moves around. Patch 5 makes changes
>>>>> to implicitly query and cache classport info. Patch 6 adds
>>>>> verbs capability API for core layers to query and find out if
>>>>> they
>>>>> are running on an OPA device. Finally, patch 7 adds OPA
>>>>> classport
>>>>> info
>>>>> query support.
>>>>
>>>> I took patches 1-6 of this series.  However, I need you to rebase
>>>> patch
>>>> 7 against my current k.o/for-4.12-rdma-netdevice branch as there
>>>> are
>>>> significant conflicts between this and the VNIC patches I've
>>>> already
>>>> taken.
>>>>
>>>
>>> Hi Doug -- I pulled your for-4.12-rdma-netdevice and tried to apply
>>> patch 7. I see no conflicts. It compiled cleanly as well. May be i
>>> am
>>> missing something here. Just want to make sure i have the same
>>> branch as
>>> yours.
>>> Is this your commit at the HEAD currently?
>>>
>>> commit 94d595c56077fd8b0f61701e03fd4b3dc8c62038
>>> Author: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@in
>>> tel.com>
>>> Date:   Mon Mar 20 19:38:09 2017 -0400
>>>
>>>     IB/core: Add rdma_cap_opa_ah to expose opa address handles
>>>
>>>
>>> Thanks,
>>> Dasa
>>
>> I take that back. It does fail to compile when OPA_VNIC is enabled
>> since
>> struct opa_class_port_info is defined at multiple locations. I will
>> re-spin this series and in lieu of patch 7, i will submit two
>> patches,
>> the first one would cleanup some of the re-defined structure
>> definitions
>> and the next one would add SA support for OPA class port info.
>
> If it were just a matter of removing the duplicate definition in the
> vnic driver, I would have done that myself (and in fact I *did* do that
> myself and then reverted the patches when the compile problems were
> considerably more complex than that).  The vnic driver and this
> obviously touch some of the same things.

Yes one common field needed to be renamed in this patch. I had done 
that, built and tested it but failed to git --amend the patch before 
submitting. I have fixed it and sent you that one patch which should 
apply and build fine.

Since the vnic driver has
> been accepted, this patchset needs to treat it as something that must
> be maintained.  Breaking the vnic driver with this patchset is not an
> option, it's a regression.

I understand, that was not my intention.

Go back to the drawing board, don't respin
> the entire series since I've already taken the first 6 patches, and
> this time don't post the remainder of the patches until the build
> actually works!
>
>> Once this series is accepted, as cleanup, we can look into fixing
>> opa_vnic and hfi1 to use the SA to query for OPA classport info.
>
> No, do this series right.  Make it fix things up as it goes along.And
> make sure it builds!  Also, your other two series are on hold until
> this gets sorted out.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
