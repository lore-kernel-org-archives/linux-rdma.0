From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] Installation problems of OFED-1.5.2
Date: Thu, 24 Feb 2011 10:46:58 +0200
Message-ID: <4D661B02.8030106@dev.mellanox.co.il>
References: <AANLkTi=s7YtdX2+bb4pLY035OXQSqyf21JuxatDCL=N_@mail.gmail.com>	<4D64CFEA.1030805@dev.mellanox.co.il> <AANLkTinLQ0zo1jbENOAoaDTVi6dmpPn3zTSfY12q-gxf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinLQ0zo1jbENOAoaDTVi6dmpPn3zTSfY12q-gxf-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tanin <fanqielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/23/2011 09:02 PM, Tanin wrote:
> Oh, yes. Thanks so much! After uninstall all libibverbs packages, the
> OFED-1.5.3-rc5 successfully passed all building process:
>
>
> Install iscsi-initiator-utils RPM:
> Running rpm -iv
> /atlas/data18a/litan/OFED-1.5.3-rc5/RPMS/sl-release-5.5-1/x86_64/iscsi-initiator-utils-2.0-869.2.x86_64.rpm
>
> The default IPoIB interface configuration is based on DHCP.
> Note that a special patch for DHCP is required for supporting IPoIB.
> The patch is available under docs/dhcp
> If you do not have DHCP, you must change this configuration in the following
> steps.
> IPoIB interfaces configured successfully
> Press any key to continue ...
> Installation finished successfully.
> Press any key to continue...
>
> It seems that the IPoIB is not configured due to DHCP issues.
>
> And the OFED tools did not work also:
>
> [litan@tera05 OFED-1.5.3-rc5]$ sudo ibv_devinfo
> Failed to get IB devices list: Function not implemented
> [litan@tera05 OFED-1.5.3-rc5]$ sudo ibstat
> sudo: ibstat: command not found
>
>

Make sure that drivers are loaded: run "/etc/init.d/openibd restart".
ibstat is provided by infiniband-diags RPM.

Regards,
Vladimir

>
>
>
>
> On Wed, Feb 23, 2011 at 4:14 AM, Vladimir Sokolovsky<
> vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>  wrote:
>
>> On 02/23/2011 05:12 AM, Tanin wrote:
>>
>>>   Dear all,
>>>
>>> I have recompiled the kernel to 2.6.18, and try to install  OFED-1.5.2
>>> instead.
>>>
>>> Now the kernel version is
>>>
>>> [litan@tera04 OFED-1.5.2]$ uname -a
>>> Linux tera04.ultralight.org 2.6.18-prep #1 SMP Tue Feb 22 18:51:00 EST
>>> 2011
>>> x86_64 x86_64 x86_64 GNU/Linux
>>>
>>>
>>> I have the full log file in the attachment. Dose it related to that I try
>>> many times to install different version of OFED? Thanks a million!
>>>
>>>
>> OFED's backport system is rely on kernel version.
>> So, changing kernel version changes the set of patches and headers to be
>> used for the compilation.
>> You should keep the kernel version as close as possible to the original
>> version.
>> E.g.:
>> If you compile 2.6.18 from kernel.org then you can name it 2.6.18-prep
>> But, if you recompile 2.6.18-164.el5, then you should name it
>>   2.6.18-164.<any extension>.el5
>>
>> Regards,
>> Vladimir
>>
>
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
