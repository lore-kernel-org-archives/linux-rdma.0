From: "Thomas Rosenstein" <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>
Subject: Re: iSER Connection via LIO not working
Date: Wed, 14 Jun 2017 18:16:07 +0200
Message-ID: <881ADBDD-3970-4197-B920-28FA36EEF7AC@creamfinance.com>
References: <2E68B5D1-49CF-4F2C-B7F3-DA20E05503B8@creamfinance.com>
 <CAANLjFraKgxAC09VH8u72SbQZs8WhXnnk87VQB0ywoVavC2hSg@mail.gmail.com>
 <2E0A092F-9530-44FB-8A6F-D76D8E94ABE0@creamfinance.com>
 <CAANLjFqg1ked1Ls0W=BRRw5o5vheHKnUw5C_5OVciFQd0H8djg@mail.gmail.com>
 <827EC8DD-86E7-4011-8F68-B29396B2034D@creamfinance.com>
 <CAANLjFqt_RqU6UFPCcZJ5Mec-ku__YErFb-VLrV4Qx9G7ArAZA@mail.gmail.com>
 <1790271E-1A6B-492D-B4B6-701873B23A01@creamfinance.com>
 <32E1700B9017364D9B60AED9960492BC3431F8F1@fmsmsx120.amr.corp.intel.com>
 <1496939302.3028.3.camel@wdc.com>
 <32E1700B9017364D9B60AED9960492BC3431F91D@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; markup=markdown
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC3431F91D-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi

I ran into a second bug, but I'm not sure where to check that:

[150874.509144] iSCSI Target < 0
[150874.509146] iSCSI Login negotiation failed.
[150874.525818] Moving to TARG_CONN_STATE_FREE.
[150876.307247] Added timeout timer to iSCSI login request for 15 
seconds.
[150876.307250] Moving to TARG_CONN_STATE_XPT_UP.
[150877.307358] Received iSCSI login request from 10.0.13.23:36088 on 
IB/iSER Network Portal 10.0.13.3:3260
[150877.307360] Moving to TARG_CONN_STATE_IN_LOGIN.

the iSCSI Target < 0 is from me and is placed at

  rc = iscsi_target_locate_portal(np, conn, login);

  if (rc < 0) {
      pr_debug("iSCSI Target < 0");


I added more logs there, the issue is, it's only happening after a few 
hours with new connections!
Anyone experienced that, or has an idea what the issue could be?

BTW logging in the iSCSI Target and Portal needs to be improved!

BR
Thomas

On 8 Jun 2017, at 18:35, Marciniszyn, Mike wrote:

>> From: Bart Van Assche [mailto:Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org]
>> Sent: Thursday, June 8, 2017 12:28 PM
>> To: robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org; thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org;
>> Marciniszyn, Mike <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: iSER Connection via LIO not working
>>
>> On Thu, 2017-06-08 at 16:23 +0000, Marciniszyn, Mike wrote:
>>> This appears to be the only storage ULP that reads this field 
>>> exported from
>> drivers.
>>
>> Hello Mike,
>>
>> Are you sure of this? This is what grep tells me:
>>
>
> I only checked within ulp.    Perhaps it is a wider issue.
>
> srp appears to only use the variable when use_fast_reg is set, which 
> looks to be based on the device exported bit.
>
> Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
