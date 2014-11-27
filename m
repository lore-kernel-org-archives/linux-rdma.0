From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 00/16] ib_mad: Add support for Intel Omni-Path Architecture
 (OPA) MAD processing.
Date: Thu, 27 Nov 2014 12:02:35 +0200
Message-ID: <5476F6BB.1020200@mellanox.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
 <CAJ3xEMhtm99dRdcEvhK9s961mDr7YSU3pkv-WK=sESKe_K4kYw@mail.gmail.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CBC6B23@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CBC6B23-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/25/2014 11:52 PM, Weiny, Ira wrote:
>> On Thu, Nov 13, 2014 at 9:54 PM,  <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>> The following patch series modifies the kernel MAD processing
>>> (ib_mad/ib_umad) and related interfaces to process Intel Omni-Path
>>> Architecture MADs on devices which support them.
>> So this series allows to process such mad when it arrives or goes beyond that
>> and allows to send such mad too?
> Both send and receive is supported.  My apologies for not being clear.
>
>>> In addition to supporting some IBTA management classes, OPA devices
>>> use MADs with lengths up to 2K.  These "jumbo" MADs increase the
>>> performance of management traffic.
>> Can you provide 1-2 use cases where such mads will be sent and by what
>> entity? I recall 2KB mads were mentioned over our LWG talks 8 years ago on IB
>> routers...
> The Intel Omni-Path driver and SM will be the entities using these MADs.  The patch series is written such that other devices could use jumbo MAD's but there is no attempt to predict how other technologies would do so.
>
> [snip]
>
>>>    [RFC PATCH 07/16] ib/mad: create a jumbo MAD kmem_cache
>> why not use a single kmem-cache instance with a non hard coded element size,
>> 256B (or whatever we use today) or 2KB?
> I wanted to be able to adjust the element count of the caches separately to better tune overall memory usage.  However, I stopped short of adding additional module parameters to adjust the 2K cache at this time.


I tend to think that the resulted code is too much of a special purpose 
one under a  (jumbo == 2K) assumption. See some more comments in the 
individual patches and we'll take it from there.



>
>> Also (nit), please change the prefix for all patches to be IB/mad: and not
>> ib/mad: to comply with the existing habit of patch titles for the IB subsystem
> I will thanks.

Good. See below another easy-to-fix nitpicking comment, but before that, 
for the sake of easier
review and post-robustness of the code to future bisections, please do a 
re-ordering
of the series such that all general refactoring and pre-patches come 
before the OPApatches.

This goes to re-order the current series such tat patches 8/9/10 are 
located after patch 14, as
listed here:

   [RFC PATCH 01/16] ib/mad: rename is_data_mad to is_rmpp_data_mad
   [RFC PATCH 02/16] ib/core: add IB_DEVICE_JUMBO_MAD_SUPPORT device cap
   [RFC PATCH 03/16] ib/mad: Add check for jumbo MADs support on a device
   [RFC PATCH 04/16] ib/mad: add base version parameter to
   [RFC PATCH 05/16] ib/mad: Add MAD size parameters to process_mad
   [RFC PATCH 06/16] ib/mad: Create jumbo_mad data structures
   [RFC PATCH 07/16] ib/mad: create a jumbo MAD kmem_cache
   [RFC PATCH 11/16] ib/mad: create helper function for
   [RFC PATCH 12/16] ib/mad: create helper function for
   [RFC PATCH 13/16] ib/mad: create helper function for
   [RFC PATCH 14/16] ib/mad: Create helper function for SMI processing
   [RFC PATCH 08/16] ib/mad: Add Intel Omni-Path Architecture defines
   [RFC PATCH 09/16] ib/mad: Implement support for Intel Omni-Path
   [RFC PATCH 10/16] ib/mad: Add registration check for Intel Omni-Path
   [RFC PATCH 15/16] ib/mad: Implement Intel Omni-Path Architecture SMP
   [RFC PATCH 16/16] ib/mad: Implement Intel Omni-Path Architecture General

Another easy-to-fix nitpicking comment would be to have all the patches 
be consistent w.r.t to the capitalization
of the 1st letter in the 1st word after the IB/core: or IB/mad:  prefix, e.g

ib/mad: create helper function for smi_handle_dr_smp_send

becomes

IB/mad: Create helper function for smi_handle_dr_smp_send

BTW, here my personal preference is "Add helper" and not "Create helper"

IB/mad: Add helper function for smi_handle_dr_smp_send



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
