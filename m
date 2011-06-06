From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [RFC] [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb
 routines
Date: Mon, 06 Jun 2011 13:35:44 -0500
Message-ID: <4DED1E00.8010508@opengridcomputing.com>
References: <1828884A29C6694DAF28B7E6B8A82373012B5B@ORSMSX101.amr.corp.intel.com> <4DED00A6.4010201@opengridcomputing.com> <4DED105B.1020807@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A82373017894@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373017894-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/06/2011 01:28 PM, Hefty, Sean wrote:
>>> Will this mechanism allow an RDMA provider driver to export a new qp-
>> related operation for use internally bit the
>>> supporting provider library?  IE Not exposes to the RDMA application,
>> but an internal interface between the library
>>> and driver.  I have need for this with the T4 driver.
>> Sorry about my bad English:
>>
>> "internally bit the" should be "internally by the".
>>
>> And "IE Not exposes" should be "IE Not exposed".
> I don't fully understand this request.  The idea is that libibverbs does not change as new extensions are added by providers, and that there is only 1 version of libibverbs (from Roland's tree).  This does not try to extend the kernel interfaces in any way.  If kernel patches are required, my thinking is that the provider library should communicate directly with the patched kernel.
>
> That said, libibverbs _could_ obtain some sort of non-published interface to a provider and make use of it.  Roland would need to accept any such patches.
>
> Btw, adding the ibv_extension_mask to kernel commands (ib_user_verbs_cmd_*), rather than simply taking the next value, should help avoid breaking the ABI when dealing with patched kernels.
>

See my answer to Roland's question as to what I'm trying to do.  I guess your proposal isn't what I'm needing...


>>>> Users which make use extensions are aware that they are not
>>>> only using an extended call, but are given information regarding
>>>> how widely the extension by be supported.
>>> Can you expand on the above sentence?  I don't get the "how widely
>> supported" angle?
> The idea is that the extension name indicates if it's common to verbs, specific to a vendor, or supported by some external group, such as OFA.  E.g. you can have vendor specific XRC ops, OFA XRC ops, or ibverbs XRC ops.
>
> - Sean


I see.  Thanks.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
